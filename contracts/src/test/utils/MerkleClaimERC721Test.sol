// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// ============ Imports ============

import { DSTest } from "ds-test/test.sol"; // DSTest
import { MerkleClaimERC721 } from "../../MerkleClaimERC721.sol"; // MerkleClaimERC721
import { MerkleClaimERC721User } from "./MerkleClaimERC721User.sol"; // MerkleClaimERC721 user

/// @title MerkleClaimERC721Test
/// @notice Scaffolding for MerkleClaimERC721 tests
/// @author Anish Agnihotri <contact@anishagnihotri.com>
contract MerkleClaimERC721Test is DSTest {

  /// ============ Storage ============

  /// @dev MerkleClaimERC721 contract
  MerkleClaimERC721 internal TOKEN;
  /// @dev User: Alice (in merkle tree)
  MerkleClaimERC721User internal ALICE;
  /// @dev User: Bob (not in merkle tree)
  MerkleClaimERC721User internal BOB;

  /// ============ Setup test suite ============

  function setUp() public virtual {
    // Create airdrop token
    TOKEN = new MerkleClaimERC721(
      "My Token", 
      "MT", 
      // Merkle root containing ALICE but no BOB
      0xeea5ff7bbd6c0a9e718f290ab36ba394db43a1b9895fec2be4ef8cb85b861da3
    );

    // Setup airdrop users
    ALICE = new MerkleClaimERC721User(TOKEN, 0xe66904a5318f27880bf1d20D77Ffa8FBdaC5E5E7); // 0xe66904a5318f27880bf1d20D77Ffa8FBdaC5E5E7
    BOB = new MerkleClaimERC721User(TOKEN, 0x7A77B4a12830B2266783F69192c6cddEd93C959d); // 0x71c7E43E96C1e7bBc4D8eB50e165deeE267770D2
  }  
}
