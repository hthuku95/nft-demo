// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721.sol";
import "../interfaces/VRFConsumerBase.sol";

contract AdvancedCollectible is ERC721, VRFConsumerBase {

    uint256 public tokenCounter;
    bytes32 public keyHash;
    uint256 public fee;
    enum Breed {
        PUG,
        SHIBA_INU,
        ST_BERNAD
    }
    mapping(uint256 => Breed) public tokenIdToBreed;
    mapping(bytes32 => address) public requestIdToSender;

    event requestedCollectible(bytes32 indexed requestId, address requester);
    event breedAssigned(uint256 indexed tokenId, Breed breed);
    // Best practise - It is best practise to emmit an event whenever a mapping is instantiated

    constructor (address _vrfCoodinator, address _linkToken, bytes32 _keyHash, uint256 _fee)
    VRFConsumerBase(_vrfCoodinator,_linkToken)
    ERC721("Doggie", "DOG") {
        tokenCounter = 0;
        keyHash = _keyHash;
        fee = _fee;
    }

    function createCollectible() public returns(bytes32) {
        bytes32 requestId = requestRandomness(keyHash,fee);
        requestIdToSender[requestId] = msg.sender;
        emit requestedCollectible(requestId,msg.sender);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        Breed breed = Breed(randomNumber % 3);
        uint256 newTokenId = tokenCounter;
        tokenIdToBreed[newTokenId] = breed;
        emit breedAssigned(newTokenId,breed);
        address nft_owner = requestIdToSender[requestId];
        _safeMint(nft_owner,newTokenId);
        //_setTokenURI(newTokenId, tokenURI);
        tokenCounter = tokenCounter + 1;
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(_isApprovedOrOwner(_msgSender(),tokenId),"ERC721 caller is not owner nor approved");
        _setTokenURI(tokenId, _tokenURI);
    }
}