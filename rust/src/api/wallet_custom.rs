use super::{
    NetworkInfo, TransactionDetailsCustom, TransactionParams, WalletInfo,
};
use anyhow::Result;
use iota_sdk::{
    client::{
        constants::SHIMMER_COIN_TYPE,
        secret::{stronghold::StrongholdSecretManager, SecretManager},
    },
    crypto::keys::bip39::Mnemonic,
    types::block::{
        address::Address,
        output::{
            feature::MetadataFeature,
            unlock_condition::{
                AddressUnlockCondition, StorageDepositReturnUnlockCondition,
                TimelockUnlockCondition,
            },
            BasicOutputBuilder, MinimumStorageDepositBasicOutput,
        },
    },
    wallet::{
        account::{types::Transaction, SyncOptions},
        ClientOptions,
    },
    Wallet,
};
use tokio::runtime::Runtime;

pub fn create_iota_account(network_info: NetworkInfo, wallet_info: WalletInfo) -> Result<String> {
    Runtime::new().unwrap().block_on(async {
        let ipact_wallet_db_path = wallet_info.stronghold_filepath.clone();
        let wallet_directory = "walletdb";
        let wallet_path = ipact_wallet_db_path.to_owned() + wallet_directory;

        let stronghold_file_directory = "wallet.stronghold";
        let stronghold_file_path = ipact_wallet_db_path.to_owned() + stronghold_file_directory;

        // Setup Stronghold secret_manager
        let secret_manager = StrongholdSecretManager::builder()
            .password(wallet_info.stronghold_password)
            .build(stronghold_file_path)?;

        // Only required the first time, can also be generated with `manager.generate_mnemonic()?`
        let mnemonic = Mnemonic::from(wallet_info.mnemonic);

        // The mnemonic only needs to be stored the first time
        secret_manager.store_mnemonic(mnemonic).await?;

        let client_options = ClientOptions::new().with_node(&network_info.node_url)?;

        // Create the wallet
        let wallet = Wallet::builder()
            .with_secret_manager(SecretManager::Stronghold(secret_manager))
            .with_storage_path(wallet_path.as_str())
            .with_client_options(client_options)
            .with_coin_type(SHIMMER_COIN_TYPE)
            .finish()
            .await?;

        // Create a new account
        let user_alias = wallet_info.alias.as_str();
        let account = wallet
            .create_account()
            .with_alias(user_alias)
            .finish()
            .await?;

        let addresses = account.addresses().await?;
        Ok(addresses[0].address().to_string())
    })
}

pub fn write_advanced_transaction(
    //network_info: NetworkInfo,
    transaction_params: TransactionParams,
    wallet_info: WalletInfo,
) -> Result<String> {
    Runtime::new().unwrap().block_on(async {
        //let node_url = network_info.node_url;
        //let client_options = ClientOptions::new().with_node(&node_url)?;
        let ipact_wallet_db_path = wallet_info.stronghold_filepath.clone();
        let wallet_directory = "walletdb";
        let wallet_path = ipact_wallet_db_path.to_owned() + wallet_directory;

        //env::set_current_dir(wallet_db_path).ok();

        let wallet = Wallet::builder()
            .with_storage_path(wallet_path.as_str())
            //.with_client_options(client_options)
            .finish()
            .await?;

        let user_alias = wallet_info.alias.as_str();
        let account = wallet.get_account(user_alias).await?;

        let _ = wallet.sync(None).await?;

        let stronghold_password = wallet_info.stronghold_password;

        wallet.set_stronghold_password(stronghold_password).await?;

        //let tag = &transaction_params.transaction_tag.to_string();
        let metadata = &transaction_params.transaction_metadata.to_string();
        let receiver_address =
            Address::try_from_bech32(transaction_params.receiver_address.to_string())?;
        let storage_deposit_return_address = Address::try_from_bech32(
            transaction_params
                .storage_deposit_return_address
                .to_string(),
        )?;

        let token_supply = account.client().get_token_supply().await?;

        let timelock_duration: u64 = (std::time::SystemTime::now()
            + std::time::Duration::from_secs(50 * 360 * 24 * 60 * 60))
        .duration_since(std::time::UNIX_EPOCH)
        .expect("clock went backwards")
        .as_secs()
        .try_into()
        .unwrap();

        let rent_structure: iota_sdk::types::block::output::RentStructure =
            account.client().get_rent_structure().await?;
        let min_storage_deposit_amount =
            MinimumStorageDepositBasicOutput::new(rent_structure, token_supply)
                .with_storage_deposit_return()?
                .finish()?;

        let demo_output = BasicOutputBuilder::new_with_minimum_storage_deposit(rent_structure)
            .add_unlock_condition(AddressUnlockCondition::new(receiver_address)) //cost 42600
            //.add_feature(TagFeature::new(tag.as_bytes())?) //cost after adding Tag 49200 (1 byte)
            .add_feature(MetadataFeature::new(metadata.as_bytes())?) //cost after adding Metadata 62300 (2 byte)
            .add_unlock_condition(TimelockUnlockCondition::new(
                timelock_duration.try_into().unwrap(),
            )?)
            .add_unlock_condition(StorageDepositReturnUnlockCondition::new(
                storage_deposit_return_address,
                min_storage_deposit_amount,
                token_supply,
            )?) //cost after adding StorageDepositReturnUnlockCondition 67000
            .finish_output(token_supply)?;

        let real_output = BasicOutputBuilder::new_with_amount(demo_output.amount())
            //let real_output = BasicOutputBuilder::new_with_minimum_storage_deposit(rent_structure)
            .add_unlock_condition(AddressUnlockCondition::new(receiver_address)) //cost 42600
            //.add_feature(TagFeature::new(tag.as_bytes())?) //cost after adding Tag 49200 (1 byte)
            .add_feature(MetadataFeature::new(metadata.as_bytes())?) //cost after adding Metadata 62300 (2 byte)
            .add_unlock_condition(TimelockUnlockCondition::new(
                timelock_duration.try_into().unwrap(),
            )?)
            .add_unlock_condition(StorageDepositReturnUnlockCondition::new(
                storage_deposit_return_address,
                demo_output.amount(),
                token_supply,
            )?) //cost after adding StorageDepositReturnUnlockCondition 67000
            .finish_output(token_supply)?;

        let transaction: iota_sdk::wallet::account::types::Transaction =
            account.send_outputs(vec![real_output], None).await?;
        account
            .retry_transaction_until_included(&transaction.transaction_id, None, None)
            .await?;
        Ok(serde_json::to_string_pretty(&transaction.transaction_id).unwrap())
    })
}

pub fn prepare_metadata(transaction: &Transaction) -> String {
    if let Some(features) = transaction.payload.essence().as_regular().outputs()[0].features() {
        if let Some(metadata_feature) = features.metadata() {
            if let Ok(metadata_feature) = String::from_utf8(metadata_feature.data().to_vec()) {
                return metadata_feature;
            }
        }
    }
    return "[]".to_string();
}

pub fn read_transactions(wallet_info: WalletInfo, is_incoming: bool) -> Result<String> {
    Runtime::new().unwrap().block_on(async {
        //let node_url = network_info.node_url;
        //let client_options = ClientOptions::new().with_node(&node_url)?;
        let ipact_wallet_db_path = wallet_info.stronghold_filepath.clone();
        let wallet_directory = "walletdb";
        let wallet_path = ipact_wallet_db_path.to_owned() + wallet_directory;

        let wallet = Wallet::builder()
            .with_storage_path(wallet_path.as_str())
            //.with_client_options(client_options)
            .finish()
            .await?;

        let user_alias = wallet_info.alias.as_str();
        let account = wallet.get_account(user_alias).await?;

        //let _ = wallet.sync(None).await?;

        // Sync account
        account
            .sync(Some(SyncOptions {
                sync_incoming_transactions: true,
                ..Default::default()
            }))
            .await?;

        let transactions;

        if is_incoming {
            transactions = account.incoming_transactions().await;
            //transactions = account.transactions().await;
        } else {
            transactions = account.transactions().await;
        }

        let transactions_details = transactions
            .iter()
            .map(|transaction| TransactionDetailsCustom {
                transaction_id: transaction.transaction_id.to_string(),
                metadata: prepare_metadata(transaction),
                timestamp: transaction.timestamp,
                incoming: transaction.incoming,
            })
            .collect::<Vec<TransactionDetailsCustom>>();

        //Ok(transactions_details)
        Ok(serde_json::to_string_pretty(&transactions_details).unwrap())
    })
}

pub fn get_balance(wallet_info: WalletInfo) -> Result<String> {
    Runtime::new().unwrap().block_on(async {
        let ipact_wallet_db_path = wallet_info.stronghold_filepath.clone();
        let wallet_directory = "walletdb";
        let wallet_path = ipact_wallet_db_path.to_owned() + wallet_directory;

        let wallet = Wallet::builder()
            .with_storage_path(wallet_path.as_str())
            .finish()
            .await?;

        let user_alias = wallet_info.alias.as_str();
        let account = wallet.get_account(user_alias).await?;

        // Sync and get the balance
        let balance = account.sync(None).await?;
        Ok(serde_json::to_string_pretty(&balance).unwrap())
    })
}


pub fn get_addresses(wallet_info: WalletInfo) -> Result<String> {
    Runtime::new().unwrap().block_on(async {
        let ipact_wallet_db_path = wallet_info.stronghold_filepath.clone();
        let wallet_directory = "walletdb";
        let wallet_path = ipact_wallet_db_path.to_owned() + wallet_directory;
        let wallet = Wallet::builder()
            .with_storage_path(wallet_path.as_str())
            .finish()
            .await?;

        let user_alias = wallet_info.alias.as_str();
        let account = wallet.get_account(user_alias).await?;
        account.sync(None).await?;
        let account_addresses = account.addresses().await?;

        Ok(serde_json::to_string_pretty(&account_addresses).unwrap())
    })
}
