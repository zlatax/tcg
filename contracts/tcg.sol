pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        if(newOwner != address(0)) {
            owner = newOwner;
        }
    }
}

contract tcg {
    /* Attributes of a card.
    A card contains,
    - id: unique id (uint)
    - Name
    - Description 

    All cards can only exist one copy.

    Feature to be added later
    - Exclusivity: number of limited supply of a given card*/

    // word count limitations for name and desc of card
    uint constant NAME_LIMIT = 10; 
    uint constant DESC_LIMIT = 30;
    // number of all cards existing on contract
    uint public numCards = 0;
    // Mapping of all cards
    mapping(uint => Card) cards;
    // A mapping of owned cards
    mapping(uint => address) ownershipToCard;

    struct Card {
        uint id;
        string name;
        string desc;
        uint createPrice;
        bool owned;
        //uint excl;
    }

    event CardCreated(
        uint id,
        string name,
        string desc,
        uint createPrice,
        address owner
    );
    // uint excl

    event Transfer(
        address _from,
        address _to,
        uint cardId
    );

    

    constructor() public {
    }


    // allows users to create new cards, however costing 
    // should probably have some algo to determine price of card (either custom or automatic) - custom for now.
    function createCard(string memory _name, string memory _desc, uint _price)  public payable {
        require(msg.sender.balance >= _price, "Insufficient funds to create card!");
        
        numCards++;
        cards[numCards] = Card(numCards, _name, _desc,_price,true);

        _transfer(address(0), msg.sender, numCards);

        // charge user's eth account
        address payable owner = payable(msg.sender);
        owner.transfer(_price);

        emit CardCreated(numCards, _name, _desc,_price,msg.sender);
    }

    // Function to buy card off the market (pool of cards owned by the contract)
    // not owned by any USERS.

    // function _buyCard(uint _id) public {
    //     require(_cardExists(_id), "ID not issued to any exisiting card");
    //     require(cards[_id].owned == false, "Owned card selected.");
    //     require(msg.sender.balance >= cards[_id].price, "Insufficient funds to create card!");
        
    //     msg.sender.send(uint price);
    // }

    // returns the price of card dependent on the total supply and weight of card
    // i.e., the length of both name and description of card
    // - String manipulations/operations are very costly in solidity and smart contracts
    // therefore, it might be better to include the logic of calculating the price in the DAPP side
    // and padd in the price into buycard function.
    
    // function _calcPrice(uint _id) internal returns (uint){      
    //     return tx.gasprice*(cards[_id].)
    // }

    function _transfer(address _from, address _to, uint _cardId) internal {
        // Destination address should not be...
        // safe guard against zero-address
        require(_to!=address(0));
        // For now, the contract cannot hold any cards (can add market feature in future)
        require(_to!=address(this));
        // sender must own card
        if(_from!=address(0)) {
            require(_owns(_from, _cardId), "Sender does not have ownership of card");
        }
        ownershipToCard[_cardId] = _to;

        emit Transfer(_from, _to, _cardId);
    }

    function _cardExists(uint _id) internal view returns (bool){
        return cards[_id].id != 0;
    }

    function _owns(address _claimant, uint _cardId) internal view returns (bool){
        return ownershipToCard[_cardId] == _claimant;
    }
}
/*sidenote: for a function to actually withdraw/fund ether to an address,
the payable modifier has to set otherwise the transaction will be rejected
*/