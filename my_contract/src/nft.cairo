// src/nft.cairo
#[contract]
mod StarkNFT {
    use starknet::contract;
    use starknet::storage;

    #[storage]
    struct Storage {
        name: felt252,
        symbol: felt252,
        owner_of: LegacyMap<u256, ContractAddress>,
        total_supply: u256,
    }

    #[constructor]
    fn constructor(name: felt252, symbol: felt252) {
        Storage::name.write(name);
        Storage::symbol.write(symbol);
        Storage::total_supply.write(0);
    }

    #[external]
    fn mint(to: ContractAddress, token_id: u256) {
        assert(Storage::owner_of.read(token_id) == 0, 'Already minted');
        Storage::owner_of.write(token_id, to);
        let supply = Storage::total_supply.read();
        Storage::total_supply.write(supply + 1);
    }

    #[view]
    fn ownerOf(token_id: u256) -> ContractAddress {
        return Storage::owner_of.read(token_id);
    }
}
//https://chatgpt.com/c/688d8f12-93b0-832c-9ad0-b3a5c95c2965
// gas https://chatgpt.com/c/688d9f7f-17c8-8325-921c-b85c2417cd3a