pragma solidity ^0.8.10;

contract SimpleStorage {
    uint256 val;

    function set(uint256 x) public {
        val = x;
    }

    function get() public view returns (uint256) {
        return val;
    }
}
