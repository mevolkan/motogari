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

contract CarSale {

// number of available cars
    uint internal carLength = 0;
    address internal cUsdTokenAddress ;
    address internal adminAddress;


// struct containing each car
    struct Car {
        address payable owner;
        string name;
        string image;
        string description;
        string location;
        uint price;
        uint mileage;
        uint sales;
    }


  // ensure function can only be called by admin
    modifier onlyOwner() {
        // function checks if the caller is admin
        // calling a function in a modifier reduces contract byte code size
        isAdmin();
         _;
    }
    

// initialize the cusdtoken address and the admin address
    constructor(){
        cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
        adminAddress = msg.sender;
    }

    mapping (uint => Car) internal cars;

  // function to check if caller is an admin
    function isAdmin() internal view{
         require(msg.sender == adminAddress, "Function can only be accessed by owner.");
    }
// create a car
    function writeCar(
        string memory _name,
        string memory _image,
        string memory _description, 
        string memory _location, 
        uint _price,
        uint _mileage,
        uint _sales
    ) public {
   
        cars[carLength] = Car(
            payable(msg.sender),
            _name,
            _image,
            _description,
            _location,
            _price,
            _mileage,
            _sales
        );
        carLength++;
    }


// get info about a car
    function readCar(uint _index) public view returns (
        address payable,
        string memory, 
        string memory, 
        string memory, 
        string memory, 
        uint, 
        uint,
        uint
    ) {
        Car storage _car = cars[_index];
        return (
            _car.owner,
            _car.name, 
            _car.image, 
            _car.description, 
            _car.location, 
            _car.price,
            _car.mileage,
            _car.sales

        );
    }
    
    // buy a car of choice
    function buyCar(uint _index) public payable  {
        Car storage _car = cars[_index];
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            _car.owner,
            _car.price
          ),
          "Transfer failed."
        );

        _car.sales ++;
        
    }
    

// allow admins to edit car data
    function editCar(uint _index,
    string memory _name,
        string memory _image,
        string memory _description, 
        string memory _location, 
        uint _price,
        uint _mileage
    ) public onlyOwner {
           Car storage _car = cars[_index];
           require(_car.owner != address(0), " This car does not exist");

           _car.name = _name;
           _car.image = _image;
           _car.description = _description;
           _car.location = _location;
           _car.price = _price * (10**18);
           _car.mileage = _mileage;

    }
    function getCarLength() public view returns (uint) {
        return (carLength);
    }
}