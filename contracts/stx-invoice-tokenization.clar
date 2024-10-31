;; Invoice Factoring Smart Contract
;; Allows businesses to tokenize invoices as NFTs and sell them at a discount

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-invalid-discount (err u102))
(define-constant err-invalid-amount (err u103))
(define-constant err-invoice-expired (err u104))
(define-constant err-already-claimed (err u105))

;; Data Variables
(define-data-var last-token-id uint u0)

;; Define invoice token structure
(define-map invoices
    uint
    {
        amount: uint,
        due-date: uint,
        discount-rate: uint,
        original-owner: principal,
        is-claimed: bool
    }
)

;; Define token ownership
(define-map token-owners
    uint
    principal
)

;; SFTs for tracking ownership
;; (impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; Read-only functions
(define-read-only (get-owner (token-id uint))
    (ok (map-get? token-owners token-id))
)

(define-read-only (get-invoice (token-id uint))
    (ok (map-get? invoices token-id))
)

(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

;; Calculate discounted amount
(define-read-only (calculate-discounted-amount (amount uint) (discount-rate uint))
    (let
        (
            (discount (* amount discount-rate))
            (discounted-amount (- amount (/ discount u10000)))
        )
        (ok discounted-amount)
    )
)
