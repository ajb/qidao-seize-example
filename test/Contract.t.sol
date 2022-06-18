// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/Contract.sol";
import "../src/interfaces/IVault.sol";
import "forge-std/Test.sol";
import "openzeppelin-contracts/interfaces/IERC20.sol";

contract ContractTest is Test {
  address MAI_WHALE_ADDRESS = 0x679016B3F8E98673f85c6F72567f22b58Aa15A54;
  address MAI_ADDRESS = 0xfB98B335551a418cD0737375a2ea0ded62Ea213b;
  address MOOBIFI_ADDRESS = 0xbF07093ccd6adFC3dEB259C557b61E94c1F66945;
  address MOOBIFI_VAULT_ADDRESS = 0x75D4aB6843593C111Eeb02Ff07055009c836A1EF;

  function setUp() public {}

  function testExample() public {
    uint vaultId = 48;

    IERC20 moobifi = IERC20(MOOBIFI_ADDRESS);

    Contract instance = new Contract();
    IVault vault = IVault(MOOBIFI_VAULT_ADDRESS);

    // transfer mai from whale
    vm.prank(MAI_WHALE_ADDRESS);
    IERC20(MAI_ADDRESS).transfer(address(instance), 3000000 * 1e18);

    console.log("start");
    console.log("====");
    console.log("vault collateral", vault.vaultCollateral(vaultId));
    console.log("vault debt", vault.vaultDebt(vaultId));
    console.log("");
    console.log("");

    address originalOwner = vault.owner();
    vm.prank(originalOwner);
    vault.transferOwnership(address(instance));

    instance.execute(vaultId, originalOwner);

    console.log("end");
    console.log("====");
    console.log("vault collateral", vault.vaultCollateral(vaultId));
    console.log("vault debt", vault.vaultDebt(vaultId));
    console.log("liquidated moobifi", moobifi.balanceOf(address(instance)));
  }
}
