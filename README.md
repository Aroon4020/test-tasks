# Assiginment 1 - TokenSale Smart Contract
The TokenSale smart contract is designed to facilitate the sale of an ERC-20 token in two phases: Presale and Public Sale. It allows contributors to send Ether to the contract and receive tokens in return. The contract is suitable for token sales with specified caps, contribution limits, and minimum requirements to proceed to the next phase.

## Features
Presale and Public Sale Phases: The contract has two phases, presale and public sale, allowing for a structured token sale process.

Cap and Limit Controls: Contributors are limited to a minimum and maximum contribution. Caps are set for both the presale and public sale phases.

Ether Contribution: Users can contribute Ether to the contract during the sale, and the corresponding amount of tokens is transferred to their address.

Minimum Cap Tracking: The contract emits events when the minimum contribution cap is reached for both the presale and public sale phases.

Token Distribution: The owner can distribute project tokens to a specified address using the distributeTokens function.

Refund Mechanism: Contributors can claim a refund if the minimum cap is not reached in both the presale and public sale phases.

## Contribution
Contributors can participate in the sale by calling the contribute function and sending Ether within the specified contribution limits. The contract automatically tracks the contributions for both phases.

## Distribution
The owner can distribute project tokens to a specified address using the distributeTokens function.

## Phase Switching
The owner can switch from the presale phase to the public sale phase using the startPublicSale function.

## Refund
Contributors can claim a refund if the minimum cap is not reached by calling the claimRefund function.

## Events
TokensPurchased: Emitted when a contributor purchases tokens.
TokensDistributed: Emitted when tokens are distributed by the owner.
RefundClaimed: Emitted when a contributor claims a refund.
PresaleMinimumReached: Emitted when the presale minimum contribution cap is reached.
PublicSaleMinimumReached: Emitted when the public sale minimum contribution cap is reached.

# Assinment 2 - VotingSystem Smart Contract
The VotingSystem smart contract is designed to facilitate transparent and decentralized voting processes. It allows users to register as voters, add candidates, cast votes, and view the results of an election. The contract provides functionality to open and close voting periods, ensuring a secure and controlled voting environment.

## Features
Voter Registration: Users can register as voters, ensuring that only registered users can participate in the voting process.

Candidate Addition: The owner of the contract can add candidates to the election, each with a unique name.

Vote Casting: Registered voters can cast their votes for a specific candidate, ensuring that each voter can only vote once.

Transparent Voting Process: The contract provides events to log important actions, making the voting process transparent and auditable.

Voting Period Management: The owner can open and close the voting period to control when votes can be cast.

## Voter Registration
Users can register as voters by calling the registerVoter function. Only users who have not already registered can proceed with the registration.

## Candidate Addition
The contract owner can add candidates to the election by calling the addCandidate function. Candidates are represented by a name, and their vote count is initially set to zero.

## Vote Casting
Registered voters can cast their votes by calling the vote function with the ID of the candidate they are voting for. Each voter can only vote once, and the contract updates the candidate's vote count accordingly.

## Voting Period Management
The owner has the authority to open and close the voting period using the openVoting and closeVoting functions, respectively.

## Results and Information
Various functions are available to retrieve information about the election results and candidates. Users can query the total number of candidates, get details about a specific candidate, and check if a particular voter has cast their vote.

## Events
VoterRegistered: Emitted when a user successfully registers as a voter.
CandidateAdded: Emitted when a new candidate is added to the election.
VoteCasted: Emitted when a voter casts their vote.
VotingOpen: Emitted when the voting period is opened.
VotingClosed: Emitted when the voting period is close.


# Assignment 3 - TokenSwap Smart Contract
The TokenSwap smart contract facilitates the exchange and liquidity provision of two ERC-20 tokens, referred to as Token A and Token B, at a fixed exchange rate. This contract allows users to swap between Token A and Token B and provides liquidity providers with the ability to add and remove liquidity from the token pool.

## Features
Token Swapping: Users can swap Token A for Token B and vice versa at a fixed exchange rate.

Liquidity Provision: Liquidity providers can add liquidity to the pool by depositing both Token A and Token B.

Liquidity Removal: Liquidity providers can withdraw their deposited tokens from the pool.

Reentrancy Protection: The contract utilizes the ReentrancyGuard to prevent reentrancy attacks during swapping and liquidity operations.

## Token Swapping
Users can initiate token swaps by calling the swap function, specifying the input and output tokens along with the desired amounts. The swap follows a fixed exchange rate set during contract deployment.

## Liquidity Provision
Liquidity providers, typically the contract owner, can add liquidity to the pool by calling the addLiquidity function, providing amounts for both Token A and Token B.

## Liquidity Removal
Liquidity providers can remove liquidity from the pool by calling the removeLiquidity function, specifying the amounts of Token A and Token B to be withdrawn.

## Events
Swap: Emitted when a user successfully swaps tokens.
LiquidityAdded: Emitted when liquidity is added to the pool.
LiquidityRemoved: Emitted when liquidity is removed from the pool.


# Assignment 4 - MultisigWallet Smart Contract
The MultisigWallet smart contract is a simple implementation of a multi-signature wallet on the Ethereum blockchain. It allows multiple owners to collectively control the funds in the wallet, with a specified number of owners required to approve and execute a transaction.

## Features
Multi-Signature Control: The wallet requires a predefined number of owners to collectively approve a transaction before it can be executed.

Transaction Submission: Owners can submit new transactions to the wallet, specifying the recipient address, amount of Ether, and data to be sent.

Transaction Approval and Rejection: Owners can individually approve or revoke their approval for a submitted transaction.

Transaction Execution: Once the required number of approvals is reached, any owner can execute the transaction, transferring Ether and executing the specified data.


## Transaction Submission
Owners can submit new transactions using the submit function, providing the recipient address, Ether amount, and data.

## Transaction Approval
Owners can individually approve a pending transaction using the approve function.

## Transaction Rejection
Owners can revoke their approval for a pending transaction using the revoke function.

## Transaction Execution
Once the required number of approvals is reached, any owner can execute the transaction using the execute function.

## Receiving Ether
The contract can receive Ether through the receive function, allowing external wallets to deposit funds.

## Events
Deposit: Emitted when the contract receives Ether.
Submit: Emitted when a new transaction is submitted.
Approve: Emitted when an owner approves a transaction.
Revoke: Emitted when an owner revokes their approval for a transaction.
Execute: Emitted when a transaction is successfully executed.
## Modifiers
onlyOwner: Ensures that only owners can execute certain functions.
txExists: Ensures that a transaction with a given ID exists.
notApproved: Ensures that an owner has not already approved a transaction.
notExecuted: Ensures that a transaction has not already been executed.
