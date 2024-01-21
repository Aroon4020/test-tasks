// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenSale is Ownable {
    ERC20 public token; 
    using SafeERC20 for ERC20;

    // Phases
    enum SalePhase {
        Presale,
        PublicSale
    }
    SalePhase public currentPhase;

    // Caps and limits
    uint256 public presaleCap;
    uint256 public publicSaleCap;
    uint256 public minContribution;
    uint256 public maxContribution;
    uint256 public presaleMinimumReached;
    uint256 public publicSaleMinimumReached;

    // Contributors and balances
    mapping(address => uint256) public presaleBalances;
    mapping(address => uint256) public publicSaleBalances;

    // Events
    event TokensPurchased(
        address indexed buyer,
        uint256 amount,
        SalePhase phase
    );
    event TokensDistributed(address indexed recipient, uint256 amount);
    event RefundClaimed(address indexed contributor, uint256 amount);
    event PresaleMinimumReached(uint256 amount);
    event PublicSaleMinimumReached(uint256 amount);

    /**
     * @dev Constructor to initialize the token sale parameters.
     * @param _token The ERC-20 token contract address.
     * @param _presaleCap The maximum cap for the presale.
     * @param _publicSaleCap The maximum cap for the public sale.
     * @param _minContribution The minimum contribution allowed.
     * @param _maxContribution The maximum contribution allowed.
     */
    constructor(
        ERC20 _token,
        uint256 _presaleCap,
        uint256 _publicSaleCap,
        uint256 _minContribution,
        uint256 _maxContribution
    ) Ownable(msg.sender) {
        token = _token;
        presaleCap = _presaleCap;
        publicSaleCap = _publicSaleCap;
        minContribution = _minContribution;
        maxContribution = _maxContribution;
        currentPhase = SalePhase.Presale;
        presaleMinimumReached = 0;
        publicSaleMinimumReached = 0;
    }

    /**
     * @dev Modifier to check if the current phase is the presale.
     */
    modifier onlyPresale() {
        require(currentPhase == SalePhase.Presale, "Not in presale phase");
        _;
    }

    /**
     * @dev Fallback function to receive Ether.
     */
    receive() external payable {
        revert("Fallback function disabled. Use contribute function.");
    }

    /**
     * @dev Function to contribute Ether and receive tokens.
     */
    function contribute() external payable {
        uint256 amount = msg.value;
        require(
            amount >= minContribution && amount <= maxContribution,
            "Contribution out of range"
        );

        if (currentPhase == SalePhase.Presale) {
            require(
                address(this).balance + amount <= presaleCap,
                "Presale cap exceeded"
            );
            presaleBalances[msg.sender] += amount;
            if (address(this).balance >= presaleCap) {
                emit PresaleMinimumReached(address(this).balance);
            }
        } else {
            require(
                address(this).balance + amount <= publicSaleCap,
                "Public sale cap exceeded"
            );
            publicSaleBalances[msg.sender] += amount;
            if (address(this).balance >= publicSaleCap) {
                emit PublicSaleMinimumReached(address(this).balance);
            }
        }

        token.safeTransfer(msg.sender, amount);
        emit TokensPurchased(msg.sender, amount, currentPhase);
    }

    /**
     * @dev Function to distribute project tokens to a specified address.
     * @param recipient The address to receive the tokens.
     * @param amount The amount of tokens to be distributed.
     */
    function distributeTokens(
        address recipient,
        uint256 amount
    ) external onlyOwner {
        token.safeTransfer(recipient, amount);
        emit TokensDistributed(recipient, amount);
    }

    /**
     * @dev Function to switch to the public sale phase.
     * Can only be called by the owner.
     */
    function startPublicSale() external onlyOwner onlyPresale {
        currentPhase = SalePhase.PublicSale;
    }

    /**
     * @dev Function to claim a refund if the minimum cap is not reached.
     */
    function claimRefund() external {
        require(
            address(this).balance < publicSaleCap ||
                address(this).balance < presaleCap,
            "Refund not available, cap reached"
        );

        uint256 refundPublicSaleAmount = publicSaleBalances[msg.sender];
        uint256 refundPresaleAmount = presaleBalances[msg.sender];
        require(
            refundPublicSaleAmount > 0 || refundPresaleAmount > 0,
            "No refund available"
        );
        publicSaleBalances[msg.sender] = 0;
        presaleBalances[msg.sender] = 0;
        if (refundPresaleAmount > refundPublicSaleAmount) {
            payable(msg.sender).transfer(refundPresaleAmount);
            emit RefundClaimed(msg.sender, refundPresaleAmount);
        } else {
            payable(msg.sender).transfer(refundPublicSaleAmount);
            emit RefundClaimed(msg.sender, refundPublicSaleAmount);
        }
    }
}
