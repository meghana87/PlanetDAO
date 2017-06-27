pragma solidity ^0.4.0;

import "./helper_contracts/strings.sol";
import "./helper_contracts/StringLib.sol";

import "./DataStore.sol";


library MembersLibrary {

    // Status of transaction. Used for error handling.
    event Status(uint indexed statusCode);

    // Member has following states: 0 (Active), 1 (Inactive)

    function memberCount(address memberStoreAddress) constant returns (uint count) {
        return DataStore(memberStoreAddress).count();
    }

    function addMember(address memberStoreAddress, address account, uint index) public {
        var memberStore = DataStore(memberStoreAddress);
        if (index == 0) {
            Status(100);
        }
        // if (accountIndex == emailIndex && accountIndex != 0) {
        //     // if member is already registered with given info
        //     memberStore.setIntValue(accountIndex, 'state', 0);
        //     Status(102);
        //     return;
        // }
        // if (accountIndex != 0 && emailIndex != 0 && emailIndex != accountIndex) {
        //     // provided account and email already registered but with different users
        //     Status(103);
        //     return;
        // }
        // if (accountIndex == 0 && emailIndex != 0) {
        //     // email is already registered
        //     Status(104);
        //     return;
        // }
        // if (accountIndex != 0 && emailIndex == 0) {
        //     // account is already registered
        //     Status(105);
        //     return;
        // }
        memberStore.increaseCount();
        uint memberIndex = memberStore.count();
        memberStore.setIntValue(sha3('dateAdded', index), now);
        memberStore.setIntValue(sha3('state', index), 0);
        // mapping subset memberIndex to superset index
        memberStore.setIntIndex(sha3('memberIndex'), memberIndex, index);
        memberStore.setAddressValue(sha3('account', index), account);
        // memberStore.setAddressIndex('account', account, index);
    }

    function removeMember(address memberStoreAddress, address account) {
        var memberStore = DataStore(memberStoreAddress);
        // Deactivate member
        var accountIndex = memberStore.getAddressIndex(sha3('account'), account);
        if (accountIndex != 0) {
            memberStore.setIntValue(sha3('state', accountIndex), 1);
            memberStore.decreaseCount();
        }
    }

    function getMember(address memberStoreAddress, uint index) constant returns (address account, uint state, uint dateAdded) {
        var memberStore = DataStore(memberStoreAddress);
        if (index < 1) {
            return;
        }
        account = memberStore.getAddressValue(sha3('account', index));
        if (account == 0x0) {
            return;
        }
        state = memberStore.getIntValue(sha3('state', index));
        dateAdded = memberStore.getIntValue(sha3('dateAdded', index));
    }
}