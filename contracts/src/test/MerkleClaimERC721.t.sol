// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

/// ============ Imports ============

import { MerkleClaimERC721Test } from "./utils/MerkleClaimERC721Test.sol"; // Test scaffolding

/// @title Tests
/// @notice MerkleClaimERC721 tests
/// @author Anish Agnihotri <contact@anishagnihotri.com>

interface ICheatcode {
  function expectRevert(bytes calldata msg) external;
  function prank(address) external;
}

contract Tests is MerkleClaimERC721Test {
    // Setup correct proof for Alice
    bytes32[5] aliceProof = [
      bytes32(0x8c54fbab03d8610c32de66e6a3013f9fa7991ef93ea5052fd0f485c08f43306d),
      bytes32(0x590cc6e1061d63d2350d3870cf09245a4c3e5a39d1c1792c4b4e7c8a179e39c1),
      bytes32(0x35356e212207ef7aff01ac88adbd60872f7f264e96fb57d40ef2d2753f08c3e8),
      bytes32(0xb6a8db8dd76cffbcfdc7e858c90e5602d60c6f7aaf6eddcbfc0c0018dedbe130),
      bytes32(0x40afdec2467a6b95fc68c5e0b657de8effc7893fab9030aef587dc9c932bb173)
    ];

 bytes32[5] bobProof =   [
  bytes32(0x801027094aa2b83851b3720319eb0e1bc5624344d6d54f6435d54f75bdb3359e),
  bytes32(0x21c94d29415451a6132205d86f1271ae7c887f07022da23e29e07c8b63c9821f),
  bytes32(0x36aaa0c1e7c9839c9c8c86ad7a107f358a086d15f5093403bf66972b50211aa5),
  bytes32(0x352aeb9696b03fc50d3e28d0a2cf4ad1d9e0200b64538c004815da7bf09c00d4),
  bytes32(0x1156a65bf200f88be8a3199069c6bf9ff89dbed19c4d26dca4a662d4c71231a2)
];

  function getAliceProof() internal view returns (bytes32[] memory _aliceProof){
    _aliceProof = new bytes32[](5);
    for (uint8 i = 0; i < aliceProof.length; i++) {
      _aliceProof[i] = aliceProof[i];
    }
  }

  function getBobProof() internal view returns (bytes32[] memory _bobProof){
    _bobProof = new bytes32[](5);
    for (uint8 i = 0; i < bobProof.length; i++) {
      _bobProof[i] = bobProof[i];
    }
  }
    

  /// @notice Allow Alice to claim 1 tokens
  function testAliceClaim() public {
    // Collect Alice balance of tokens before claim
    uint256 alicePreBalance = ALICE.tokenBalance();

    // Claim tokens
    ALICE.claim(
      // Claiming for Alice
      ALICE.ADDRESS(),
      // token 1
      0,
      // With valid proof
      getAliceProof()
    );

    // Collect Alice balance of tokens after claim
    uint256 alicePostBalance = ALICE.tokenBalance();
    ALICE.tokenurl(1);

    // Assert Alice balance before + 1 token = after balance
    assertEq(alicePostBalance, alicePreBalance + 1);
  }

  /// @notice Prevent Alice from claiming twice
  function testFailAliceClaimTwice() public {
    // Claim tokens
    ALICE.claim(
      // Claiming for Alice
      ALICE.ADDRESS(),
      // token 1
      1,
      // With valid proof
      getAliceProof()
    );

    // Claim tokens again
    ALICE.claim(
      // Claiming for Alice
      ALICE.ADDRESS(),
     // token 1
      1,
       // With valid proof
      getAliceProof()
    );
  }

  /// @notice Prevent Alice from claiming with invalid proof
  function testFailAliceClaimInvalidProof() public {
    // Setup incorrect proof for Alice
    bytes32[] memory _aliceProof = new bytes32[](1);
    _aliceProof[0] = 0xc11ae64152a2deaf8c661fccd5645458ba20261b16d2f6e090fe908b0ac9ca88;

    // Claim tokens
    ALICE.claim(
      // Claiming for Alice
      address(ALICE),
      // token 1
      1,
      // With valid proof
      _aliceProof
    );
  }

  /// @notice Prevent Bob from claiming
  function testBobClaim() public {
    // Setup correct proof for Alice
    bytes32[] memory _aliceProof = new bytes32[](1);
    _aliceProof[0] = 0xceeae64152a2deaf8c661fccd5645458ba20261b16d2f6e090fe908b0ac9ca88;

    // Claim tokens
    BOB.claim(
      // Claiming for Bob
      BOB.ADDRESS(),
     // token 1
      10,
       // With valid proof (for Alice)
      getBobProof()
    );

     BOB.tokenurl(10);
  }

 

  /// @notice Let Bob claim on behalf of Alice
  function testBobClaimForAlice() public {
    // Collect Alice balance of tokens before claim
    uint256 alicePreBalance = ALICE.tokenBalance();

    // Claim tokens
    BOB.claim(
      // Claiming for Alice
      ALICE.ADDRESS(),
     // token 1
      1,
       // With valid proof (for Alice)
      getAliceProof()
    );

    // Collect Alice balance of tokens after claim
    uint256 alicePostBalance = ALICE.tokenBalance();

    // Assert Alice balance before + 100 tokens = after balance
    assertEq(alicePostBalance, alicePreBalance + 1);
  }

  function testOwnerChangeRoot() public {
    address owner = 0x00a329c0648769A73afAc7F9381E08FB43dBEA72; // Foundry default address on the EVM
    ICheatcode c = ICheatcode(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D); // Foundry Address to access the depoyed cheatcode
    
    assertEq(msg.sender,owner);
    TOKEN.updateMerkleRoot(0xa21be505af5f5455fad4bcb3d54ccc03f269c5e06945f1dbf6c96dfcb99fcbd0);

    c.prank(address(2));
    bytes memory message = "Ownable: caller is not the owner";
    c.expectRevert(message);
    TOKEN.updateMerkleRoot(0xa21be505af5f5455fad4bcb3d54ccc03f269c5e06945f1dbf6c96dfcb99fcbd0);
  }
}
