pragma solidity >=0.4.22 <0.9.0;

contract Ownable {
    address public owner;

    constructor() {
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
    uint public numCards = 0;
    mapping(address => uint) balance;

    struct Card {
        uint id;
        string name;
        string desc;
        uint price;
        bool owned;
        //uint excl;
    }

    event CardCreated(
        uint id,
        string name,
        string desc,
        uint price,
        bool owned
    );
    // uint excl

    uint public numCards = 0;
    // Mapping of all cards
    mapping(uint => Card) cards;
    // A mapping of owned cards
    mapping(address => Card) ownershipToCard;

    constructor() public {
    }


    // allows users to create new cards, however costing 
    // should probably have some algo to determine price of card (either custom or automatic) - custom for now.
    function createCard(string memory _name, string memory _desc,uint _price)  public {
        numCards++;
        cards[numCards] = Card(numCards, _name, _desc,_price,false);
        emit CardCreated(numCards, _name, _desc,_price,false);
    }

    function buyCard(uint _id) public payable {
        require(cards[_id].owned == false, "Owned card selected.");
        require(msg.sender.balance > cards[_id].price, "Insufficient funds in your account");

        
    }
}
/*sidenote: for a function to actually withdraw/fund ether to an address,
the payable modifier has to set otherwise the transaction will be rejected
*/


contract cardOwnership {
    
}