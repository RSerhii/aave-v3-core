// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.8.6;

import {AccessControl} from '../../dependencies/openzeppelin/contracts/AccessControl.sol';
import {IAccessControl} from '../../dependencies/openzeppelin/contracts/IAccessControl.sol';
import {VersionedInitializable} from '../libraries/aave-upgradeability/VersionedInitializable.sol';
import {IPoolAddressesProvider} from '../../interfaces/IPoolAddressesProvider.sol';
import {IACLManager} from '../../interfaces/IACLManager.sol';

/**
 * @title ACLManager
 * @author Aave
 * @notice Access Control List Manager. Main registry of system roles and permissions.
 */
contract ACLManager is VersionedInitializable, AccessControl, IACLManager {
  bytes32 public constant override POOL_ADMIN_ROLE = keccak256('POOL_ADMIN');
  bytes32 public constant override EMERGENCY_ADMIN_ROLE = keccak256('EMERGENCY_ADMIN');
  bytes32 public constant override RISK_ADMIN_ROLE = keccak256('RISK_ADMIN');
  bytes32 public constant override FLASH_BORROWER_ROLE = keccak256('FLASH_BORROWER');
  bytes32 public constant override BRIDGE_ROLE = keccak256('BRIDGE');

  uint256 public constant REVISION = 0x1;

  IPoolAddressesProvider public _addressesProvider;

  /**
   * @notice Initializes the ACL manager
   * @param provider The address of the PoolAddressesProvider
   * @dev The ACL admin should be initialized at the addressesProvider beforehand
   */
  function initialize(IPoolAddressesProvider provider) public initializer {
    _addressesProvider = provider;
    address aclAdmin = provider.getACLAdmin();
    require(aclAdmin != address(0), 'ACL admin cannot be the zero address');
    _setupRole(DEFAULT_ADMIN_ROLE, aclAdmin);
  }

  /// @inheritdoc VersionedInitializable
  function getRevision() internal pure virtual override returns (uint256) {
    return REVISION;
  }

  /// @inheritdoc IACLManager
  function setRoleAdmin(bytes32 role, bytes32 adminRole)
    external
    override
    onlyRole(DEFAULT_ADMIN_ROLE)
  {
    _setRoleAdmin(role, adminRole);
  }

  function addPoolAdmin(address admin) external override {
    grantRole(POOL_ADMIN_ROLE, admin);
  }

  function removePoolAdmin(address admin) external override {
    revokeRole(POOL_ADMIN_ROLE, admin);
  }

  function isPoolAdmin(address admin) external view override returns (bool) {
    return hasRole(POOL_ADMIN_ROLE, admin);
  }

  function addEmergencyAdmin(address admin) external override {
    grantRole(EMERGENCY_ADMIN_ROLE, admin);
  }

  function removeEmergencyAdmin(address admin) external override {
    revokeRole(EMERGENCY_ADMIN_ROLE, admin);
  }

  function isEmergencyAdmin(address admin) external view override returns (bool) {
    return hasRole(EMERGENCY_ADMIN_ROLE, admin);
  }

  function addRiskAdmin(address admin) external override {
    grantRole(RISK_ADMIN_ROLE, admin);
  }

  function removeRiskAdmin(address admin) external override {
    revokeRole(RISK_ADMIN_ROLE, admin);
  }

  function isRiskAdmin(address admin) external view override returns (bool) {
    return hasRole(RISK_ADMIN_ROLE, admin);
  }

  function addFlashBorrower(address borrower) external override {
    grantRole(FLASH_BORROWER_ROLE, borrower);
  }

  function removeFlashBorrower(address borrower) external override {
    revokeRole(FLASH_BORROWER_ROLE, borrower);
  }

  function isFlashBorrower(address borrower) external view override returns (bool) {
    return hasRole(FLASH_BORROWER_ROLE, borrower);
  }

  function addBridge(address bridge) external override {
    grantRole(BRIDGE_ROLE, bridge);
  }

  function removeBridge(address bridge) external override {
    revokeRole(BRIDGE_ROLE, bridge);
  }

  function isBridge(address bridge) external view override returns (bool) {
    return hasRole(BRIDGE_ROLE, bridge);
  }
}
