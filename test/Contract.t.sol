// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/Contract.sol";
import "forge-std/Test.sol";

contract ContractTest is Test {
    function setUp() public {}

    function testExample() public {
      Contract instance = new Contract();
      instance.execute();
    }
}
