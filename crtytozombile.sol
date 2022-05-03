pragma solidity ^0.8.13;

contract ZombieFactory {
    // 여기에 이벤트 선언
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint256 _dna) private {
        // 여기서 이벤트 실행
        zombies.push(Zombie(_name, _dna));
        uint256 id = zombies.length - 1; //배열의 첫 원소가 0이라는 인덱스를 갖기 때문에 array.push() -1로 해줘야 막 추가된 좀비의 인덱스가됌
        emit NewZombie(id, _name, _dna); //이벤트실행
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(bytes(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
