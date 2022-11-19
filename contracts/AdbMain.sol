// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract AdbMain {
  address owner;
  string public name = "ADB Token";
  string public symbol = "ADB";

  mapping (address => bool) bannedContributors;
  mapping (address => uint) contributorsBalance;

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  constructor() {
    owner = tx.origin;
    contributorsBalance[tx.origin] = 100000;
  }

  function selfSupply(uint amount) public onlyOwner returns(bool success) {
    contributorsBalance[address(this)] += amount;
    return true;
  }

  function updateContributor(address contributor, bool status) public onlyOwner returns(bool success) {
    bannedContributors[contributor] = status;
    return true;
  }

  function rewardContributor(address contributor, uint amount) public returns(bool success) {
    if (bannedContributors[contributor] == true) return false;
    if (contributorsBalance[msg.sender] < 100) return false;
    contributorsBalance[contributor] += amount;
    return true;
  }

  function transfer(address receiver, uint amount) public returns(bool sufficient) {
    if (contributorsBalance[msg.sender] < amount) return false;
    contributorsBalance[msg.sender] -= amount;
    contributorsBalance[receiver] += amount;
    return true;
  }

  function balanceOf(address account) external view returns (uint256) {
        return contributorsBalance[account];
    }
}