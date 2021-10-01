pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract tcg is ERC721URIStorage {
     // number of all cards existing on contract
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseURI;

    // mapping for cards owned per user
    mapping(address=>uint[]) public userOwnedCards;
    mapping(uint=>uint) public cardIndex;

    constructor(string memory tokenName, string memory symbol) ERC721("TradingCard", "TCG") public {
        // IPFS protocol is used to store the metadata of cards
        _setBaseURI("ipfs://");
    }

    // mints a new card to msg.sender, emits a Transfer event
    function createCard(string memory _tokenURI) public returns (uint256) {
        _tokenIds.increment();

        uint new_id = _tokenIds.current();

        // add to list of owned cards per user
        userOwnedCards[msg.sender].push(new_id);
        uint arrLen = userOwnedCards[msg.sender].length;
        cardIndex[new_id] = arrLen;

        _safeMint(msg.sender, new_id);
        _setTokenURI(new_id, _tokenURI); 

        return new_id;
    }

    function _setBaseURI(string memory _newURI) internal {
        baseURI = _newURI;
    }

    function _baseURI() internal view override returns (string memory)  {
        return baseURI;
    }
}