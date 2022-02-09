// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./ERC165.sol";
import "./Safemath.sol";

contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;

    uint256 _totalSupply;

    // Mapping from owner address to their set of owned tokens
    mapping(address => uint256[]) private _ownerTokens;
    //qasim ->1,2,3,4
    //index   0,1,2,3
    //Noman -> 5,6
    //index    0,1
    //Ahmed -> 7,8,9
    //index    0,1,2
    //Aiman -> totalSupply+1 => 10
    //index                      0

    mapping(uint256 => address) private _tokenOwners;

    mapping(address => uint256[]) private _ownersTokenIndex;

    mapping(uint256 => address) private _tokenApprovals;

    mapping(address => mapping(address => bool)) private _operatorApprovals;
    //qasim -> mudassir = true
    //Noman -> Aiman = true

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenUri;

    // token name
    string private _name;

    // token symbol
    string private _symbol;

    // Base URI
    string private _baseURI;

    /*
     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
     *
     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
     */
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    /*
     *     bytes4(keccak256('name()')) == 0x06fdde03
     *     bytes4(keccak256('symbol()')) == 0x95d89b41
     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
     *
     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
     */
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    /*
     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
     *
     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
     */
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    constructor(string memory contractName, string memory contractSymbol) {
        _name = contractName;
        _symbol = contractSymbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    function balanceOf(address owner) external view override returns (uint256) {
        require(owner != address(0), "Owner address cant pe null address");
        return _ownerTokens[owner].length;
    }

    // getting owner from tokenId
    function ownerOf(uint256 tokenId) public view override returns (address) {
        require(tokenId > 0, "Token id must be greater than zero");
        require(_tokenExists(tokenId), "Token not exists in contract");
        address owner = _tokenOwners[tokenId];
        require(owner != address(0), "Owner address cant pe null address");
        return owner;
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external override {
        //  hello
    }

    // approved operator call this function to transfer owner token to somene's address
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external override {
        // msg.sender is approve operator
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "This address is not allowed to transfer given tokenId"
        );
        // call helper _transfer function with parameters (to, from, tokenId)
        _transfer(from, to, tokenId);
    }

    // approve number of tokens
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner, "Only owner can itself approve tokens");
        require(to != address(0), "Address cant be null address");
        _approve(to, tokenId);
    }

    // Returns the account approved for `tokenId` token. from tokenApprovals mapping
    function getApproved(uint256 tokenId)
        public
        view
        override
        returns (address operator)
    {
        require(_tokenExists(tokenId), "TokenId of non exists token");
        return _tokenApprovals[tokenId];
    }

    // Just setting true false for operatorAppoval mapping
    function setApprovalForAll(address operator, bool _approved)
        external
        virtual
        override
    {
        address owner = msg.sender;
        require(msg.sender != operator, "Approve to caller");
        _operatorApprovals[owner][operator] = _approved;
        emit ApprovalForAll(owner, operator, _approved);
    }

    // Returns if the `operator` is allowed to manage all of the assets of `owner`.
    function isApprovedForAll(address owner, address operator)
        public
        view
        override
        returns (bool)
    {
        require(owner != address(0), "Owner address cant be null address");
        require(
            operator != address(0),
            "Operator address cant be null address"
        );
        return _operatorApprovals[owner][operator];
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external override {
        // hello
    }

    // name of token
    function name() public view returns (string memory) {
        return _name;
    }

    // symbol of token
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    // totalSupply of token
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function transfer(address to, uint256 tokenId) public virtual {
        require(to != address(0), "Address cant be null address");
        // Check msg.sender is owner or approve operator with helper function _isApprovedOrOwner
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Only owner or approved person can transfer tokens"
        );

        // call helper method of _transfer with parameter of (to, from, tokenId)
        _transfer(to, msg.sender, tokenId);
    }

    // getting index of ownersTokenIndex mapping with tokenId and owner address
    function _indexOf(uint256 tokenId, address owner)
        external
        view
        returns (uint256)
    {
        require(owner != address(0), "Owner address cant pe null address");
        return _ownersTokenIndex[owner][tokenId];
    }

    // getting index of ownersToken mapping with index and owner address
    function _tokenOfOwnerByIndex(uint256 index, address owner)
        external
        view
        returns (uint256)
    {
        require(owner != address(0), "Owner address cant pe null address");
        return _ownerTokens[owner][index];
    }

    // checking if token exists in contract or not from tokenOwners mapping
    function _tokenExists(uint256 tokenId) public view returns (bool) {
        require(tokenId > 0, "Token id must be greater than 0");
        address owner = _tokenOwners[tokenId];
        if (owner != address(0)) return true;
        else return false;
    }

    // Checking token accessibility rights, Either it is owner or approver
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        public
        view
        returns (bool)
    {
        require(_tokenExists(tokenId), "Token not exists in contract");
        address owner = ownerOf(tokenId);
        // This will return true or false
        return (spender == owner ||
            getApproved(tokenId) == spender ||
            isApprovedForAll(owner, spender));
    }

    function _mint(address to, uint256 tokenId) public {
        require(to != address(0), "Address can't be null address");
        // adding one in totalSupply
        _totalSupply = _totalSupply.add(1);
        // call _addToken() helper function which will update the state
        _addToken(to, tokenId);
        // When we
        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ownerOf(tokenId);
        require(owner == msg.sender, "Only owner can burn it's tokens");

        // clear approval with helper method
        _approve(address(0), tokenId);

        // clear metadata if any
        if (bytes(_tokenUri[tokenId]).length != 0) {
            // delete keyword don't completely delete from blockchain,
            // it will just set default value to that specific value of mapping
            delete _tokenUri[tokenId];
        }

        // subtract from total supply
        _totalSupply = _totalSupply.sub(1);

        // state update on token delete internal function of _deleteToken
        _deleteToken(owner, tokenId);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) public virtual {
        // checking transfering from is exactly the person holding this token
        require(
            ownerOf(tokenId) == from,
            "Transfering of token from address that is not owning it"
        );
        // checking msg.sender is owner or a approved operator
        require(
            _isApprovedOrOwner(msg.sender, tokenId),
            "Only owner or approved operator can transfer ownership of token"
        );
        // tokenId must be greater than 0
        require(tokenId > 0, "Invalid token id");
        // address can't be null address
        require(to != address(0), "Address can't be null address");

        // clear approval from the previous owner
        _approve(address(0), tokenId);

        // setting address against tokenId in tokenOwners mapping
        _tokenOwners[tokenId] = to;

        // call internal function _deleteToken
        _deleteToken(from, tokenId);

        // call internal function _addToken
        _addToken(to, tokenId);

        // event firing transfer
        emit Transfer(from, to, tokenId);
    }

    // adding new token to contract
    // This fuction is responsible for adding tokens in all of the 3 mappings
    // ownerTokens, tokenOwners, ownerTokenIndex
    function _addToken(address owner, uint256 tokenId)
        internal
        virtual
        returns (bool success, uint256 newIndex)
    {
        // provided tokenId already exists or not in the contract
        require(
            !_tokenExists(tokenId),
            "provided token id is already exists in the contract"
        );

        _tokenOwners[tokenId] = owner;

        _ownerTokens[owner].push(tokenId);

        // getting new index to store value at that place
        newIndex = _ownersTokenIndex[owner].length - 1;
        // now placing to the last index
        _ownersTokenIndex[owner][tokenId] = newIndex;

        success = true;
    }

    // Removing token with a special technique
    function _deleteToken(address owner, uint256 tokenId)
        internal
        virtual
        returns (bool success, uint256 currentIndex)
    {
        require(tokenId > 0, "Invalid token id provided");
        require(
            _tokenExists(tokenId),
            "Token already not exists in the contract"
        );
        require(owner != address(0), "Owner address can't be null address");
        require(
            ownerOf(tokenId) == msg.sender,
            "Only owner can call delete token function"
        );

        currentIndex = _ownersTokenIndex[owner][tokenId];
        // swapping tokenId with last index of array
        if (_ownerTokens[owner].length > 1) {
            uint256 lastIndex = _ownerTokens[owner].length - 1;
            uint256 lastToken = _ownerTokens[owner][lastIndex];
            _ownerTokens[owner][currentIndex] = lastToken;
            _ownersTokenIndex[owner][lastToken] = currentIndex;
        }
        // remove last entry
        _ownerTokens[owner].pop();

        // remove index
        delete _ownersTokenIndex[owner][tokenId];

        // remove owner
        delete _tokenOwners[tokenId];

        success = true;
    }

    // this token will set token uri to contract mapping
    function _setTokenUri(uint256 tokenId, string memory tokenURI)
        internal
        virtual
    {
        require(tokenId > 0, "Token id must be greater than zero");
        // setting tokenUri to contract global mapping
        _tokenUri[tokenId] = tokenURI;
    }

    // function to set approval operator
    function _approve(address to, uint256 tokenId) public {
        // set new approve operator to mapping
        require(
            ownerOf(tokenId) == msg.sender,
            "Only token owner can approve its token"
        );

        // setting approval address to tokenApproval mapping
        _tokenApprovals[tokenId] = to;

        // // THIS BLOCK OF CODE IS NOT WORKING
        // // setting true false in operatorApproval mapping with helper function
        // setApprovalForAll(to, true);

        // emit appoval event
        emit Approval(ownerOf(tokenId), to, tokenId);
    }
}
