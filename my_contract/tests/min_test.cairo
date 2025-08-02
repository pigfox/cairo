#[cfg(test)]
#[feature("deprecated-starknet-consts")]
mod tests {
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use snforge_std::{declare, ContractClassTrait, DeclareResultTrait, start_cheat_caller_address_global, stop_cheat_caller_address_global};

    // Define the contract interface
    #[starknet::interface]
    trait IMinNFT<TContractState> {
        fn mint(ref self: TContractState, to: ContractAddress, token_id: u256);
        fn owner_of(self: @TContractState, token_id: u256) -> ContractAddress;
        fn total_supply(self: @TContractState) -> u256;
        fn name(self: @TContractState) -> felt252;
        fn symbol(self: @TContractState) -> felt252;
    }

    #[test]
    fn test_constructor() {
        // Declare and deploy the contract
        let contract_class = declare("min_nft").expect('Failed to declare contract');
        let constructor_args = array!['TestNFT', 'TNFT'];
        let (contract_address, _) = contract_class.contract_class().deploy(@constructor_args).expect('Failed to deploy contract');
        
        // Create dispatcher
        let dispatcher = IMinNFTDispatcher { contract_address };

        // Verify constructor values
        let name = dispatcher.name();
        let symbol = dispatcher.symbol();
        assert(name == 'TestNFT', 'Invalid name');
        assert(symbol == 'TNFT', 'Invalid symbol');
        assert(dispatcher.total_supply() == 0_u256, 'Invalid initial supply');
    }

    #[test]
    fn test_mint_nft() {
        // Declare and deploy the contract
        let contract_class = declare("min_nft").expect('Failed to declare contract');
        let constructor_args = array!['NFT', 'N'];
        let (contract_address, _) = contract_class.contract_class().deploy(@constructor_args).expect('Failed to deploy contract');

        // Define user and token_id
        let user = contract_address_const::<0xCAFE>();
        let token_id = 7_u256;

        // Mint the NFT
        start_cheat_caller_address_global(user);
        let dispatcher = IMinNFTDispatcher { contract_address };
        dispatcher.mint(user, token_id);
        stop_cheat_caller_address_global();

        // Verify ownership
        let owner = dispatcher.owner_of(token_id);
        assert(owner == user, 'Invalid owner');

        // Verify total supply
        let supply = dispatcher.total_supply();
        assert(supply == 1_u256, 'Invalid supply');
    }

    #[test]
    #[should_panic(expected: ('Already minted',))]
    fn test_mint_already_minted() {
        // Declare and deploy the contract
        let contract_class = declare("min_nft").expect('Failed to declare contract');
        let constructor_args = array!['NFT', 'N'];
        let (contract_address, _) = contract_class.contract_class().deploy(@constructor_args).expect('Failed to deploy contract');

        // Define user and token_id
        let user = contract_address_const::<0xCAFE>();
        let token_id = 7_u256;

        // Mint the NFT once
        start_cheat_caller_address_global(user);
        let dispatcher = IMinNFTDispatcher { contract_address };
        dispatcher.mint(user, token_id);

        // Attempt to mint the same token_id again (should fail)
        dispatcher.mint(user, token_id);
        stop_cheat_caller_address_global();
    }
}