// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./IERC165.sol";
import "./Safemath.sol";

contract ERC721 is IERC165, IERC721{
    using SafeMath for uint256;

    uint _totalSupply;
     
    // Mapping from owner address to their set of owned tokens
    mapping (address => uint256[]) private _ownerTokens;
    //qasim ->1,2,3,4
    //index   0,1,2,3
    //Noman -> 5,6
    //index    0,1
    //Ahmed -> 7,8,9
    //index    0,1,2
    //Aiman -> totalSupply+1 => 10
    //index                      0   
    
    mapping (uint256 => address) private  _tokenOwners;

    mapping (address => uint256[]) private  _ownersTokenIndex;

    mapping (uint256 => address) private  _tokenApprovals;

    mapping(address => mapping(address => bool)) private _operatorApprovals;
    //qasim -> mudassir = true
    //Noman -> Aiman = true

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    // token name
    string private _name;
    
    // token symbol
    string private _symbol;

    // Base URI
    string private _baseURI;

    function balanceOf(address owner) external override view returns (uint256){
        require(owner != address(0), "Owner address cant pe null address");
        return _ownerTokens[owner].length;
    }

    // getting owner from tokenId
    function ownerOf(uint tokenId) public override view returns (address){
        address owner = _tokenOwners[tokenId];
        require(owner != address(0) ,"Owner address cant pe null address");
        return owner;
    }

    function indexOf(uint tokenId, address owner) external view returns (uint256){
        require(owner != address(0) ,"Owner address cant pe null address");
        return _ownersTokenIndex[owner][tokenId];
    }

    function tokenOfOwnerByIndex(uint index, address owner) external view returns (uint256){
        require(owner != address(0) ,"Owner address cant pe null address");
        return _ownerTokens[owner][index];
    }

    // name of token
    function name() public view returns (string memory){
        return _name;
    }

    // symbol of token
    function symbol() public view returns (string memory){
        return _symbol;
    }

    // totalSupply of token
    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }
    
    // approve number of tokens
    function approve(address to,uint tokenId) public virtual override{
        address owner = ownerOf(tokenId);
        require(msg.sender ==  owner,"Only owner can itself approve tokens");
        require(to != address(0),"Address cant be null address");
        _approve(to,tokenId);
    }

    // Returns the account approved for `tokenId` token.
    function getApproved(uint256 tokenId) public view override returns (address operator){
        require(_tokenExists(tokenId),"TokenId of non exists token");
        return _tokenApprovals[tokenId];
    }

    // checking if token exists in mapping
    function _tokenExists(uint256 tokenId) public view returns(bool){
        require(tokenId > 0,"ERC721: Token does not exist");
        address owner = _tokenOwners[tokenId];
        if(owner != address(0))
            return true;
        else
            return false;
        
    }
    
    function _approve(address to, uint256 tokenId) public view {
        require(ownerOf(tokenId) == msg.sender,"Only token owner can approve its token");
        require(to != address(0),"Address cant be null address");
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId),to,tokenId);
    }

    function setApprovalForAll(address operator, bool _approved) virtual override external{
        address owner = msg.sender;
        require(msg.sender != operator, "Approve to caller");
        _operatorApprovals[owner][operator] = _approved;
        emit ApprovalForAll(owner,operator,_approved);
    }

    // Returns if the `operator` is allowed to manage all of the assets of `owner`.
    function isApprovedForAll(address owner, address operator) public view override returns (bool){
        require(owner != address(0),"Owner address cant be null address");
        require(operator != address(0),"Operator address cant be null address");
        return _operatorApprovals[owner][operator];
    }

    function transfer(address to, uint tokenId) public view {
        require(to != address(0),"Address cant be null address");

        // your code here 
    }

    function _transfer(address from, address to, uint tokenId) public view returns(bool) {
        address owner = _tokenOwners[tokenId];
        require(owner == msg.sender,"Only owner can transfer ownership of token");
        _tokenOwners[tokenId] = to;

        // your code 

    }

    function safeTransferFrom( address from, address to, uint256 tokenId) external{
       // your code  
    }

    function transferFrom(address from, address to, uint256 tokenId) external{
        // your code 
    }

    // Checking token accessibility rights, Either it is owner or approver
    function _isApprovedOrOwner(address spender, uint tokenId) public view returns(bool) {
        require(_tokenExists(tokenId),"Token not exists in network");
        address owner = ownerOf(tokenId);
        return(spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner,spender));
    }

    function _mint(address to, uint256 tokenId) public view returns(bool){
        require(to != address(0),"Address can't be null address");
        _totalSupply += _totalSupply;
        // your code 

    }

    function _burn(uint tokenId) internal virtual(){
        address owner = ownerOf(tokenId);
        require(owner == msg.sender,"Only owner can burn it's tokens");
        // your code 

        // clear approval

        // clear metadata if any 

        // subtract from total supply

        // internal function of delete token

    }

    function _transfer(address to, address from, uint tokenId) internal virtual(){
        require(tokenId > 0, "TokenId must be greater than zero");
        require()
    }


}
