pragma solidity ^0.4.0;

import "./PermissionManager.sol";

contract Configration is PermissionManager {

    uint public blockQuotaLimit = 61415926;
    uint public defaultAccountQuotaLimit = 25141592;

    mapping(address => uint) accountQuotaLimit;

    event SetBQL(uint _quota);
    event SetDefaultAQL(uint _quota);
    event SetAQL(address _account, uint _quota);
    event GetBQL();
    event GetDefaultAQL();
    event GetAQL(address _account);

    // set block quota limit 
    function setBQL(uint _quota) onlyAdmin returns (bool) {
        blockQuotaLimit = _quota;
        assert(blockQuotaLimit == _quota);
        SetBQL(_quota);
        return true;
    }

    // set default account quota limit
    function setDefaultAQL(uint _quota) onlyAdmin returns (bool) {
        defaultAccountQuotaLimit = _quota;
        assert(defaultAccountQuotaLimit == _quota);
        SetDefaultAQL(_quota);
        return true;
    }

    // set account quota limit
    function setAQL(address _account, uint _quota) onlyAdmin returns (bool) {
        accountQuotaLimit[_account] = _quota;
        assert(accountQuotaLimit[_account] == _quota);
        SetAQL(_account, _quota);
        return true;
    }

    // get block quota limit
    function getBQL() returns (uint) {
        GetBQL();
        return blockQuotaLimit; 
    }

    // get default account quota limit
    function getDefaultAQL() returns (uint) {
        GetDefaultAQL();
        return defaultAccountQuotaLimit; 
    }

    // get account quota limit
    function getAQL(address _account) returns (uint) {
        GetAQL(_account);
        return accountQuotaLimit[_account]; 
    }
}
