//     ERC165는 ERC-721 스마트 컨트랙트를 생성할 때 반드시 구현해야하는 인터페이스(Interface)를 검사하고, 언제 사용하는지 감지합니다.

// 인터페이스 ERC165는 함수 supportsInterface(bytes4 interfaceID) → bool 만 가지고 있습니다. 이 함수의 파라미터로 ERC-721의 인터페이스 ID를 입력해야만, ERC-721 스마트 컨트랙트가 정상적으로 동작합니다.

// 다음은 인터페이스 ERC165입니다.

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    // 인터페이스 ERC165를 통해 사용가능한 인터페이스인지 확인할 수 있습니다.
    // EIP-721에 작성되어 있는 인터페이스 id는 0x80ac58cd입니다.
    // 인터페이스 id는 ERC-721에 작성된 기본적인 인터페이스를, 몇 번의 암호화 과정을 거쳐 축약합니다.
    // 인터페이스 id는 작성된 함수를 하나의 잎(leaf)으로 두고 생성한 머클 루트(root)로 볼 수 있습니다.
    // 다음은 ERC-721의 인터페이스 id가 생성되는 예시를 나타냅니다.

     /*
     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c
     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
     *
     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
     */
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    constructor () public {
        // ERC165를 통한 ERC721의 확인을 위한 지원 인터페이스 등록
        _registerInterface(_INTERFACE_ID_ERC721);


//         함수 onERC721Received 는 컨트랙트 IERC721Receiver 에 작성된 함수입니다. IERC721Receiver 는 자산의 컨트랙트에서 safeTransfer를 지원하려는 모든 컨트랙트에 대한 인터페이스입니다.
// NFT의 수신을 처리하는 이 컨트랙트는 safeTransfer 후, 수신자가 구현한 이 함수를 호출합니다. 이 함수는 반드시 함수 선택자를 반환해야 합니다. 만약 그렇지 않을 경우, 호출자의 트랜잭션은 되돌려집니다. 반환될 Selector 는 IERC721.onERC721Received.selector 로 얻을 수 있습니다.

// 다음은 OpenZeppelin에서 onERC721Received 예시입니다.

 /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }


//     인터페이스 IERC721Metadata 에 작성되어 있는 이 함수는, tokenId 를 입력받아 URI(Uniform Resource Identifier)를 리턴합니다.
// 일반적으로 NFT에 포함될 이름, 설명, 이미지 URI, Properties를 포함하는 JSON 파일의 형태를 저장한 URI를 입력합니다.

function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    // tokenURI 함수는 위와 같이 public으로 공개해 사용합니다. 실제 함수 내부에서는 전달받은 파라미터 tokenId가 이미 존재하는지 검사합니다. tokenId에 해당하는 NFT가 있다면, 리턴값을 준비합니다. 함수_baseURI`를 실행하여, baseURI가 설정되어 있는지 검사합니다. baseURI가 설정되어 있다면, baseURI와 tokenId를 합친 문자열을 리턴합니다. baseURI가 없다면 빈 문자열을 리턴합니다.
}
