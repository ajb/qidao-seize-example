// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IVault.sol";
import "forge-std/console.sol";

contract Contract {
  address immutable owner;

  constructor() {
    owner = msg.sender;
  }

  function execute() external {
    require(msg.sender == owner, "not owner");

    uint vaultId = 48;
    IVault vault = IVault(0x75D4aB6843593C111Eeb02Ff07055009c836A1EF);

    console.log(vault.checkLiquidation(vaultId));
  }
}
