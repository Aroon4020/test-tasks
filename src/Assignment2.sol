// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VotingSystem is Ownable {
    bool public votingOpen;

    // Struct to represent a voter
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedCandidateId;
    }

    // Struct to represent a candidate
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    // Mapping to store voters
    mapping(address => Voter) public voters;

    // Array to store candidates
    Candidate[] public candidates;

    // Events
    event VoterRegistered(address indexed voter);
    event CandidateAdded(uint256 indexed candidateId, string name);
    event VoteCasted(address indexed voter, uint256 indexed candidateId);
    event VotingOpen();
    event VotingClosed();

    /**
     * @dev Constructor to set the owner and initialize the voting state.
     */
    constructor() Ownable(msg.sender) {
        votingOpen = true;
    }

    /**
     * @dev Modifier to check if voting is open.
     */
    modifier onlyVotingOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    /**
     * @dev Modifier to check if voting is closed.
     */
    modifier onlyVotingClose() {
        require(!votingOpen, "Voting is already open");
        _;
    }

    /**
     * @dev Function to register as a voter.
     */
    function registerVoter() external {
        require(!voters[msg.sender].isRegistered, "Already registered as a voter");
        voters[msg.sender].isRegistered = true;
        emit VoterRegistered(msg.sender);
    }

    /**
     * @dev Function to add a candidate.
     * @param _name The name of the candidate.
     */
    function addCandidate(string memory _name) external onlyOwner onlyVotingOpen {
        candidates.push(Candidate(_name, 0));
        emit CandidateAdded(candidates.length - 1, _name);
    }

    /**
     * @dev Function to cast a vote.
     * @param _candidateId The ID of the candidate being voted for.
     */
    function vote(uint256 _candidateId) external onlyVotingOpen {
        require(voters[msg.sender].isRegistered, "Voter is not registered");
        require(!voters[msg.sender].hasVoted, "Already voted");
        require(_candidateId < candidates.length, "Invalid candidate ID");

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].votedCandidateId = _candidateId;
        candidates[_candidateId].voteCount++;

        emit VoteCasted(msg.sender, _candidateId);
    }

    /**
     * @dev Function to close voting.
     */
    function closeVoting() external onlyOwner onlyVotingOpen {
        votingOpen = false;
        emit VotingClosed();
    }

    /**
     * @dev Function to reopen voting.
     */
    function openVoting() external onlyOwner onlyVotingClose {
        votingOpen = true;
        emit VotingOpen();
    }

    /**
     * @dev Function to get the total number of candidates.
     * @return The total number of candidates.
     */
    function getCandidateCount() external view returns (uint256) {
        return candidates.length;
    }

    /**
     * @dev Function to get candidate details by ID.
     * @param _candidateId The ID of the candidate.
     * @return The name and vote count of the candidate.
     */
    function getCandidate(uint256 _candidateId) external view returns (string memory, uint256) {
        require(_candidateId < candidates.length, "Invalid candidate ID");
        return (candidates[_candidateId].name, candidates[_candidateId].voteCount);
    }

    /**
     * @dev Function to check if a voter has voted.
     * @param _voter The address of the voter.
     * @return A boolean indicating whether the voter has voted.
     */
    function hasVoted(address _voter) external view returns (bool) {
        return voters[_voter].hasVoted;
    }
}
