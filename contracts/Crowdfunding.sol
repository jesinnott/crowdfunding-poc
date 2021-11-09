// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
    enum FundraisingStatus {
        Opened,
        Closed
    }

    struct Project {
        string id;
        string name;
        string description;
        address payable author;
        FundraisingStatus status;
        uint256 funds;
        uint256 fundraisingGoal;
    }

    struct Contribution {
        address contributor;
        uint256 amount;
    }

    Project[] public projects;
    mapping(string => Contribution[]) public contributions;

    event ProjectCreated(
        string projectId,
        string name,
        string description,
        uint256 fundraisingGoal
    );

    event ProjectFunded(string projectId, address senderBy, uint256 amount);

    event ProjectStatusChanged(string projectId, FundraisingStatus newStatus);

    modifier isAuthor(uint256 projectIndex) {
        require(
            projects[projectIndex].author == msg.sender,
            "Only the project author can update the status..."
        );
        _;
    }

    modifier isNotAuthor(uint256 projectIndex) {
        require(
            projects[projectIndex].author != msg.sender,
            "The author is not eligible to add funds"
        );
        _;
    }

    function createProject(
        string calldata id,
        string calldata name,
        string calldata description,
        uint256 fundraisingGoal
    ) public {
        require(fundraisingGoal > 0, "fundraisingGoal must be greater than 0");
        Project memory project = Project(
            id,
            name,
            description,
            payable(msg.sender),
            FundraisingStatus.Opened,
            0,
            fundraisingGoal
        );
        projects.push(project);
        emit ProjectCreated(id, name, description, fundraisingGoal);
    }

    function fundProject(uint256 projectIndex)
        public
        payable
        isNotAuthor(projectIndex)
    {
        Project memory project = projects[projectIndex];
        require(
            project.status == FundraisingStatus.Opened,
            "Sorry but the project is already closed!"
        );
        require(msg.value > 0, "Funds must be greater than 0!");
        project.author.transfer(msg.value);
        project.funds += msg.value;
        projects[projectIndex] = project;
        contributions[project.id].push(Contribution(msg.sender, msg.value));
        emit ProjectFunded(project.id, msg.sender, msg.value);
    }

    function changeProjectState(
        uint256 projectIndex,
        FundraisingStatus newStatus
    ) public isAuthor(projectIndex) {
        Project memory project = projects[projectIndex];
        require(
            project.status != newStatus,
            "The status you are trying to change is the same as the current one"
        );
        project.status = newStatus;
        projects[projectIndex] = project;
        emit ProjectStatusChanged(project.id, newStatus);
    }
}
