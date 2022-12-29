// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract UniDirectionalPayment {
    address payable public sender;
    address payable public receiver;

    // The balance of the sender
    uint256 public balance;

    // Event to indicate the receipt of funds
    event FundsReceived(uint256 balance);

    constructor(address payable _sender, address payable _receiver)
        public
        payable
    {
        sender = _sender;
        receiver = _receiver;
    }

    // Send funds to the receiver
    function send(uint256 amount) public payable {
        // Ensure that the caller is the sender
        require(msg.sender == sender, "Sender must be the caller");

        // Ensure that the contract has enough balance to send the funds
        require(
            address(this).balance >= amount,
            "Contract does not have enough balance"
        );

        // Update the balance of the sender by adding the amount of the transfer
        balance += amount;

        // Send the funds to the receiver using the call function
        (bool success, bytes memory data) = receiver.call{value: amount}("");
        // If the call fails, revert the transaction
        require(success, "Call to receiver failed");
    }

    // Confirm the receipt of funds
    function confirmReceived() public {
        // Ensure that the caller is the receiver
        require(msg.sender == receiver, "Sender must be the receiver");

        // Ensure that the contract has a positive balance
        require(balance > 0, "Contract does not have a positive balance");

        // Emit an event to indicate the receipt of funds
        emit FundsReceived(balance);

        // Reset the balance of the contract
        balance = 0;
    }
}
