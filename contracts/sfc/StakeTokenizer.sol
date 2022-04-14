pragma solidity ^0.5.0;

import "./SFC.sol";
import "../erc20/base/ERC20Burnable.sol";
import "../erc20/base/ERC20Mintable.sol";
import "../common/Initializable.sol";

contract Spacer {
    address private _owner;
}

contract StakeTokenizer is Spacer, Initializable {
    SFC internal sfc = SFC(0xeAb1000000000000000000000000000000000000);
    mapping(address => mapping(uint256 => uint256)) public outstandingSAXIS;
    address public sAXISTokenAddress;

    constructor (address _sAXISTokenAddress ) public {
        sAXISTokenAddress = _sAXISTokenAddress;
    }

    function mintSAXIS(uint256 toValidatorID) external {
        address delegator = msg.sender;
        uint256 lockedStake = sfc.getLockedStake(delegator, toValidatorID);
        require(lockedStake > 0, "delegation isn't locked up");
        require(lockedStake > outstandingSAXIS[delegator][toValidatorID], "sAXIS is already minted");

        uint256 diff = lockedStake - outstandingSAXIS[delegator][toValidatorID];
        outstandingSAXIS[delegator][toValidatorID] = lockedStake;

        // It's important that we mint after updating outstandingSAXIS (protection against Re-Entrancy)
        require(ERC20Mintable(sAXISTokenAddress).mint(delegator, diff), "failed to mint sAXIS");
    }

    function redeemSAXIS(uint256 validatorID, uint256 amount) external {
        require(outstandingSAXIS[msg.sender][validatorID] >= amount, "low outstanding sAXIS balance");
        require(IERC20(sAXISTokenAddress).allowance(msg.sender, address(this)) >= amount, "insufficient allowance");
        outstandingSAXIS[msg.sender][validatorID] -= amount;

        // It's important that we burn after updating outstandingSAXIS (protection against Re-Entrancy)
        ERC20Burnable(sAXISTokenAddress).burnFrom(msg.sender, amount);
    }

    function allowedToWithdrawStake(address sender, uint256 validatorID) public view returns(bool) {
        return outstandingSAXIS[sender][validatorID] == 0;
    }
}
