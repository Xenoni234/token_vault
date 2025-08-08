module MyModule::TokenVault {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to store user's deposited balance
    struct Vault has key {
        balance: u64,
    }

    /// Deposit tokens into the vault
    public fun deposit(user: &signer, amount: u64) acquires Vault {
    let vault = if (exists<Vault>(signer::address_of(user))) {
        borrow_global_mut<Vault>(signer::address_of(user))
    } else {
        move_to(user, Vault { balance: 0 });
        borrow_global_mut<Vault>(signer::address_of(user))
    };

    let coins = coin::withdraw<AptosCoin>(user, amount);
    coin::deposit<AptosCoin>(signer::address_of(user), coins);
    vault.balance = vault.balance + amount;
}


    /// Withdraw tokens from the vault
    public fun withdraw(user: &signer, amount: u64) acquires Vault {
    let vault = borrow_global_mut<Vault>(signer::address_of(user));
    assert!(vault.balance >= amount, 1); // Insufficient balance

    vault.balance = vault.balance - amount;
    let coins = coin::withdraw<AptosCoin>(user, amount);
    coin::deposit<AptosCoin>(signer::address_of(user), coins); // FIXED
}

}


