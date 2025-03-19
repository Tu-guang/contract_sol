// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract BatchBalanceChecker {
    /**
     * @dev 批量查询 ERC20 代币余额
     * @param tokenAddresses 代币合约地址数组
     * @param userAddresses 用户地址数组
     * @return balances 返回每个用户对应每个代币的余额
     */
    function getTokenBalances(
        address[] calldata tokenAddresses,
        address[] calldata userAddresses
    ) external view returns (uint256[][] memory balances) {
        require(tokenAddresses.length > 0, "No token addresses provided");
        require(userAddresses.length > 0, "No user addresses provided");
        require(tokenAddresses.length <= 2000, "Too many token addresses");
        require(userAddresses.length <= 2000, "Too many user addresses");

        balances = new uint256[][](userAddresses.length);

        for (uint256 i = 0; i < userAddresses.length; i++) {
            balances[i] = new uint256[](tokenAddresses.length);
            for (uint256 j = 0; j < tokenAddresses.length; j++) {
                try IERC20(tokenAddresses[j]).balanceOf(userAddresses[i]) returns (uint256 balance) {
                    balances[i][j] = balance;
                } catch {
                    balances[i][j] = 0; // 如果调用失败，返回 0
                }
            }
        }

        return balances;
    }
}
