pragma solidity >=0.8.0;

import "forge-std/Script.sol";
import "../src/MerkleClaimERC721.sol";

contract MyScript is Script{
    function run() external {
        vm.startBroadcast();

        WEB3BRIDGECERTIFICATE MC721 = new WEB3BRIDGECERTIFICATE("WEB3BRIDGE", "W3B", 0xeea5ff7bbd6c0a9e718f290ab36ba394db43a1b9895fec2be4ef8cb85b861da3);

        vm.stopBroadcast();
    }

}