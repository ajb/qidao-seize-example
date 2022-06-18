// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IVault.sol";
import "forge-std/console.sol";
import "openzeppelin-contracts/interfaces/IERC20.sol";

contract FakeOracle {
  int256 immutable fakeAnswer;

  constructor (int256 _fakeAnswer) {
    fakeAnswer = _fakeAnswer;
  }

  function latestRoundData() external view returns (uint80, int256 answer, uint256, uint256, uint80) {
    return (0, fakeAnswer, 0, 0, 0);
  }
}

contract Contract {
  address immutable owner;
  address MAI_ADDRESS = 0xfB98B335551a418cD0737375a2ea0ded62Ea213b;
  IVault vault = IVault(0x75D4aB6843593C111Eeb02Ff07055009c836A1EF);

  constructor() {
    owner = msg.sender;
    IERC20(MAI_ADDRESS).approve(address(vault), type(uint).max);
  }

  function execute(uint vaultId, address _vaultOwnerAfterExecution) external {
    require(msg.sender == owner, "not owner");

    uint newPrice = (vault.vaultDebt(vaultId) * 1e8 / vault.vaultCollateral(vaultId)) + 1;
    FakeOracle fakeOracle = new FakeOracle(int(newPrice));

    uint initialGainRatio = vault.gainRatio();
    address initialPriceSource = vault.ethPriceSource();
    address initialStabilityPool = vault.stabilityPool();
    uint initialClosingFee = vault.closingFee();
    uint initialDebtRatio = vault.debtRatio();

    vault.setGainRatio(1000);
    vault.changeEthPriceSource(address(fakeOracle));
    vault.setStabilityPool(address(0));
    vault.setClosingFee(0);
    vault.setDebtRatio(1);

    vault.liquidateVault(vaultId);
    vault.getPaid();

    // reset initial values:
    vault.setGainRatio(initialGainRatio);
    vault.changeEthPriceSource(initialPriceSource);
    vault.setStabilityPool(initialStabilityPool);
    vault.setClosingFee(initialClosingFee);
    vault.setDebtRatio(initialDebtRatio);
    vault.transferOwnership(_vaultOwnerAfterExecution);
  }
}
