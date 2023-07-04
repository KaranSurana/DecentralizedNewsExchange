/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


/// @title Contract for Publisher functionality
/// @author UNSW COMP6452 GROUP 17

contract PublisherContract {

    struct Publisher {
        uint upvotes;
        uint downvotes;
        uint[] media;
        bool exists;
    }

    uint numPublishers = 0;
    mapping (address => Publisher) public publishers;


    /*
     * Adds media to existing publisher or creates a new publisher if they don't 
     * yet exist.
     */
    function addMediaToPublisher(address addr, uint mediaNum) external {
        if (publishers[addr].exists) {
            publishers[addr].media.push(mediaNum);
        } else {
            Publisher memory p;
            p.exists = true;
            publishers[addr] = p;
            numPublishers++;
        }
    }


    /*
     * Implementation of a media upvote
     */
    function upvote(address addr) external returns (uint) {
        if (publishers[addr].exists) {
            publishers[addr].upvotes++;
            return publishers[addr].upvotes;
        }
        return 0;
    }


    /*
     * Implementation of a media downvote
     */
    function downvote(address addr) external returns (uint) {
        if (publishers[addr].exists) {
            publishers[addr].downvotes++;
            return publishers[addr].downvotes;
        }
        return 0;
    }


    /*
     * Returns number of publisher's upvotes and downvotes
     */
    function countVotes(address addr) external view returns (uint, uint) {
        if (publishers[addr].exists) {
            return (publishers[addr].upvotes, publishers[addr].downvotes);
        }
        return (0, 0);
    }
}
