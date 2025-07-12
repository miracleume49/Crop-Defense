;; CropShield: Automated Parametric Agricultural Risk Management Protocol Smart Contract
;; 
;; A next-generation blockchain-based agricultural insurance protocol that delivers
;; instantaneous, trustless crop protection through parametric risk assessment.
;; This decentralized platform eliminates traditional insurance friction by
;; automatically triggering compensation when oracle-verified weather conditions
;; exceed predefined agricultural risk thresholds. The protocol supports multiple
;; crop varieties, customizable risk matrices, and provides transparent,
;; immutable insurance coverage for global agricultural producers.

;; PROTOCOL GOVERNANCE AND SYSTEM CONFIGURATION

(define-data-var protocol-governance-authority principal tx-sender)
(define-data-var minimum-policy-premium-threshold uint u100000) ;; Base premium in microSTX
(define-data-var automated-claim-processing-fee uint u10000) ;; Service fee in microSTX
(define-data-var protocol-active-operational-status bool true) ;; Global system availability

;; CORE PROTOCOL DATA ARCHITECTURE

;; Agricultural Producer Insurance Portfolio Registry
;; Comprehensive mapping of agricultural producer wallet addresses to insurance policies
(define-map agricultural-producer-insurance-portfolio
  principal
  {
    committed-premium-investment: uint,
    guaranteed-maximum-claim-payout: uint,
    protected-agricultural-crop-variety: (string-ascii 20),
    insured-agricultural-land-hectares: uint,
    coverage-initiation-blockchain-height: uint,
    coverage-termination-blockchain-height: uint,
    policy-activation-operational-status: bool,
    claim-payout-processing-completion-flag: bool
  }
)

;; Meteorological Data Blockchain Repository
;; Timestamped weather measurements submitted by certified oracle networks
(define-map blockchain-meteorological-data-repository
  uint
  {
    recorded-precipitation-measurement-millimeters: uint,
    recorded-ambient-temperature-celsius-decimal-scaled: int,
    recorded-wind-velocity-measurement-kmh: uint,
    authorized-meteorological-oracle-reporter: principal,
    data-collection-unix-timestamp-seconds: uint
  }
)

;; Authorized Meteorological Oracle Network Registry
;; Certified weather data provider authentication system
(define-map authorized-meteorological-oracle-network principal bool)

;; Agricultural Crop Environmental Risk Assessment Matrix
;; Parametric threshold configuration for crop-specific environmental hazards
(define-map agricultural-crop-environmental-risk-matrix
  (string-ascii 20)
  {
    drought-condition-precipitation-threshold-mm: uint,
    flood-condition-precipitation-threshold-mm: uint,
    frost-damage-temperature-threshold-celsius-scaled: int,
    heat-stress-temperature-threshold-celsius-scaled: int,
    wind-damage-velocity-threshold-kmh: uint
  }
)

;; PROTOCOL ERROR HANDLING AND VALIDATION CONSTANTS

(define-constant ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES (err u100))
(define-constant ERR-AGRICULTURAL-PRODUCER-POLICY-ALREADY-EXISTS (err u101))
(define-constant ERR-AGRICULTURAL-PRODUCER-POLICY-NOT-FOUND (err u102))
(define-constant ERR-INSURANCE-COVERAGE-PERIOD-EXPIRED (err u103))
(define-constant ERR-INSURANCE-POLICY-DEACTIVATED-STATUS (err u104))
(define-constant ERR-INSURANCE-CLAIM-PREVIOUSLY-PROCESSED (err u105))
(define-constant ERR-PREMIUM-PAYMENT-BELOW-MINIMUM-THRESHOLD (err u106))
(define-constant ERR-PROTOCOL-TEMPORARILY-UNAVAILABLE (err u107))
(define-constant ERR-INVALID-FUNCTION-PARAMETER-VALUES (err u108))
(define-constant ERR-METEOROLOGICAL-ORACLE-NOT-AUTHORIZED (err u109))
(define-constant ERR-METEOROLOGICAL-DATA-RECORD-EXISTS (err u110))
(define-constant ERR-METEOROLOGICAL-DATA-UNAVAILABLE (err u111))
(define-constant ERR-CROP-RISK-PARAMETERS-NOT-CONFIGURED (err u112))
(define-constant ERR-ORACLE-REGISTRATION-CONFLICT (err u113))
(define-constant ERR-UNSUPPORTED-AGRICULTURAL-CROP-TYPE (err u114))
(define-constant ERR-RISK-THRESHOLD-CONFIGURATION-ERROR (err u115))

;; PROTOCOL INFORMATION AND QUERY INTERFACE

;; Retrieve protocol governance authority address
(define-read-only (get-protocol-governance-authority)
  (var-get protocol-governance-authority)
)

;; Query agricultural producer insurance portfolio details
(define-read-only (get-agricultural-producer-insurance-details (producer-wallet-address principal))
  (map-get? agricultural-producer-insurance-portfolio producer-wallet-address)
)

;; Retrieve meteorological data for specific blockchain height
(define-read-only (get-meteorological-data-by-blockchain-height (target-blockchain-height uint))
  (map-get? blockchain-meteorological-data-repository target-blockchain-height)
)

;; Verify meteorological oracle authorization credentials
(define-read-only (verify-meteorological-oracle-authorization (oracle-wallet-address principal))
  (default-to false (map-get? authorized-meteorological-oracle-network oracle-wallet-address))
)

;; Retrieve crop-specific environmental risk assessment parameters
(define-read-only (get-crop-environmental-risk-assessment-parameters (agricultural-crop-variety (string-ascii 20)))
  (map-get? agricultural-crop-environmental-risk-matrix agricultural-crop-variety)
)

;; Query current protocol operational status
(define-read-only (get-protocol-operational-status)
  (var-get protocol-active-operational-status)
)

;; Retrieve comprehensive protocol configuration settings
(define-read-only (get-protocol-configuration-parameters)
  {
    minimum-premium-requirement: (var-get minimum-policy-premium-threshold),
    claim-processing-service-fee: (var-get automated-claim-processing-fee),
    system-operational-availability: (var-get protocol-active-operational-status),
    governance-authority: (var-get protocol-governance-authority)
  }
)

;; AUTOMATED CLAIM ELIGIBILITY ASSESSMENT ENGINE

;; Comprehensive parametric claim eligibility evaluation algorithm
(define-read-only (evaluate-parametric-claim-eligibility 
    (agricultural-producer-address principal) 
    (meteorological-event-blockchain-height uint))
  (let (
    (producer-insurance-portfolio (map-get? agricultural-producer-insurance-portfolio agricultural-producer-address))
    (meteorological-event-data (map-get? blockchain-meteorological-data-repository meteorological-event-blockchain-height))
  )
    (match producer-insurance-portfolio
      insurance-policy-record
      (match meteorological-event-data
        weather-measurement-record
        (match (map-get? agricultural-crop-environmental-risk-matrix 
                        (get protected-agricultural-crop-variety insurance-policy-record))
          environmental-risk-thresholds
          (and
            ;; Policy must be active and claims not previously processed
            (get policy-activation-operational-status insurance-policy-record)
            (not (get claim-payout-processing-completion-flag insurance-policy-record))
            ;; Meteorological event must occur within active coverage period
            (>= meteorological-event-blockchain-height 
                (get coverage-initiation-blockchain-height insurance-policy-record))
            (<= meteorological-event-blockchain-height 
                (get coverage-termination-blockchain-height insurance-policy-record))
            ;; Environmental conditions must exceed parametric risk thresholds
            (or
              ;; Severe drought conditions detected
              (< (get recorded-precipitation-measurement-millimeters weather-measurement-record) 
                 (get drought-condition-precipitation-threshold-mm environmental-risk-thresholds))
              ;; Catastrophic flooding conditions detected
              (> (get recorded-precipitation-measurement-millimeters weather-measurement-record) 
                 (get flood-condition-precipitation-threshold-mm environmental-risk-thresholds))
              ;; Frost damage conditions detected
              (< (get recorded-ambient-temperature-celsius-decimal-scaled weather-measurement-record) 
                 (get frost-damage-temperature-threshold-celsius-scaled environmental-risk-thresholds))
              ;; Heat stress conditions detected
              (> (get recorded-ambient-temperature-celsius-decimal-scaled weather-measurement-record) 
                 (get heat-stress-temperature-threshold-celsius-scaled environmental-risk-thresholds))
              ;; Wind damage conditions detected
              (> (get recorded-wind-velocity-measurement-kmh weather-measurement-record) 
                 (get wind-damage-velocity-threshold-kmh environmental-risk-thresholds))
            )
          )
          false
        )
        false
      )
      false
    )
  )
)

;; Calculate proportional refund for policy cancellation
(define-read-only (calculate-proportional-policy-refund 
    (agricultural-producer-address principal) 
    (cancellation-blockchain-height uint))
  (match (map-get? agricultural-producer-insurance-portfolio agricultural-producer-address)
    insurance-policy-record
    (let (
      (total-coverage-duration 
        (- (get coverage-termination-blockchain-height insurance-policy-record) 
           (get coverage-initiation-blockchain-height insurance-policy-record)))
      (remaining-coverage-duration 
        (- (get coverage-termination-blockchain-height insurance-policy-record) 
           cancellation-blockchain-height))
    )
      (if (> remaining-coverage-duration u0)
        (/ (* (get committed-premium-investment insurance-policy-record) remaining-coverage-duration) 
           total-coverage-duration)
        u0)
    )
    u0
  )
)

;; AGRICULTURAL PRODUCER INSURANCE POLICY MANAGEMENT

;; Establish comprehensive agricultural insurance coverage
(define-public (establish-agricultural-insurance-coverage
    (premium-investment-amount uint)
    (maximum-claim-coverage-amount uint)
    (protected-crop-variety (string-ascii 20))
    (insured-farmland-area-hectares uint)
    (coverage-duration-blockchain-blocks uint))
  (let (
    (current-blockchain-height block-height)
    (coverage-activation-height current-blockchain-height)
    (coverage-expiration-height (+ current-blockchain-height coverage-duration-blockchain-blocks))
  )
    ;; Comprehensive protocol and parameter validation
    (asserts! (var-get protocol-active-operational-status) ERR-PROTOCOL-TEMPORARILY-UNAVAILABLE)
    (asserts! (is-none (map-get? agricultural-producer-insurance-portfolio tx-sender)) 
              ERR-AGRICULTURAL-PRODUCER-POLICY-ALREADY-EXISTS)
    (asserts! (>= premium-investment-amount (var-get minimum-policy-premium-threshold)) 
              ERR-PREMIUM-PAYMENT-BELOW-MINIMUM-THRESHOLD)
    (asserts! (> maximum-claim-coverage-amount premium-investment-amount) 
              ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    (asserts! (> insured-farmland-area-hectares u0) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    (asserts! (> coverage-duration-blockchain-blocks u0) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    (asserts! (is-some (map-get? agricultural-crop-environmental-risk-matrix protected-crop-variety)) 
              ERR-UNSUPPORTED-AGRICULTURAL-CROP-TYPE)
    
    ;; Execute premium payment transaction
    (try! (stx-transfer? premium-investment-amount tx-sender (as-contract tx-sender)))
    
    ;; Establish agricultural producer insurance portfolio entry
    (map-set agricultural-producer-insurance-portfolio tx-sender {
      committed-premium-investment: premium-investment-amount,
      guaranteed-maximum-claim-payout: maximum-claim-coverage-amount,
      protected-agricultural-crop-variety: protected-crop-variety,
      insured-agricultural-land-hectares: insured-farmland-area-hectares,
      coverage-initiation-blockchain-height: coverage-activation-height,
      coverage-termination-blockchain-height: coverage-expiration-height,
      policy-activation-operational-status: true,
      claim-payout-processing-completion-flag: false
    })
    
    (ok true)
  )
)

;; Execute automated parametric insurance claim processing
(define-public (execute-automated-parametric-claim-processing 
    (meteorological-event-blockchain-height uint))
  (let (
    (claiming-agricultural-producer tx-sender)
    (producer-insurance-portfolio (map-get? agricultural-producer-insurance-portfolio claiming-agricultural-producer))
  )
    ;; Protocol availability and policy existence validation
    (asserts! (var-get protocol-active-operational-status) ERR-PROTOCOL-TEMPORARILY-UNAVAILABLE)
    (asserts! (is-some producer-insurance-portfolio) ERR-AGRICULTURAL-PRODUCER-POLICY-NOT-FOUND)
    
    (let (
      (insurance-policy-details (unwrap-panic producer-insurance-portfolio))
    )
      ;; Comprehensive policy status and eligibility validation
      (asserts! (get policy-activation-operational-status insurance-policy-details) 
                ERR-INSURANCE-POLICY-DEACTIVATED-STATUS)
      (asserts! (not (get claim-payout-processing-completion-flag insurance-policy-details)) 
                ERR-INSURANCE-CLAIM-PREVIOUSLY-PROCESSED)
      (asserts! (<= (get coverage-initiation-blockchain-height insurance-policy-details) 
                    meteorological-event-blockchain-height) 
                ERR-INVALID-FUNCTION-PARAMETER-VALUES)
      (asserts! (>= (get coverage-termination-blockchain-height insurance-policy-details) 
                    meteorological-event-blockchain-height) 
                ERR-INSURANCE-COVERAGE-PERIOD-EXPIRED)
      (asserts! (is-some (map-get? blockchain-meteorological-data-repository meteorological-event-blockchain-height)) 
                ERR-METEOROLOGICAL-DATA-UNAVAILABLE)
      
      ;; Verify parametric claim eligibility criteria
      (asserts! (evaluate-parametric-claim-eligibility claiming-agricultural-producer meteorological-event-blockchain-height) 
                ERR-INVALID-FUNCTION-PARAMETER-VALUES)
      
      ;; Process automated claim service fee
      (try! (stx-transfer? (var-get automated-claim-processing-fee) tx-sender (as-contract tx-sender)))
      
      ;; Execute guaranteed maximum claim payout
      (try! (as-contract (stx-transfer? (get guaranteed-maximum-claim-payout insurance-policy-details) 
                                        tx-sender claiming-agricultural-producer)))
      
      ;; Update policy processing completion status
      (map-set agricultural-producer-insurance-portfolio claiming-agricultural-producer 
        (merge insurance-policy-details { claim-payout-processing-completion-flag: true }))
      
      (ok true)
    )
  )
)

;; Terminate active insurance policy with proportional refund
(define-public (terminate-active-insurance-policy-with-refund)
  (let (
    (policy-terminating-producer tx-sender)
    (existing-insurance-portfolio (map-get? agricultural-producer-insurance-portfolio policy-terminating-producer))
    (current-blockchain-height block-height)
  )
    ;; Protocol availability and policy existence validation
    (asserts! (var-get protocol-active-operational-status) ERR-PROTOCOL-TEMPORARILY-UNAVAILABLE)
    (asserts! (is-some existing-insurance-portfolio) ERR-AGRICULTURAL-PRODUCER-POLICY-NOT-FOUND)
    
    (let (
      (insurance-policy-information (unwrap-panic existing-insurance-portfolio))
      (calculated-proportional-refund (calculate-proportional-policy-refund policy-terminating-producer current-blockchain-height))
    )
      (asserts! (get policy-activation-operational-status insurance-policy-information) 
                ERR-INSURANCE-POLICY-DEACTIVATED-STATUS)
      (asserts! (not (get claim-payout-processing-completion-flag insurance-policy-information)) 
                ERR-INSURANCE-CLAIM-PREVIOUSLY-PROCESSED)
      
      ;; Execute proportional refund if applicable
      (if (> calculated-proportional-refund u0)
        (try! (as-contract (stx-transfer? calculated-proportional-refund tx-sender policy-terminating-producer)))
        true)
      
      ;; Deactivate insurance policy
      (map-set agricultural-producer-insurance-portfolio policy-terminating-producer 
        (merge insurance-policy-information { policy-activation-operational-status: false }))
      
      (ok true)
    )
  )
)

;; METEOROLOGICAL ORACLE DATA SUBMISSION INTERFACE

;; Submit authenticated meteorological measurements to blockchain
(define-public (submit-authenticated-meteorological-measurements
    (target-blockchain-height uint)
    (precipitation-measurement-millimeters uint)
    (temperature-measurement-celsius-decimal-scaled int)
    (wind-velocity-measurement-kmh uint)
    (measurement-collection-unix-timestamp uint))
  (let (
    (submitting-meteorological-oracle tx-sender)
  )
    ;; Oracle authorization and data integrity validation
    (asserts! (var-get protocol-active-operational-status) ERR-PROTOCOL-TEMPORARILY-UNAVAILABLE)
    (asserts! (verify-meteorological-oracle-authorization submitting-meteorological-oracle) 
              ERR-METEOROLOGICAL-ORACLE-NOT-AUTHORIZED)
    (asserts! (is-none (map-get? blockchain-meteorological-data-repository target-blockchain-height)) 
              ERR-METEOROLOGICAL-DATA-RECORD-EXISTS)
    
    ;; Comprehensive meteorological data range validation
    (asserts! (>= precipitation-measurement-millimeters u0) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    (asserts! (>= wind-velocity-measurement-kmh u0) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    (asserts! (>= measurement-collection-unix-timestamp u0) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    (asserts! (and (>= temperature-measurement-celsius-decimal-scaled (- 0 500)) 
                   (<= temperature-measurement-celsius-decimal-scaled 1000)) 
              ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    
    ;; Store validated meteorological measurements
    (map-set blockchain-meteorological-data-repository target-blockchain-height {
      recorded-precipitation-measurement-millimeters: precipitation-measurement-millimeters,
      recorded-ambient-temperature-celsius-decimal-scaled: temperature-measurement-celsius-decimal-scaled,
      recorded-wind-velocity-measurement-kmh: wind-velocity-measurement-kmh,
      authorized-meteorological-oracle-reporter: submitting-meteorological-oracle,
      data-collection-unix-timestamp-seconds: measurement-collection-unix-timestamp
    })
    
    (ok true)
  )
)

;; PROTOCOL GOVERNANCE AND ADMINISTRATIVE FUNCTIONS

;; Authorize new meteorological oracle network participant
(define-public (authorize-meteorological-oracle-network-participant (oracle-wallet-address principal))
  (begin
    ;; Governance authority privilege verification
    (asserts! (is-eq tx-sender (var-get protocol-governance-authority)) ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES)
    (asserts! (not (verify-meteorological-oracle-authorization oracle-wallet-address)) ERR-ORACLE-REGISTRATION-CONFLICT)
    
    (map-set authorized-meteorological-oracle-network oracle-wallet-address true)
    (ok true)
  )
)

;; Revoke meteorological oracle network authorization
(define-public (revoke-meteorological-oracle-network-authorization (oracle-wallet-address principal))
  (begin
    ;; Governance authority privilege verification
    (asserts! (is-eq tx-sender (var-get protocol-governance-authority)) ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES)
    (asserts! (verify-meteorological-oracle-authorization oracle-wallet-address) ERR-METEOROLOGICAL-ORACLE-NOT-AUTHORIZED)
    
    (map-delete authorized-meteorological-oracle-network oracle-wallet-address)
    (ok true)
  )
)

;; Configure agricultural crop environmental risk assessment matrix
(define-public (configure-agricultural-crop-environmental-risk-assessment-matrix
    (agricultural-crop-variety (string-ascii 20))
    (drought-precipitation-threshold-mm uint)
    (flood-precipitation-threshold-mm uint)
    (frost-temperature-threshold-celsius-scaled int)
    (heat-temperature-threshold-celsius-scaled int)
    (wind-damage-velocity-threshold-kmh uint))
  (begin
    ;; Governance authority access and parameter validation
    (asserts! (is-eq tx-sender (var-get protocol-governance-authority)) ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES)
    (asserts! (> flood-precipitation-threshold-mm drought-precipitation-threshold-mm) ERR-RISK-THRESHOLD-CONFIGURATION-ERROR)
    (asserts! (< frost-temperature-threshold-celsius-scaled heat-temperature-threshold-celsius-scaled) ERR-RISK-THRESHOLD-CONFIGURATION-ERROR)
    (asserts! (> wind-damage-velocity-threshold-kmh u0) ERR-RISK-THRESHOLD-CONFIGURATION-ERROR)
    (asserts! (not (is-eq agricultural-crop-variety "")) ERR-UNSUPPORTED-AGRICULTURAL-CROP-TYPE)
    (asserts! (>= drought-precipitation-threshold-mm u0) ERR-RISK-THRESHOLD-CONFIGURATION-ERROR)
    
    ;; Store validated environmental risk assessment parameters
    (map-set agricultural-crop-environmental-risk-matrix agricultural-crop-variety {
      drought-condition-precipitation-threshold-mm: drought-precipitation-threshold-mm,
      flood-condition-precipitation-threshold-mm: flood-precipitation-threshold-mm,
      frost-damage-temperature-threshold-celsius-scaled: frost-temperature-threshold-celsius-scaled,
      heat-stress-temperature-threshold-celsius-scaled: heat-temperature-threshold-celsius-scaled,
      wind-damage-velocity-threshold-kmh: wind-damage-velocity-threshold-kmh
    })
    (ok true)
  )
)

;; Adjust minimum policy premium threshold requirements
(define-public (adjust-minimum-policy-premium-threshold-requirements (updated-minimum-premium-threshold uint))
  (begin
    ;; Governance authority access validation
    (asserts! (is-eq tx-sender (var-get protocol-governance-authority)) ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES)
    (asserts! (> updated-minimum-premium-threshold u0) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    
    (var-set minimum-policy-premium-threshold updated-minimum-premium-threshold)
    (ok true)
  )
)

;; Modify automated claim processing service fee structure
(define-public (modify-automated-claim-processing-service-fee-structure (updated-processing-service-fee uint))
  (begin
    ;; Governance authority privilege verification
    (asserts! (is-eq tx-sender (var-get protocol-governance-authority)) ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES)
    (asserts! (>= updated-processing-service-fee u0) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    
    (var-set automated-claim-processing-fee updated-processing-service-fee)
    (ok true)
  )
)

;; Control protocol operational availability status
(define-public (control-protocol-operational-availability-status (operational-availability-status bool))
  (begin
    ;; Governance authority authorization verification
    (asserts! (is-eq tx-sender (var-get protocol-governance-authority)) ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES)
    
    (var-set protocol-active-operational-status operational-availability-status)
    (ok true)
  )
)

;; Transfer protocol governance authority privileges
(define-public (transfer-protocol-governance-authority-privileges (successor-governance-authority principal))
  (begin
    ;; Current governance authority validation
    (asserts! (is-eq tx-sender (var-get protocol-governance-authority)) ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES)
    (asserts! (not (is-eq successor-governance-authority tx-sender)) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    
    (var-set protocol-governance-authority successor-governance-authority)
    (ok true)
  )
)

;; Emergency protocol treasury fund recovery mechanism
(define-public (emergency-protocol-treasury-fund-recovery (recovery-fund-amount uint))
  (begin
    ;; Governance authority access and amount validation
    (asserts! (is-eq tx-sender (var-get protocol-governance-authority)) ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES)
    (asserts! (> recovery-fund-amount u0) ERR-INVALID-FUNCTION-PARAMETER-VALUES)
    
    (try! (as-contract (stx-transfer? recovery-fund-amount tx-sender (var-get protocol-governance-authority))))
    (ok true)
  )
)