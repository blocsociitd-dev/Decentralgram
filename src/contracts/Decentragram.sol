pragma solidity ^0.5.16;

contract Decentragram {
  string public name = "Decentragram";

  // Events
  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Store images
  uint public imageCount = 0;
  struct Image {
    uint256 id;
    string hash;
    string description;
    uint256 tipAmount;
    address payable author;
  }
  mapping(uint => Image) public images;  // uint is id of image

  // Create images
  function uploadImage(string memory _imgHash, string memory _description) public {
    // validations
    require(bytes(_description).length > 0);
    require(bytes(_imgHash).length > 0);
    require(msg.sender != address(0x0));

    // Increment image id
    imageCount++;

    // Add image to contract
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);

    // Trigger imageCreated event
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  // Tip images
  function tipImageOwner(uint _id) public payable {
    require(_id >0 && _id <= imageCount);

    // Fetch image from ipfs
    Image memory _image = images[_id];

    // Fetch author of image
    address payable _author = _image.author;
    
    // Transfer money to author of iamge
    address(_author).transfer(msg.value);

    // Update tipAmount of image
    _image.tipAmount += msg.value;

    // Update the image
    images[_id] = _image;

    // emit event
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
  }
}