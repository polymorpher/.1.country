// SPDX-License-Identifier: MIT

pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract NameResolver is Ownable, AccessControl {
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    mapping(address => string) _names;

    event NameChanged(address indexed addr, string name);

    function setupManager(address manager) public onlyOwner {
        _setupRole(MANAGER_ROLE, manager);
    }

    /**
     * Sets the name associated with an address, for reverse records.
     * May only be called by the MANAGER_ROLE
     * Access validation should be done in Manager contract
     */
    function setName(address addr, string calldata newName) external virtual {
        require(hasRole(MANAGER_ROLE, msg.sender), "Caller is not a manager");

        _names[addr] = newName;

        emit NameChanged(addr, newName);
    }

    /**
     * Returns the name associated with address, for reverse records.
     */
    function nameOf(address addr)
        external
        view
        virtual
        returns (string memory)
    {
        return _names[addr];
    }
}