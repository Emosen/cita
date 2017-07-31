pragma solidity ^0.4.0;

// use inheritance instead of library
// library cannot use mapping
import "./AccountManager.sol";

contract PermissionManager is AccountManager {

    // permission only inline. can combination 
    // permission-account: (form low to high) None-Tx-Contract-Admin ??maybe CreateRole
    // permission-admin: All
    // so there is one logic: role - permission

    // delete the admin permission. only admin role can have the admin permission
    enum Permission { None, NewNode, ApproveNode, DeleteNode, Tx, Contract, CreateRole }
    // just for check the array length
    uint8 constant MAX_PERMISSION = 10;

    // must integer literal
    // Permission[MAX_PERMISSION] AccountPermission = [Permission.CreateRole];
    // Permission[MAX_PERMISSION] NodePermissin = [Permission.NewNode];
    // no nees. use role to check
    // Permission AccountPermission = Permission.CreateRole;
    // Permission NodePermissin = Permission.NewNode;

    mapping(bytes32 => Permission[]) public role_permissions;

    event SetRolePermission(bytes32 _role, Permission[] _permissions);
    event OwnPermission(bytes32 _role, Permission _permission);
    event ListPermission(bytes32 _role);
    

    // set the permission of the role.
    function setRolePermission(bytes32 _role, Permission[] _permissions) onlyAdmin returns (bool) {
        // check the role has the given permissions 
        for (uint8 i = 0; i < _permissions.length; i++) {
            if (!ownPermission(_role, _permissions[i])) {
                role_permissions[_role].push(_permissions[i]);
            }
        }
    }

    // check whether the role has permission 
    function ownPermission(bytes32 _role, Permission _permission) constant returns (bool) {
        for (uint8 i = 0; i < MAX_PERMISSION; i++) {
            if (uint8(_permission) == i)
                return true;
        }
        OwnPermission(_role, _permission);
        return false;
    }
 
    // list the permission of the role
    function listPermission(bytes32 _role) returns (Permission[10]) {
        Permission[10] memory _permissions; 
        for (uint8 i = 0; i < role_permissions[_role].length; i++) {
            _permissions[i] = role_permissions[_role][i];
        }
        return _permissions;
    }
}
