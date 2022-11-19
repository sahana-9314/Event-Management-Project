//SPDX-License-Identifier: Unlicense; 

pragma solidity >=0.5.0 <0.9.0;

contract EventContract
{
    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint tickrtRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
        require(date>block.timestamp,"You can organize event for future only");
        require(ticketCount>0,"Create more than 0 tickets to organize an event");
        events[nextId]= Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }

    function buyTicket(uint id,uint quantity) external payable{
        require(events[id].date!=0,"This event does not exist");
        require(events[id].date>block.timestamp,"Event is already over");
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.tickrtRemain>=quantity,"Not enough tickets");
        _event.tickrtRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTicket(uint id,uint quantity,address to) external {
        require(events[id].date!=0,"This event does not exist");
        require(events[id].date>block.timestamp,"Event is already over");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}
