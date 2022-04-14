/**
 *Submitted for verification at FtmScan.com on 2021-03-10
*/

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
	address private _owner;

	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

	/**
		* @dev Initializes the contract setting the deployer as the initial owner.
		*/
	constructor () internal {
		address msgSender = msg.sender;
		_owner = msgSender;
		emit OwnershipTransferred(address(0), msgSender);
	}

	/**
		* @dev Returns the address of the current owner.
		*/
	function owner() public view returns (address) {
		return _owner;
	}

	/**
		* @dev Throws if called by any account other than the owner.
		*/
	modifier onlyOwner() {
		require(isOwner(), "Ownable: caller is not the owner");
		_;
	}

	/**
		* @dev Returns true if the caller is the current owner.
		*/
	function isOwner() public view returns (bool) {
		return msg.sender == _owner;
	}

	/**
		* @dev Leaves the contract without owner. It will not be possible to call
		* `onlyOwner` functions anymore. Can only be called by the current owner.
		*
		* NOTE: Renouncing ownership will leave the contract without an owner,
		* thereby removing any functionality that is only available to the owner.
		*/
	function renounceOwnership() public onlyOwner {
		emit OwnershipTransferred(_owner, address(0));
		_owner = address(0);
	}

	/**
		* @dev Transfers ownership of the contract to a new account (`newOwner`).
		* Can only be called by the current owner.
		*/
	function transferOwnership(address newOwner) public onlyOwner {
		_transferOwnership(newOwner);
	}

	/**
		* @dev Transfers ownership of the contract to a new account (`newOwner`).
		*/
	function _transferOwnership(address newOwner) internal {
		require(newOwner != address(0), "Ownable: new owner is the zero address");
		emit OwnershipTransferred(_owner, newOwner);
		_owner = newOwner;
	}
}

contract StakersInterface {
	function getValidatorID(address addr) external view returns (uint256);
}

contract StakerInfo is Ownable {
	mapping (uint => string) public stakerInfos;

	address internal stakerContractAddress = 0xeAb1000000000000000000000000000000000000;
	constructor(bool mainnet) public {
		string memory _configUrl = "https://ipfs.io/ipfs/QmWSNiG7dAboTYrSZ8qBfY1ENid45oypCQXJFyep7k4Ne3";
		if (mainnet) {
			_updateInfo(0x14fCa2361553F821b65812fD40ab7bDEF37de3c2, _configUrl);
			_updateInfo(0xE285AC259F5F66E3580Db4dd2909A2E57fD1bF78, _configUrl);
			_updateInfo(0xf31D5071964C7097e6a3aC6063e9CE437755c1Be, _configUrl);
			_updateInfo(0x57C79538af87DD5583c188A9424b9Fed0ae6b620, _configUrl);
			_updateInfo(0x0cc298DBA96D854d5626B22894D5c32634745f67, _configUrl);
			_updateInfo(0xe91Ee1838772964dEFdB46E5346168119882aa46, _configUrl);
			_updateInfo(0x8B1E640DD01Cd5Fda611214a48545bCbb3C5A306, _configUrl);
			_updateInfo(0x323B6412c4329B3ba46165c4ca60d6d4f00965D1, _configUrl);
		} else {
			_updateInfo(0xC4A4393C956d76aCBB3F60c79dB83BD376708378, _configUrl);
			_updateInfo(0xe8C8C6A989e4C8655fA3F11FB82FfA841B683CA4, _configUrl);
			_updateInfo(0xE6D04Ec807b7683d2DfF94DeF41C19d7C6eb9FaA, _configUrl);
			_updateInfo(0x528b66B85ccE01Fa10A765567910A3824897Fd71, _configUrl);
			_updateInfo(0xC0C111bC3108b04732EA5061bA0C126E3561DD3d, _configUrl);
			_updateInfo(0x23279ad9F6B48d17D75CAD2dE3fEEeCd77966467, _configUrl);
			_updateInfo(0x9c269BAAF93B5b6eb57198874c8Be42A3d445318, _configUrl);
			_updateInfo(0x0BD337Cb966151F425FE7801F540dc6735bF927F, _configUrl);
		}
	}
	
	event InfoUpdated(uint256 stakerID);

	function updateInfo(string calldata _configUrl) external {
		require(msg.sender!=address(0));
		_updateInfo(msg.sender, _configUrl);
	}

	function _updateInfo(address _sender, string memory _configUrl) internal {
		StakersInterface stakersInterface = StakersInterface(stakerContractAddress);

		// Get staker ID from staker contract
		uint256 stakerID = stakersInterface.getValidatorID(_sender);

		// Check if address belongs to a staker
		require(stakerID != 0, "Address does not belong to a staker!");

		// Update config url
		stakerInfos[stakerID] = _configUrl;

		emit InfoUpdated(stakerID);
	}

	function getInfo(uint256 _stakerID) external view returns (string memory) {
		return stakerInfos[_stakerID];
	}
}