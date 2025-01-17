// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import {RedirectAll, ISuperToken, ISuperfluid, IConstantFlowAgreementV1} from "./RedirectAll.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title Tradeable Cashflow NFT
/// @notice Inherits the ERC721 NFT interface from Open Zeppelin and the RedirectAll logic to
/// redirect all incoming streams to the current NFT holder.
contract TradeableCashflow is ERC721, RedirectAll {

    event TradeableCashflowDeployed(address indexed contractAddress);

    constructor(
        address owner,
        string memory _name,
        string memory _symbol,
        ISuperfluid host,
        IConstantFlowAgreementV1 cfa,
        ISuperToken acceptedToken
    ) ERC721(_name, _symbol) RedirectAll(acceptedToken, host, cfa, owner) {
        _mint(owner, 1);
        emit TradeableCashflowDeployed(address(this));
    }

    // ---------------------------------------------------------------------------------------------
    // BEFORE TOKEN TRANSFER CALLBACK

    /// @dev Before transferring the NFT, set the token receiver to be the stream receiver as
    /// defined in `RedirectAll`.
    /// @param to New receiver.
    function _beforeTokenTransfer(
        address from, // from
        address to,
        uint256 tokenId, // tokenId
        uint256 //open zeppelin's batchSize param
    ) internal override {
        _changeReceiver(to);
    }
}