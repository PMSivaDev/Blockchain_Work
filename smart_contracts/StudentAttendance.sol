// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;


contract student_attendance
{
    address private admin_address;
    struct Student
    {
        string email;
        bool registered;
        uint attendance;
    }
    mapping(address => Student) private students;
    address[] private studentsList;
    
    uint private sessionStartTime;
    uint private sessionEndTime;
    uint private numOfSessions;

    constructor()
    {
        admin_address = msg.sender;        
    }
    function getOwner() public view returns(address)
    {
        return admin_address;
    }
    function get_studentsList() public view returns(address[] memory)
    {
        return studentsList;
    }
    // Only owner can do
    modifier onlyOwner
    {
        require(msg.sender == admin_address , "Only admin can access/call this function");
        _;
    }
    // Only a student can do
    modifier onlyRegisteredStudent
    {
        require(students[msg.sender].registered , "This Student must be registered to perform this action");
        _;
    }
    // Restrict the onwer from doing
    modifier notOnlyOwner
    {
        require(msg.sender != admin_address , "admin can not access/call this function");
        _;
    }
    event studentRegnCompleted ( address currentStudentAddress, string currentStudentEmail);

    function registerStudent(string memory _email) public notOnlyOwner
    {
        Student memory currentStudent = Student({email : _email, registered : true , attendance : 0 });
        // alternate way for creating student object
        //Student currentStudent = Student( _email,  true ,  0 ); 
        students[msg.sender] = currentStudent;
        studentsList.push(msg.sender);
        emit studentRegnCompleted(msg.sender, _email);
    }

    function startSession() public onlyOwner 
    {
        require(sessionEndTime < block.timestamp , "Already a session is going on actively");
        sessionStartTime = block.timestamp;
        sessionEndTime = sessionStartTime + 2 hours;
        numOfSessions++;
    }
    
    function markAttendance() public notOnlyOwner onlyRegisteredStudent 
    {
        require(sessionEndTime > block.timestamp , " No session is going on actively");
        students[msg.sender].attendance++;
    }

    function getTotalSessions() public view returns(uint)
    {
        return numOfSessions;
    }
    function getStudentAttendance() public view returns(uint)
    {
        return students[msg.sender].attendance;
    }
}