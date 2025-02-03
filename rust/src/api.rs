use std::env;

use anyhow::Result;
use serde::Serialize;
use tokio::runtime::Runtime;

use iota_sdk::{
    client::{
        utils::request_funds_from_faucet,
        Client,
    },
    types::{
        api::core::response::OutputWithMetadataResponse,
        block::{
            address::Bech32Address,
            payload::transaction::{
                TransactionEssence,
                TransactionId
            },
            unlock::Unlocks,
            BlockId,
        },
    },
    wallet::account::types::InclusionState,
};

mod wallet_custom;

#[derive(Debug, Clone)]
pub struct NetworkInfo {
    pub node_url: String,
    pub faucet_url: String,
}

/// A transaction to move funds.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct MyTransactionPayload {
    pub ess: TransactionEssence,
    pub unl: Unlocks,
}

#[derive(Debug, Clone)]
pub struct TransactionParams {
    pub transaction_tag: String,
    pub transaction_metadata: String,
    pub receiver_address: String,
    pub storage_deposit_return_address: String,
}

#[derive(Serialize)]
struct TransactionDetails {
    pub transaction_id: TransactionId, // Example field to serialize
    //payload: TransactionPayload,
    pub payload: String,
    pub metadata: String,
    pub block_id: Option<BlockId>,
    pub inclusion_state: InclusionState,
    // Transaction creation time
    pub timestamp: u128,
    // network id to ignore outputs when set_client_options is used to switch to another network
    pub network_id: u64,
    // set if the transaction was created by the wallet or if it was sent by someone else and is incoming
    pub incoming: bool,
    pub note: Option<String>,
    // serde(default) is needed so it doesn't break with old dbs
    pub inputs: Vec<OutputWithMetadataResponse>,
}

#[derive(Serialize)]
struct TransactionDetailsCustom {
    pub transaction_id: String,
    pub metadata: String,
    pub timestamp: u128,
    pub incoming: bool,
}

#[derive(Debug, Clone)]
pub struct WalletInfo {
    pub alias: String,
    pub mnemonic: String,
    pub stronghold_password: String,
    pub stronghold_filepath: String,
    pub last_address: String,
}

#[derive(Debug, Clone)]
pub struct BaseCoinBalance {
    /// Total amount
    pub total: u64,
    /// Balance that can currently be spent
    pub available: u64,
}

#[allow(dead_code)]
pub fn get_node_info(network_info: NetworkInfo) -> Result<String> {
    Runtime::new().unwrap().block_on(async {
        // Create a client with that node.
        let client = Client::builder()
            .with_node(&network_info.node_url)?
            .with_ignore_node_health()
            .finish()
            .await?;
        // Get node info.
        let info = client.get_info().await?.node_info;
        Ok(serde_json::to_string_pretty(&info).unwrap())
    })
}

#[allow(dead_code)]
pub fn generate_mnemonic() -> String {
    let mnemonic = Client::generate_mnemonic();
    mnemonic.unwrap().to_string()
}

#[allow(dead_code)]
pub fn request_funds(network_info: NetworkInfo, wallet_info: WalletInfo) -> Result<String> {
    Runtime::new().unwrap().block_on(async {
        env::set_current_dir(&wallet_info.stronghold_filepath).ok();
        let faucet_url = network_info.faucet_url;
        // Convert given address (BECH32 string) to Address struct
        let address = Bech32Address::try_from_str(&wallet_info.last_address)?;
        // Use the function iota_wallet::iota_client::request_funds_from_faucet
        let faucet_response = request_funds_from_faucet(&faucet_url, &address).await?;
        Ok(faucet_response.to_string())
    })
}

////////////////////////////////new/////////////////////////////
#[allow(dead_code)]
pub fn create_iota_account(
    network_info: NetworkInfo,
    wallet_info: WalletInfo,
) -> Result<String> {
    wallet_custom::create_iota_account(network_info,wallet_info)
}

#[allow(dead_code)]
pub fn write_advanced_transaction(
    transaction_params: TransactionParams,
    wallet_info: WalletInfo,
) -> Result<String> {
    wallet_custom::write_advanced_transaction(transaction_params, wallet_info)
}

#[allow(dead_code)]
pub fn read_incoming_transactions(wallet_info: WalletInfo) -> Result<String> {
    wallet_custom::read_transactions(wallet_info, true)
}

#[allow(dead_code)]
pub fn read_outgoing_transactions(wallet_info: WalletInfo) -> Result<String> {
    wallet_custom::read_transactions(wallet_info, false)
}

#[allow(dead_code)]
pub fn get_balance(wallet_info: WalletInfo) -> Result<String> {
    wallet_custom::get_balance(wallet_info)
}

#[allow(dead_code)]
pub fn get_addresses(wallet_info: WalletInfo) -> Result<String> {
    wallet_custom::get_addresses(wallet_info)
}
////////////////////////////////new/////////////////////////////
