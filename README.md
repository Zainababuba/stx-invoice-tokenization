# Invoice Factoring Smart Contract

This smart contract enables businesses to tokenize their invoices as NFTs and sell them at a discount to investors. The process of invoice factoring allows the original owners to liquidate outstanding invoices by selling them before the due date, while investors can claim the full payment once the invoice is due. The contract is implemented in Clarity and provides functionalities for minting, transferring, purchasing, and claiming payments on invoices.

## Table of Contents
- [Contract Overview](#contract-overview)
- [Contract Functions](#contract-functions)
    - [Constants](#constants)
    - [Data Structures](#data-structures)
    - [Read-Only Functions](#read-only-functions)
    - [Public Functions](#public-functions)
    - [Error Codes](#error-codes)
- [Usage Examples](#usage-examples)
- [License](#license)

## Contract Overview

The Invoice Factoring Smart Contract allows businesses to:

- Mint invoice tokens representing outstanding invoices.
- Set invoice details, including amount, due date, and discount rate.
- Transfer these tokens to investors.
- Allow investors to purchase tokens at a discounted rate.
- Enable investors to claim the full payment once the invoice is due.

The contract includes the following functionalities:

- **Invoice Tokenization**: Represent invoices as NFTs with specific metadata (amount, due date, discount rate).
- **Token Transfer**: Enables the transfer of invoice tokens from the business to the investor.
- **Discounted Purchase**: Investors can purchase tokens at a discount before the due date.
- **Claim Payment**: Investors can claim the full payment once the invoice due date has passed.

## Contract Functions

### Constants

- `contract-owner`: The principal address of the contract owner.
- **Error Codes**: Predefined errors for handling various contract failure conditions (detailed in [Error Codes](#error-codes)).

### Data Structures

The contract uses the following data structures:

- `invoices` Map: Stores each invoice’s metadata (amount, due date, discount rate, original owner, and claimed status).
- `token-owners` Map: Maps each token ID to its current owner.
- `invoice-stats` Map: Tracks monthly invoice statistics (total volume, invoice count, average discount, total claimed).
- `user-stats` Map: Tracks each user’s invoice statistics (total issued, total purchased, active invoices, total claimed).

### Read-Only Functions

- `(get-owner (token-id uint))`: Returns the current owner of a given token.
- `(get-invoice (token-id uint))`: Fetches the metadata of a specific invoice.
- `(get-last-token-id)`: Gets the latest token ID minted.
- `(calculate-discounted-amount (amount uint) (discount-rate uint))`: Computes the discounted invoice amount based on the provided rate.
- `(get-monthly-stats (year uint) (month uint))`: Retrieves monthly statistics for invoices.
- `(get-user-stats (user principal))`: Returns a summary of invoice statistics for a particular user.

### Public Functions

- `(mint-invoice (amount uint) (due-date uint) (discount-rate uint))`
    - Mints a new invoice NFT.
    - **Parameters**: `amount`, `due-date`, and `discount-rate`.
    - **Returns**: The new token ID if successful.
    - **Validations**: Checks the amount, discount rate, and due date are valid.

- `(transfer (token-id uint) (sender principal) (recipient principal))`
    - Transfers an invoice token from the sender to a recipient.
    - **Parameters**: `token-id`, `sender`, and `recipient`.
    - **Validations**: Ensures the sender owns the token and it hasn't been claimed.

- `(purchase-invoice (token-id uint))`
    - Allows an investor to purchase an invoice at a discount.
    - **Parameters**: `token-id`.
    - **Process**: Transfers STX from buyer to the current token owner and changes ownership to the buyer.

- `(claim-payment (token-id uint))`
    - Allows the current token owner to claim the full invoice payment from the original owner once the due date has passed.
    - **Parameters**: `token-id`.
    - **Validations**: Verifies that the current owner is the claimant, the invoice is due, and the invoice hasn't already been claimed.

### Error Codes

| Error Code         | Value | Description                                      |
|--------------------|-------|--------------------------------------------------|
| `err-owner-only`   | u100  | Only the contract owner can perform this action. |
| `err-not-token-owner` | u101 | Action requires the caller to own the token.     |
| `err-invalid-discount` | u102 | Discount rate must be within a valid range.      |
| `err-invalid-amount` | u103 | Amount provided is invalid.                      |
| `err-invoice-expired` | u104 | Invoice is expired.                              |
| `err-already-claimed` | u105 | Invoice payment has already been claimed.        |
| `err-token-owner-exists` | u106 | Token owner already exists in the map.          |
| `err-invoice-exists` | u107 | Invoice already exists.                          |
| `err-transfer-failed` | u108 | Token transfer failed.                           |
| `err-claim-update-failed` | u109 | Failed to update invoice claim status.          |

## Usage Examples

### Minting an Invoice

```clarity
(mint-invoice u50000 u50 u1000)
```
Mint a new invoice with an amount of 50000, a due date 50 blocks in the future, and a 10% discount rate.

### Purchasing an Invoice

```clarity
(purchase-invoice u1)
```
Purchase the invoice token with ID 1 at its discounted rate.

### Claiming Payment

```clarity
(claim-payment u1)
```
Claim payment for the invoice token with ID 1 once its due date has passed.

## License

This contract is open-source and licensed under the MIT License. See the LICENSE file for details.