pragma solidity ^0.5.0;

contract SocialNetwork {
    string public name;
    uint public postCount = 0;
    mapping(uint => Post) public posts;

    struct Post {
        uint id;
        string content;
        uint tipAmount;
        address payable author;
    }

    event PostCreated(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    event PostTipped(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    constructor() public {
        name = "Dapp University Social Network";
    }

    function createPost(string memory _content) public {
        require(bytes(_content).length > 0);
        postCount ++;
        posts[postCount] = Post(postCount, _content,0, msg.sender);
        emit PostCreated(postCount, _content,0, msg.sender);
    }

    function tipPost(uint _id) public payable {
        // Make sure that id is valid
        require(_id > 0 && _id <= postCount);
        //Fetch the Post
        Post memory _post = posts[_id];
        //Fetch the author
        address payable _author = _post.author;
        //Pay the author by sending ether
        address(_author).transfer(msg.value);
        //Increment the tip amount
        _post.tipAmount = _post.tipAmount + msg.value;
        //Update the post
        posts[_id] = _post;
        emit PostTipped(postCount, _post.content, _post.tipAmount, _author);
    }
}