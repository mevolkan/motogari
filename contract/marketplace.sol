// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Marketplace {

    uint internal carsLength = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Car {
        address payable owner;
        string name;
        string image;
        string description;
        string location;
        uint price;
        uint mileage;
    }

    mapping (uint => Car) internal cars;

    function addCar(
        string memory _name,
        string memory _image,
        string memory _description, 
        string memory _location, 
        uint _price,
        uint _mileage
    ) public {
   
        cars[carsLength] = Car(
            payable(msg.sender),
            _name,
            _image,
            _description,
            _location,
            _price,
            _mileage
        );
        carsLength++;
    }

    function getCar(uint _index) public view returns (
        address payable,
        string memory, 
        string memory, 
        string memory, 
        string memory, 
        uint, 
        uint
    ) {
        return (
            cars[_index].owner,
            cars[_index].name, 
            cars[_index].image, 
            cars[_index].description, 
            cars[_index].location, 
            cars[_index].price,
            cars[_index].mileage
        );
    }
    
    function buyCar(uint _index) public payable  {
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            cars[_index].owner,
            cars[_index].price
          ),
          "Transfer failed."
        );
        
    }
    
    function getCarLength() public view returns (uint) {
        return (carsLength);
    }
}