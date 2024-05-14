# Academic Credential Verification System

The Academic Credential Verification System is a Solidity smart contract designed to facilitate the submission and verification of academic credentials on the blockchain. Integrated with the `Haven1 Proof of Identity contract`, it ensures the legitimacy and competency rating of users.

## Functionality

- **Credential Submission:** Users can input their academic credentials, including institution, degree, and year of graduation.
- **Identity Validation:** Credentials undergo verification via the `Haven1 Proof of Identity contract` to confirm users' active status and satisfactory competency rating.
- **Credential Verification:** The contract's owner, typically an educational institution or trusted entity, has the authority to validate submitted credentials.
- **Credential Rejection:** The contract owner possesses the ability to decline credentials that fail to meet verification standards.
- **Owner Management:** As an Ownable contract, the owner maintains control over the verification process.

## How to Use

1. **Initialization:**

   - Begin by initializing the contract, specifying the addresses of the Proof of Identity contract and the initial owner.

2. **Submitting Credentials:**

   - Users employ the `submitCredential` function to input their academic credentials, which subsequently undergo verification against the Proof of Identity.

3. **Credential Verification:**

   - The contract owner utilizes the `verifyCredential` function to authenticate submitted credentials.

4. **Credential Rejection:**

   - The contract owner employs the `rejectCredential` function to decline submitted credentials failing to meet verification criteria.

5. **Accessing Credential Information:**
   
   - Users can retrieve details about their submitted credentials, including status and specifics.

## Custom Error Handling

- `InvalidGraduationYear`: Indicates a graduation year set in the future.
- `IdentitySuspended`: Signals that the user's identity is suspended within the Proof of Identity contract.
- `InsufficientCompetencyRating`: Denotes a competency rating below the required threshold.
- `InvalidCredentialIndex`: Indicates an invalid credential index provided.
- `CredentialNotPendingVerification`: Specifies that the credential is not in a pending verification state.

## Events

- `CredentialSubmitted`: Triggered upon successful submission of a new credential by a user.
- `CredentialVerified`: Triggered when the contract owner verifies a credential.

## System Requirements

- Solidity ^0.8.20
- OpenZeppelin Contracts (Ownable)

## Licensing

This smart contract is licensed under the MIT License; refer to the [LICENSE.md](LICENSE.md) file for further details.
