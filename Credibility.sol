/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


/// @title Contract for credibility control of media
/// @author UNSW COMP6452 GROUP 17

contract CredibilityContract {

    /*
     * Checks if the hash taken by the user (via the browser?) of the offchain stored media
     * matches the hash stored on the blockchain.
     */
    function checkMediaUnchanged(address addr, uint mediaNum, string memory offchainHash) external view returns (bool) {
        string memory onchainHash = MediaContract(addr).obtainMediaHash(mediaNum);
        return keccak256(abi.encodePacked(onchainHash)) == keccak256(abi.encodePacked(offchainHash));
    }

    /*
     * Computes and returns a publisher credibility score (perhaps upvotes / total votes * 100)
     */ 
    function publisherCredibility(address contractAddr, address publisherAddr) external view returns (uint) {
        (uint upvotes, uint downvotes) = PublisherContract(contractAddr).countVotes(publisherAddr);
        return upvotes != 0 || downvotes != 0 ? upvotes / (upvotes + downvotes) * 100 : 0;
    }

    /*
     * Computes and returns a media credibility score (perhaps upvotes / total votes * 100)
     */ 
    function mediaCredibility(address addr, uint mediaNum) external view returns (uint) {
        (uint upvotes, uint downvotes) = MediaContract(addr).countVotes(mediaNum);
        return upvotes != 0 || downvotes != 0 ? upvotes / (upvotes + downvotes) * 100 : 0;
    }
}


interface MediaContract {
    function obtainMediaHash(uint mediaNum) external view returns (string memory);
    function countVotes(uint mediaNum) external view returns (uint, uint);
    function upvote(uint mediaNum) external returns (uint);
    function downvote(uint mediaNum) external returns (uint);
}

interface PublisherContract {
    function countVotes(address addr) external view returns (uint, uint);
    function upvote(address addr) external returns (uint);
    function downvote(address addr) external returns (uint);
}