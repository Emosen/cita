pragma solidity ^0.4.0;

// import "./PermissionManager.sol";

// contract AccountManager is PermissionManager {
contract AccountManager {

    // role-inline: account, node, admin
    // role-define: bytes32(defined by the account who has the define-role permission)
    bytes32 admin = 'admin';
    //bytes32 account = 'account';
    // store the roles
    bytes32[] roles;

    mapping (address => bool) admins;

    // default: account
    mapping(address => bytes32[]) account_roles;

    event CreateRole(bytes32 _role, uint8[] _permission);
    event OwnRole(address _account, bytes32 _role);
    event ListRole(address _account);
    event GrandRole(address _account, bytes32 _role);
    event GrandAdmin(address _account);
    event RevokeRole(address _account, bytes32 _role);

    // only the admin 
    modifier onlyAdmin() {
        // undo
        require(account_roles[msg.sender][0] == "admin"); 
        _;
    }

    // only the account 
    modifier onlyAccount() {
        require(account_roles[msg.sender][0] != "node"); 
        _;
    }

    // about the account-define-role
    // should set the permission or not
    function create_role(bytes32 _role, uint8[] _permission) returns (bool) {
        require(!isInRoles(roles, _role));
        roles.push(_role); 
        // !!undo: set the role permission. call the PermissionManager
        CreateRole(_role, _permission);
    }

    // check if account own the role
    function ownRole(address _account, bytes32 _role) returns (bool) {
        return isInRoles(account_roles[_account], _role);
    }

    // undo: grand multiple role 
    function grandRole(address _account, bytes32 _role) returns (bool) {
        // giver should alreay have the role 
        require(isInRoles(account_roles[msg.sender], _role));
        // receiver should not have the role
        require(!isInRoles(account_roles[_account], _role));
        account_roles[_account].push(_role);
        GrandRole(_account, _role);
        return true;
    }

    // add the admin
    function grandAdmin(address _account) onlyAdmin returns (bool) {
        admins[_account] = true;
        return true;
    }

    // revoke the role 
    function revokeRole(address _account, bytes32 _role) returns (bool) {
        // !!undo: how to check the identity of the giver
        delete account_roles[_account][indexRoles(account_roles[_account], _role)];
        RevokeRole(_account, _role);
        return true;
    }

    // interface about array. should make it a library
    function isInRoles(bytes32[] _roles,  bytes32 _role) internal returns (bool) {
        for(uint8 i = 0; i < _roles.length; i++) {
            if (_role == _roles[i]) 
                return true;
        }
        return false;
    }

    // get the index of the roles
    function indexRoles(bytes32[] _roles, bytes32 _role) internal returns (uint) {
        for(uint8 i = 0; i < _roles.length; i++) {
            if (_role == _roles[i]) 
                return i;
        }
        // not fount
        return _roles.length;
    }
}
