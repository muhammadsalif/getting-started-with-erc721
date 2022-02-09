// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "./ERC721.sol";

// first address. 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
// second address 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2

contract BCCTOWN is ERC721 {
    // counter tokenId
    uint256 private tokenId = 1;

    constructor() ERC721("BAHRIA Town Karachi", "BTK") {}

    function awardPlot(address allottee, string memory tokenUri)
        public
        payable
        returns (uint256)
    {
        require(
            allottee != address(0),
            "Allottee address can't be null address"
        );
        require(bytes(tokenUri).length != 0, "Token uri is not provided");
        tokenId += tokenId;
        uint256 newTokenId = tokenId;

        _mint(allottee, tokenId);
        _setTokenUri(newTokenId, tokenUri);
        return newTokenId;
    }
}
