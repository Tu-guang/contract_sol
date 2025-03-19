// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenBalanceChecker {
    function balances(address user, address[] memory _tokenAddresses) public view returns (uint256[] memory) {
        uint256 length = _tokenAddresses.length;
        require(length > 0, "Token addresses list cannot be empty");

        uint256[] memory balancesArray = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            if (_tokenAddresses[i] == address(0)) {
                balancesArray[i] = 0; // 遇到无效地址，返回 0 避免 revert
            } else {
                balancesArray[i] = IERC20(_tokenAddresses[i]).balanceOf(user);
            }
        }

        return balancesArray;
    }
}
