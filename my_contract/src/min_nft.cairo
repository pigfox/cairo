#[starknet::contract]
#[feature("deprecated-starknet-consts")]
mod min_nft {
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use starknet::storage::{
        StoragePointerReadAccess, StoragePointerWriteAccess,
        StorageMapReadAccess, StorageMapWriteAccess, Map
    };

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        total_supply: u256,
        owner_of: Map<u256, ContractAddress>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Mint: Mint
    }

    #[derive(Drop, starknet::Event)]
    struct Mint {
        to: ContractAddress,
        token_id: u256
    }

    #[constructor]
    fn constructor(ref self: ContractState, name: felt252, symbol: felt252) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.total_supply.write(0_u256);
    }

    #[external(v0)]
    fn mint(ref self: ContractState, to: ContractAddress, token_id: u256) {
        let current_owner = self.owner_of.read(token_id);
        assert(current_owner == contract_address_const::<0>(), 'Already minted');
        self.owner_of.write(token_id, to);
        let _supply = self.total_supply.read();
        self.total_supply.write(_supply + 1_u256);
        self.emit(Mint { to, token_id });
    }

    #[external(v0)]
    fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
        self.owner_of.read(token_id)
    }

    #[external(v0)]
    fn total_supply(self: @ContractState) -> u256 {
        self.total_supply.read()
    }

    #[external(v0)]
    fn name(self: @ContractState) -> felt252 {
        self.name.read()
    }

    #[external(v0)]
    fn symbol(self: @ContractState) -> felt252 {
        self.symbol.read()
    }
}