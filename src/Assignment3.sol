// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSwap is ReentrancyGuard, Ownable {
    using SafeERC20 for ERC20;

    ERC20 public tokenA;
    ERC20 public tokenB;
    uint256 public exchangeRate;

    // Events
    event Swap(address indexed user, ERC20 tokenIn, ERC20 tokenOut, uint256 amountIn, uint256 amountOut);
    event LiquidityAdded(address indexed provider, ERC20 tokenA, ERC20 tokenB, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, ERC20 tokenA, ERC20 tokenB, uint256 amountA, uint256 amountB);

    /**
     * @dev Constructor to set the ERC-20 tokens and exchange rate.
     * @param _tokenA The address of the first ERC-20 token.
     * @param _tokenB The address of the second ERC-20 token.
     * @param _exchangeRate The fixed exchange rate between Token A and Token B.
     */
    constructor(
        ERC20 _tokenA,
        ERC20 _tokenB,
        uint256 _exchangeRate
    ) Ownable(msg.sender) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        exchangeRate = _exchangeRate;
    }

    /**
     * @dev Function to swap tokens.
     * @param tokenIn The input ERC-20 token.
     * @param tokenOut The output ERC-20 token.
     * @param amountIn The amount of tokens to be swapped in.
     * @param amountOutMin The minimum amount of tokens to be received in the swap.
     */
    function swap(ERC20 tokenIn, ERC20 tokenOut, uint256 amountIn, uint256 amountOutMin) external nonReentrant {
        require(amountIn > 0, "Amount must be greater than zero");
        require(tokenIn == tokenA || tokenIn == tokenB, "Invalid tokenIn");
        require(tokenOut == tokenA || tokenOut == tokenB, "Invalid tokenOut");
        require(tokenIn != tokenOut, "Cannot swap the same token");

        // Calculate the equivalent amount of the token out
        uint256 amountOut = (amountIn * exchangeRate) / 1e18;
        require(amountOut >= amountOutMin, "Amount less than expected amount out");

        // Transfer tokens
        tokenIn.safeTransferFrom(msg.sender, address(this), amountIn);
        tokenOut.safeTransfer(msg.sender, amountOut);

        emit Swap(msg.sender, tokenIn, tokenOut, amountIn, amountOut);
    }

    /**
     * @dev Function to add liquidity to the pool.
     * @param amountA The amount of Token A to be provided.
     * @param amountB The amount of Token B to be provided.
     */
    function addLiquidity(uint256 amountA, uint256 amountB) external onlyOwner nonReentrant {
        require(amountA > 0 && amountB > 0, "Amount must be greater than zero");

        // Transfer tokens from the liquidity provider
        tokenA.safeTransferFrom(msg.sender, address(this), amountA);
        tokenB.safeTransferFrom(msg.sender, address(this), amountB);
    }

    /**
     * @dev Function to remove liquidity from the pool.
     * @param amountA The amount of Token A to be withdrawn.
     * @param amountB The amount of Token B to be withdrawn.
     */
    function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner nonReentrant {

        // Transfer tokens to the liquidity provider
        tokenA.safeTransfer(msg.sender, amountA);
        tokenB.safeTransfer(msg.sender, amountB);
    }

}    