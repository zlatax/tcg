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

    // Mapping of all cards
    mapping(uint => Card) cards;
    // A mapping of owned cards
    mapping(uint => address) ownershipToCard;

    constructor() public {
    }


    // allows users to create new cards, however costing 
    // should probably have some algo to determine price of card (either custom or automatic) - custom for now.
    function createCard(string memory _name, string memory _desc,uint _price)  public {
        numCards++;
        cards[numCards] = Card(numCards, _name, _desc,_price,false);
        emit CardCreated(numCards, _name, _desc,_price,false);
    }

    function buyCard(uint _id) public {
        require(_cardExists(_id), "ID not issued to any exisiting card");
        require(cards[_id].owned == false, "Owned card selected.");
        require(msg.sender.balance >= cards[_id].price, "Insufficient funds to create card!");
        
        balance[msg.sender] += cards[_id].price;
    }

    function transferOwnership(address _from, address _to, uint _cardId) {
        if()
    }

    function _cardExists(uint _id) internal view returns (bool){
        return (cards[_id].id != 0);
    }

    function _owns(address _claimant, uint _cardId)
}
/*sidenote: for a function to actually withdraw/fund ether to an address,
the payable modifier has to set otherwise the transaction will be rejected
*/