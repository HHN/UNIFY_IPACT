//use crate::api::{BaseCoinBalance, NetworkInfo, TransactionDetails, WalletInfo};
use crate::api::{NetworkInfo, TransactionDetails, WalletInfo};

use anyhow::{Error, Result};
use iota_sdk::{
    client::{
        constants::SHIMMER_COIN_TYPE,
        secret::{
            stronghold::StrongholdSecretManager as WalletStrongholdSecretManager,
            SecretManager as WalletSecretManager,
        },
    },
    crypto::keys::bip39::Mnemonic,
    types::block::{
        address::{Address, Bech32Address},
        //address::Address,
        output::{
            feature::{MetadataFeature, TagFeature},
            unlock_condition::{
                AddressUnlockCondition, 
                StorageDepositReturnUnlockCondition,
                TimelockUnlockCondition, 
            },
            BasicOutputBuilder,
            MinimumStorageDepositBasicOutput
        }, 
        payload::{transaction::TransactionId, TransactionPayload},
        //payload::transaction::TransactionId,
    },
    wallet::{account::SyncOptions, ClientOptions, Wallet},
};
use serde::{Serialize, Serializer};

use std::env;
use std::fs;
use std::path::PathBuf;
use std::sync::{Mutex, Once};
use tokio::runtime::Runtime;

use super::TransactionParams;

struct WalletSingleton {
    network_info: NetworkInfo,
    wallet_info: WalletInfo,
    wallet: Option<Wallet>,
}

impl WalletSingleton {
    fn new(network_info: NetworkInfo, wallet_info: WalletInfo) -> Result<Self> {
        let mut wallet_singleton = Self {
            network_info,
            wallet_info,
            wallet: None,
        };

        wallet_singleton.create_wallet()?;
        Ok(wallet_singleton)
    }

    fn create_wallet(&mut self) -> Result<String> {
        let rt = Runtime::new().unwrap();
        rt.block_on(async {
            let node_url = &self.network_info.node_url;
            let stronghold_password = self.wallet_info.stronghold_password.clone();
            let stronghold_filepath = self.wallet_info.stronghold_filepath.clone();
            let mnemonic_string: String = self.wallet_info.mnemonic.clone();
            let mnemonic = Mnemonic::from(mnemonic_string);

            // Create the needed directory according to the given path
            let mut path_buf = PathBuf::new();
            path_buf.push(&stronghold_filepath);
            let path = PathBuf::from(path_buf);
            fs::create_dir_all(path).ok();

            // THIS NEXT STEP IS CRUCIAL:
            // Point the "current working directory" to the given path
            env::set_current_dir(&stronghold_filepath).ok();

            // Create the Rust file for the stronghold snapshot file
            let mut path_buf_snapshot = PathBuf::new();
            path_buf_snapshot.push(&stronghold_filepath);
            path_buf_snapshot.push("wallet.stronghold");
            let path_snapshot = PathBuf::from(path_buf_snapshot);

            let secret_manager = WalletStrongholdSecretManager::builder()
                .password(stronghold_password)
                .build(path_snapshot)?;

            // Storing the mnemonic is ONLY REQUIRED THE FIRST TIME
            // calling it TWICE THROWS AN ERROR
            secret_manager.store_mnemonic(mnemonic).await?;

            // Create a ClientBuilder (= client_options in wallet.rs)
            // See wallet.rs:
            // -> src/lib.rs
            // -> line "pub use iota_client::ClientBuilder as ClientOptions"
            let client_options = ClientOptions::new().with_node(&node_url)?;

            // Create the account manager with the secret_manager
            // and client_options (= ClientBuilder).
            // The Client itself is created in the AccountManagerBuilder's finish() method.
            // See wallet.rs:
            // -> src/account_manager/builder.rs
            // -> line "let client = client_options.clone().finish()?;"

            self.wallet = Some(
                Wallet::builder()
                    .with_secret_manager(WalletSecretManager::Stronghold(secret_manager))
                    .with_client_options(client_options)
                    .with_coin_type(SHIMMER_COIN_TYPE)
                    .finish()
                    .await?,
            );

            Ok("Wallet Account was created successfully.".into())
        })
    }

    fn create_account(&self, wallet_info: WalletInfo) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let wallet_alias = wallet_info.alias;
                let account = wallet
                    .create_account()
                    .with_alias((&wallet_alias).to_string())
                    .finish()
                    .await?;
                let addresses = account.addresses().await?;
                Ok(addresses[0].address().to_string())
                //Ok(serde_json::to_string_pretty(&account_addresses).unwrap())
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }

    fn get_addresses(&self, wallet_info: WalletInfo) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;
                wallet.sync(None).await?;
                account.sync(None).await?;
                let account_addresses = account.addresses().await?;
                Ok(serde_json::to_string_pretty(&account_addresses).unwrap())
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }

    fn create_transaction(&self, wallet_info: WalletInfo, transaction_params: TransactionParams) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;
                let balance = wallet.sync(None).await?;
                if balance.base_coin().available() >= 1_000_000 {
                    wallet
                        .set_stronghold_password(wallet_info.stronghold_password)
                        .await?;

                    //let receiver_address = Address::try_from_bech32(transaction_params.receiver_address.to_string())?;
                    let receiver_address = transaction_params.receiver_address.to_string();

                    let transaction = account
                        .send(
                            1_000_000,
                            receiver_address,
                            None,
                        )
                        .await?;
                    // Wait for transaction to get included
                    //let block_id = account.retry_transaction_until_included(&transaction.transaction_id, None, None).await?;
                    account.retry_transaction_until_included(&transaction.transaction_id, None, None).await?;

                    Ok(serde_json::to_string_pretty(&transaction.transaction_id).unwrap())
                } else {
                    Ok(serde_json::to_string_pretty(&balance).unwrap())
                }
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }


     fn create_advanced_transaction(&self, wallet_info: WalletInfo, transaction_params: TransactionParams) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;

                //let balance = wallet.sync(None).await?;
                wallet.sync(None).await?;


                wallet
                    .set_stronghold_password(wallet_info.stronghold_password)
                    .await?;

                //let tag = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia";
                //let metadata = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquy";
                //let receiver_address = Address::try_from_bech32("rms1qqe230uf8vyyxaz5qjcj63zmd94e7n7dsuss40cc43fec2ph3c7yj04ksde")?;
                //let storage_deposit_return_address = Address::try_from_bech32("rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj")?;
                
                let tag= &transaction_params.transaction_tag.to_string();
                let metadata= &transaction_params.transaction_metadata.to_string();
                let receiver_address = Address::try_from_bech32(transaction_params.receiver_address.to_string())?;
                let storage_deposit_return_address = Address::try_from_bech32(transaction_params.storage_deposit_return_address.to_string())?;
                
                let token_supply = account.client().get_token_supply().await?;

                let timelock_duration: u64 = (std::time::SystemTime::now() + std::time::Duration::from_secs(10 * 60))
                    .duration_since(std::time::UNIX_EPOCH)
                    .expect("clock went backwards")
                    .as_secs()
                    .try_into()
                    .unwrap();

                let rent_structure: iota_sdk::types::block::output::RentStructure = account.client().get_rent_structure().await?;
                let min_storage_deposit_amount = MinimumStorageDepositBasicOutput::new(rent_structure, token_supply)
                    .with_storage_deposit_return()?
                    .finish()?;

                let demo_output = BasicOutputBuilder::new_with_minimum_storage_deposit(rent_structure)
                    .add_unlock_condition(AddressUnlockCondition::new(receiver_address))//cost 42600
                    .add_feature(TagFeature::new(tag.as_bytes())?)//cost after adding Tag 49200 (1 byte)
                    .add_feature(MetadataFeature::new(metadata.as_bytes())?)//cost after adding Metadata 62300 (2 byte)
                    .add_unlock_condition(TimelockUnlockCondition::new(timelock_duration.try_into().unwrap())?)
                    .add_unlock_condition(StorageDepositReturnUnlockCondition::new(
                        storage_deposit_return_address,
                        min_storage_deposit_amount,
                        token_supply,
                    )?)//cost after adding StorageDepositReturnUnlockCondition 67000
                    .finish_output(token_supply)?;

                let real_output = BasicOutputBuilder::new_with_amount(demo_output.amount())
                //let real_output = BasicOutputBuilder::new_with_minimum_storage_deposit(rent_structure)
                    .add_unlock_condition(AddressUnlockCondition::new(receiver_address))//cost 42600
                    .add_feature(TagFeature::new(tag.as_bytes())?)//cost after adding Tag 49200 (1 byte)
                    .add_feature(MetadataFeature::new(metadata.as_bytes())?)//cost after adding Metadata 62300 (2 byte)
                    .add_unlock_condition(TimelockUnlockCondition::new(timelock_duration.try_into().unwrap())?)
                    .add_unlock_condition(StorageDepositReturnUnlockCondition::new(
                        storage_deposit_return_address,
                        demo_output.amount(),
                        token_supply,
                    )?)//cost after adding StorageDepositReturnUnlockCondition 67000
                    .finish_output(token_supply)?;

                let transaction: iota_sdk::wallet::account::types::Transaction = account.send_outputs(vec![real_output], None).await?;

                // Wait for transaction to get included
                //let block_id = account.retry_transaction_until_included(&transaction.transaction_id, None, None).await?;
                account.retry_transaction_until_included(&transaction.transaction_id, None, None).await?;
                Ok(serde_json::to_string_pretty(&transaction.transaction_id).unwrap())
                
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }


    fn create_advanced_transaction_old(&self, wallet_info: WalletInfo, transaction_params: TransactionParams) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;

                //let balance = wallet.sync(None).await?;
                wallet.sync(None).await?;


                wallet
                    .set_stronghold_password(wallet_info.stronghold_password)
                    .await?;

                //let tag = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed dia";
                //let metadata = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquy";
                //let receiver_address = Address::try_from_bech32("rms1qqe230uf8vyyxaz5qjcj63zmd94e7n7dsuss40cc43fec2ph3c7yj04ksde")?;
                //let storage_deposit_return_address = Address::try_from_bech32("rms1qp8fjeuth533gjrzj8gg5yhqgfsdsxa45xeta2fntwslmav6mffuquwejdj")?;
                
                let tag= &transaction_params.transaction_tag.to_string();
                let metadata= &transaction_params.transaction_metadata.to_string();
                let receiver_address = Address::try_from_bech32(transaction_params.receiver_address.to_string())?;
                //let storage_deposit_return_address = Address::try_from_bech32(transaction_params.storage_deposit_return_address.to_string())?;
                
                let token_supply = account.client().get_token_supply().await?;

                let timelock_duration: u64 = (std::time::SystemTime::now() + std::time::Duration::from_secs(10 * 60))
                    .duration_since(std::time::UNIX_EPOCH)
                    .expect("clock went backwards")
                    .as_secs()
                    .try_into()
                    .unwrap();

                let rent_structure: iota_sdk::types::block::output::RentStructure = account.client().get_rent_structure().await?;
                /* let min_storage_deposit_amount = MinimumStorageDepositBasicOutput::new(rent_structure, token_supply)
                    .with_storage_deposit_return()?
                    .finish()?; */

                /* let demo_output = BasicOutputBuilder::new_with_minimum_storage_deposit(rent_structure)
                    .add_unlock_condition(AddressUnlockCondition::new(receiver_address))//cost 42600
                    .add_feature(TagFeature::new(tag.as_bytes())?)//cost after adding Tag 49200 (1 byte)
                    .add_feature(MetadataFeature::new(metadata.as_bytes())?)//cost after adding Metadata 62300 (2 byte)
                    .add_unlock_condition(TimelockUnlockCondition::new(timelock_duration.try_into().unwrap())?)
                    .finish_output(token_supply)?; */

                let real_output = BasicOutputBuilder::new_with_minimum_storage_deposit(rent_structure)
                    .add_unlock_condition(AddressUnlockCondition::new(receiver_address))//cost 42600
                    .add_feature(TagFeature::new(tag.as_bytes())?)//cost after adding Tag 49200 (1 byte)
                    .add_feature(MetadataFeature::new(metadata.as_bytes())?)//cost after adding Metadata 62300 (2 byte)
                    .add_unlock_condition(TimelockUnlockCondition::new(timelock_duration.try_into().unwrap())?)
                    .finish_output(token_supply)?;

                let transaction: iota_sdk::wallet::account::types::Transaction = account.send_outputs(vec![real_output], None).await?;

                // Wait for transaction to get included
                //let block_id = account.retry_transaction_until_included(&transaction.transaction_id, None, None).await?;
                account.retry_transaction_until_included(&transaction.transaction_id, None, None).await?;

                Ok(serde_json::to_string_pretty(&transaction.transaction_id).unwrap())
                
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }

    fn generate_address(&self, wallet_info: WalletInfo) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;
                wallet
                    .set_stronghold_password(wallet_info.stronghold_password)
                    .await?;
                let addresses = account.generate_ed25519_addresses(5, None).await?;
                Ok(serde_json::to_string_pretty(&addresses).unwrap())
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }
    

    fn get_sent_transactions(&self, wallet_info: WalletInfo) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;
                
                wallet.sync(None).await?;


                // Sync account
                account.sync(Some(SyncOptions {
                    sync_incoming_transactions: true,
                    ..Default::default()
                })).await?;

                let sent_transactions_details = account.transactions().await.iter()
                .map(|transaction| TransactionDetails {
                    transaction_id: transaction.transaction_id,
                    payload: format!("{:?}", transaction.payload),
                    metadata: format!("{:?}", transaction.payload),

                    block_id: transaction.block_id,
                    inclusion_state: transaction.inclusion_state,
                    timestamp: transaction.timestamp,
                    network_id: transaction.network_id,
                    incoming: transaction.incoming,
                    note: transaction.note.clone(),
                    inputs: transaction.inputs.clone(),
                }).collect::<Vec<TransactionDetails>>();

                /* let mut sent_transactions:Vec<String>  = Vec::new();
                for transaction in account.transactions().await {
                    sent_transactions.push(format!("{:?}", transaction));
                } */
                Ok(serde_json::to_string_pretty(&sent_transactions_details).unwrap())
                //Ok("hi".to_string())
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }


    fn get_received_transactions(&self, wallet_info: WalletInfo) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;
                
                wallet.sync(None).await?;


                // Sync account
                account.sync(Some(SyncOptions {
                    sync_incoming_transactions: true,
                    ..Default::default()
                })).await?;

                let received_transactions_details = account.incoming_transactions().await.iter()
                .map(|transaction| TransactionDetails {
                    transaction_id: transaction.transaction_id,
                    payload: format!("{:?}", transaction.payload),
                    metadata: format!("{:?}", transaction.payload),

                    block_id: transaction.block_id,
                    inclusion_state: transaction.inclusion_state,
                    timestamp: transaction.timestamp,
                    network_id: transaction.network_id,
                    incoming: transaction.incoming,
                    note: transaction.note.clone(),
                    inputs: transaction.inputs.clone(),
                }).collect::<Vec<TransactionDetails>>();

                Ok(serde_json::to_string_pretty(&received_transactions_details).unwrap())
                //Ok("hi".to_string())
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }

    fn get_single_transaction(&self, wallet_info: WalletInfo, transaction_id: String) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;
                
                wallet.sync(None).await?;

                // Sync account
                account.sync(Some(SyncOptions {
                    sync_incoming_transactions: true,
                    ..Default::default()
                })).await?;

                let transaction_id = TransactionId::try_from(transaction_id.as_str()).unwrap();
                let single_transaction_details = account.get_transaction(&transaction_id).await.iter()
                .map(|transaction| TransactionDetails {
                    transaction_id: transaction.transaction_id,
                    payload: format!("{:?}", transaction.payload),
                    metadata: format!("{:?}", transaction.payload),

                    block_id: transaction.block_id,
                    inclusion_state: transaction.inclusion_state,
                    timestamp: transaction.timestamp,
                    network_id: transaction.network_id,
                    incoming: transaction.incoming,
                    note: transaction.note.clone(),
                    inputs: transaction.inputs.clone(),
                }).collect::<Vec<TransactionDetails>>();

            
                Ok(serde_json::to_string_pretty(&single_transaction_details).unwrap())
                //Ok("hi".to_string())
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }


    fn check_balance(&self, wallet_info: WalletInfo) -> Result<String> {
        Runtime::new().unwrap().block_on(async {
            if let Some(ref wallet) = self.wallet {
                env::set_current_dir(&wallet_info.stronghold_filepath).ok();
                let account = wallet.get_account((&wallet_info.alias).to_string()).await?;
                
                //let balance = wallet.sync(None).await?;

                let balance = account.sync(None).await?;
                
                Ok(serde_json::to_string_pretty(&balance).unwrap())
                //Ok("here we go".into())
            } else {
                Err(Error::msg("No wallet set."))
            }
        })
    }
}

lazy_static::lazy_static! {
    static ref WALLET_SINGLETON: Mutex<Option<WalletSingleton>> = Mutex::new(None);
    static ref INIT: Once = Once::new();
}

fn create_wallet_singleton_if_needed(network_info: NetworkInfo, wallet_info: WalletInfo) {
    INIT.call_once(|| {
        if let Ok(wallet_singleton) = WalletSingleton::new(network_info, wallet_info) {
            let mut locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
            *locked_wallet_singleton = Some(wallet_singleton);
        } else {
            // Handle the error
            // You can log an error, panic, or choose an appropriate action.
            panic!("Error creating wallet singleton");
        }
    });
}

pub fn create_wallet_account(network_info: NetworkInfo, wallet_info: WalletInfo) -> Result<String> {
    create_wallet_singleton_if_needed(network_info, wallet_info.clone());
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.create_account(wallet_info)
}

pub fn create_transaction(wallet_info: WalletInfo, transaction_params: TransactionParams) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.create_transaction(wallet_info,transaction_params)
}

pub fn create_advanced_transaction(wallet_info: WalletInfo, transaction_params: TransactionParams) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.create_advanced_transaction(wallet_info, transaction_params)
}

pub fn generate_address(wallet_info: WalletInfo) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.generate_address(wallet_info)
}

pub fn get_sent_transactions(wallet_info: WalletInfo) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.get_sent_transactions(wallet_info)
}

pub fn get_received_transactions(wallet_info: WalletInfo) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.get_received_transactions(wallet_info)
}

pub fn get_single_transaction(wallet_info: WalletInfo, transaction_id: String) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.get_single_transaction(wallet_info,transaction_id)
}

pub fn get_addresses(wallet_info: WalletInfo) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.get_addresses(wallet_info)
}

pub fn check_balance(wallet_info: WalletInfo) -> Result<String> {
    let locked_wallet_singleton = WALLET_SINGLETON.lock().unwrap();
    let wallet_singleton = locked_wallet_singleton.as_ref().unwrap();
    wallet_singleton.check_balance(wallet_info)
}
