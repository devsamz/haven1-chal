// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IProofOfIdentity.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AcademicCredentialVerifier is Ownable {
    IProofOfIdentity public proofOfIdentityContract;

    enum CredentialStatus { Pending, Verified, Rejected }

    struct AcademicCredential {
        string institution;
        string degree;
        uint256 graduationYear;
        CredentialStatus status;
    }

    mapping(address => AcademicCredential[]) private academicCredentials;

    event CredentialSubmitted(address indexed user, uint256 credentialIndex);
    event CredentialVerified(address indexed user, uint256 credentialIndex);

    // Custom errors
    error InvalidGraduationYear();
    error IdentitySuspended();
    error InsufficientCompetencyRating();
    error InvalidCredentialIndex();
    error CredentialNotPendingVerification();

    constructor(address _proofOfIdentityContract, address initialOwner) Ownable(initialOwner) {
        proofOfIdentityContract = IProofOfIdentity(_proofOfIdentityContract);
    }

    function submitCredential(
        string memory institution,
        string memory degree,
        uint256 graduationYear
    ) external {
        // Custom errors
        if (graduationYear > block.timestamp) revert InvalidGraduationYear();
        if (proofOfIdentityContract.isSuspended(msg.sender)) revert IdentitySuspended();

        (uint256 competencyRating, , ) = proofOfIdentityContract.getCompetencyRating(msg.sender);
        if (competencyRating < 75) revert InsufficientCompetencyRating();

        AcademicCredential memory newCredential = AcademicCredential({
            institution: institution,
            degree: degree,
            graduationYear: graduationYear,
            status: CredentialStatus.Pending
        });

        academicCredentials[msg.sender].push(newCredential);

        emit CredentialSubmitted(msg.sender, academicCredentials[msg.sender].length - 1);
    }

    function verifyCredential(uint256 credentialIndex) external onlyOwner {
        if (credentialIndex >= academicCredentials[msg.sender].length) revert InvalidCredentialIndex();
        if (academicCredentials[msg.sender][credentialIndex].status != CredentialStatus.Pending)
            revert CredentialNotPendingVerification();

        academicCredentials[msg.sender][credentialIndex].status = CredentialStatus.Verified;

        emit CredentialVerified(msg.sender, credentialIndex);
    }

    function rejectCredential(uint256 credentialIndex) external onlyOwner {
        if (credentialIndex >= academicCredentials[msg.sender].length) revert InvalidCredentialIndex();
        if (academicCredentials[msg.sender][credentialIndex].status != CredentialStatus.Pending)
            revert CredentialNotPendingVerification();

        academicCredentials[msg.sender][credentialIndex].status = CredentialStatus.Rejected;
    }

    function getCredentialsCount() external view returns (uint256) {
        return academicCredentials[msg.sender].length;
    }

    function getCredentialByIndex(uint256 index)
        external
        view
        returns (
            string memory institution,
            string memory degree,
            uint256 graduationYear,
            CredentialStatus status
        )
    {
        if (index >= academicCredentials[msg.sender].length) revert InvalidCredentialIndex();

        AcademicCredential storage credential = academicCredentials[msg.sender][index];
        return (credential.institution, credential.degree, credential.graduationYear, credential.status);
    }
}
