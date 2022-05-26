// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Migrations {
  address public owner = msg.sender;
  uint public last_completed_migration;
  

  modifier restricted() {
    require(
      msg.sender == owner,
      "This function is restricted to the contract's owner"
    );
    _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }
}
pragma solidity ^0.8.10;
contract SimpleStorage {
  uint val;

  function set(uint x) public {
    val = x;
  }

  function get() public view returns (uint) {
    return val;
  }
}
