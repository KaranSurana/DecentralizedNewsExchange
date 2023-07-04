/// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;


/// @title Contract for media access
/// @author UNSW COMP6452 GROUP 17

contract MediaContract {

    struct Media {
        string title;           
        string description;         
        address publisher;
        uint upvotes;
        uint downvotes;
        string link;            
        string contentHash;
        bool exists;        
    }

    uint public numMedia = 0;
    mapping (uint => Media) public mediaList;

    /*
     * Returns a list of all media titles in the blockchain
     */
    function listMedia() external view returns (string[] memory) {
        string[] memory mediaToDisplay = new string[](numMedia);

        for (uint i=0; i < numMedia; i++) {
            mediaToDisplay[i] = mediaList[i].title;
        }
        return mediaToDisplay;
    }


    /*
     * Returns a link to the media.
     */
    function obtainMedia(uint mediaNum) external view returns (string memory) {
        if (mediaList[mediaNum].exists) {
            return mediaList[mediaNum].link;
        }
        return "";
    }


    /*
     * Records a new media instance onto the BC and returns the media
     * uint identifier.
     */
    function publishMedia(
        string memory title,
        string memory description,
        address publisherCAddr,
        address publisherAddr,
        string memory link,
        string memory contentHash
    ) external returns (uint) {
        Media memory m;
        m.title = title;
        m.description = description;
        m.publisher = publisherAddr;
        m.link = link;
        m.contentHash = contentHash;
        mediaList[numMedia] = m;
        PublisherContract(publisherCAddr).addMediaToPublisher(publisherCAddr, numMedia);
        numMedia++;
        return numMedia - 1;
    }


    /*
     * Implementation of a media upvote, returns 0 if media does not exist
     */
    function upvote(uint mediaNum, address publisherCAddr) external returns (uint) {
        if (mediaList[mediaNum].exists) {
            mediaList[mediaNum].upvotes++;
            PublisherContract(publisherCAddr).upvote(mediaList[mediaNum].publisher);
            return mediaList[mediaNum].upvotes;
        }
        return 0;
    }


    /*
     * Implementation of a media downvote, returns 0 if media does not exist
     */
    function downvote(uint mediaNum, address publisherCAddr) external returns (uint) {
        if (mediaList[mediaNum].exists) {
            mediaList[mediaNum].upvotes++;
            PublisherContract(publisherCAddr).downvote(mediaList[mediaNum].publisher);
            return mediaList[mediaNum].downvotes;
        }
        return 0;
    }


    /*
     * Returns a summary of the media. This summary is supplied by the publisher
     * when they first publish the article.
     */
    function obtainMediaSummary(uint mediaNum) external view returns (string memory) {
        return mediaList[mediaNum].exists ? mediaList[mediaNum].description : "";
    }

    /*
     * Returns a hash of a media's original content
     */
    function obtainMediaHash(uint mediaNum) external view returns (string memory) {
        return mediaList[mediaNum].exists ? mediaList[mediaNum].contentHash : "";
    }


    /*
     * Returns upvotes and downvotes count
     */
    function countVotes(uint mediaNum) external view returns (uint, uint) {
        return mediaList[mediaNum].exists ? (mediaList[mediaNum].upvotes, mediaList[mediaNum].downvotes) : (0, 0);
    }


    /*
     * Checks if the media id entered is within the range of media available
     */
    // modifier mediaExists(uint mediaNum) {
    //     require(mediaNum < numMedia, "The chosen media does not exist.");
    //     _;
    // }

}

interface PublisherContract {
    function upvote(address addr) external returns (uint);
    function downvote(address addr) external returns (uint);
    function addMediaToPublisher(address addr, uint mediaNum) external;
}