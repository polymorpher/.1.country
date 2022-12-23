// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract NameResolver is Ownable, AccessControl {
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    bytes32 constant lookup = 0x3031323334353637383961626364656600000000000000000000000000000000;
    mapping(bytes32 => string) names;

    event NameChanged(address indexed node, string name);

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

        bytes32 addrHash = sha3HexAddress(addr);

        names[addrHash] = newName;

        emit NameChanged(addr, newName);
    }

    /**
     * Returns the name associated with address, for reverse records.
     */
    function name(address addr)
        external
        view
        virtual
        returns (string memory)
    {
        bytes32 addrHash = sha3HexAddress(addr);

        return names[addrHash];
    }

    /**
     * @dev An optimised function to compute the sha3 of the lower-case
     *      hexadecimal representation of an Ethereum address.
     * @param addr The address to hash
     * @return ret The SHA3 hash of the lower-case hexadecimal encoding of the
     *         input address.
     */
    function sha3HexAddress(address addr) public pure returns (bytes32 ret) {
        assembly {
            for {
                let i := 40
            } gt(i, 0) {

            } {
                i := sub(i, 1)
                mstore8(i, byte(and(addr, 0xf), lookup))
                addr := div(addr, 0x10)
                i := sub(i, 1)
                mstore8(i, byte(and(addr, 0xf), lookup))
                addr := div(addr, 0x10)
            }

            ret := keccak256(0, 40)
        }
    }
}