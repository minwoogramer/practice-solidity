// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract GameItem is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() public ERC721("GameItem", "ITM") {}

    function awardItem(address player, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    // tokenId 가 반드시 존재해야 하며, tokenId 에 해당하는 NFT 소유자를 리턴합니다.

    // 리턴값이 있는 함수의 경우, 다음과 같이 표기했습니다.

    // 함수이름(변수자료형 변수이름) → (리턴값) 변수자료형 변수이름
    function ownerOf(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        address owner = _owners[tokenId];
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );
        return owner;
    }

    // 함수 ownerOf는 public으로 공개해 사용합니다. tokenId 를 입력받고, 해당 토큰을 소유하고 있는 주소를 리턴합니다. 토큰의 소유자가 없다면(오너의 주소값이 0이라면), 에러를 발생합니다.

    function setApprovalForAll(address operator, bool approved)
        public
        virtual
        override
    {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    //     오퍼레이터(operator)의 모든 자산을 관리할 수 있는 권한을 부여하거나 없앨 수 있습니다.
    // 이 함수를 실행하면, ApprovalForAll(owner, operator, approved) 이벤트가 발생합니다.

    // 오퍼레이터는 이 함수를 호출할 수 없습니다.

    //  setApprovalForAll 함수는 위와 같이 public으로 공개해 사용합니다. 실제 함수 내부에서는 전달받은 파라미터 operator 와 approved 를 함수 _setApprovalForAll 로 전달하고 있습니다. 함수 _setApprovalForAll 은 함수 내부에서만 사용가능한 internal 함수입니다. 함수 _setApprovalForAll 은 다음과 같이 작성되어 있습니다.
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        // ApprovalForAll(owner, operator, approved) 이벤트를 발생시킵니다.
        emit ApprovalForAll(owner, operator, approved);
    }

    // require 구문을 통해, owner와 operator가 서로 다른지 검사합니다. 오너가 자기 자신을 제외한 다른 주소에게 권한을 주는 함수이므로, require를 통해 검증 후 다음 코드로 넘어갑니다. _operatorApprovals 객체는 오너와 오퍼레이터를 매칭하고, 오퍼레이터에게 권한을 준상태이면 true, 그렇지 않으면 false로 상태를 담고 있습니다. 파라미터로 전달된 approved에 따라 결정됩니다. 마지막으로 emit ApprovalForAll(owner, operator, approved) 으로 이벤트를 발생시킵니다.

    // tokenId 가 반드시 존재해야 하며, tokenId 에 대해 승인된 어카운트(account)를 리턴합니다.
    function getApproved(uint256 tokenId)
        public
        view
        virtual
        override
        returns (address)
    {
        require(
            _exists(tokenId),
            "ERC721: approved query for nonexistent token"
        );

        return _tokenApprovals[tokenId];
    }

    // tokenId 를 파라미터로 입력받고, tokenId 와 매핑된 주소(address) 값을 리턴합니다.

    //  오퍼레이터가 오너의 모든 자산을 관리할 수 있는 권한의 여부를 리턴합니다.
    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    // 함수 isApprovedForAll 은 owner의 주소와 operator의 주소를 입력받고, owner가 operator에게 준 권한의 유무를 boolean으로 리턴합니다.
}
