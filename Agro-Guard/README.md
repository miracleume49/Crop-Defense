# CropShield: Automated Parametric Agricultural Risk Management Protocol

## Overview

CropShield is a next-generation blockchain-based agricultural insurance protocol that delivers instantaneous, trustless crop protection through parametric risk assessment. This decentralized platform eliminates traditional insurance friction by automatically triggering compensation when oracle-verified weather conditions exceed predefined agricultural risk thresholds.

## Key Features

- **Automated Claims Processing**: Instant payouts based on weather data without manual assessment
- **Parametric Insurance**: Coverage triggered by measurable weather parameters (precipitation, temperature, wind)
- **Multi-Crop Support**: Configurable risk matrices for different agricultural crop varieties
- **Oracle Integration**: Trusted weather data sources for transparent claim verification
- **Governance Framework**: Decentralized protocol management and configuration
- **Transparent Coverage**: Immutable insurance records on the blockchain

## Architecture

### Core Components

1. **Agricultural Producer Insurance Portfolio**: Maps farmer wallets to insurance policies
2. **Meteorological Data Repository**: Stores timestamped weather measurements from oracles
3. **Oracle Network Registry**: Manages authorized weather data providers
4. **Risk Assessment Matrix**: Defines crop-specific environmental risk thresholds

### Data Structures

#### Insurance Policy
- Premium investment amount
- Maximum claim payout
- Protected crop variety
- Insured farmland area (hectares)
- Coverage period (blockchain height range)
- Policy status and claim processing flags

#### Weather Data
- Precipitation measurements (millimeters)
- Temperature readings (Celsius, decimal scaled)
- Wind velocity (km/h)
- Reporting oracle identity
- Collection timestamp

#### Risk Thresholds (per crop type)
- Drought condition precipitation threshold
- Flood condition precipitation threshold
- Frost damage temperature threshold
- Heat stress temperature threshold
- Wind damage velocity threshold

## Usage

### For Agricultural Producers

#### 1. Establish Insurance Coverage
```clarity
(establish-agricultural-insurance-coverage
  premium-amount           ;; Premium payment in microSTX
  max-claim-amount         ;; Maximum payout amount
  crop-variety             ;; Crop type (e.g., "wheat", "corn")
  farmland-hectares        ;; Insured land area
  coverage-duration        ;; Duration in blockchain blocks
)
```

#### 2. File a Claim
```clarity
(execute-automated-parametric-claim-processing
  weather-event-height     ;; Block height of triggering weather event
)
```

#### 3. Cancel Policy
```clarity
(terminate-active-insurance-policy-with-refund)
```

### For Weather Oracles

#### Submit Weather Data
```clarity
(submit-authenticated-meteorological-measurements
  blockchain-height        ;; Target block height
  precipitation-mm         ;; Precipitation in millimeters
  temperature-scaled       ;; Temperature (Celsius * 10)
  wind-velocity-kmh        ;; Wind speed in km/h
  unix-timestamp          ;; Data collection timestamp
)
```

### For Protocol Governance

#### Configure Crop Risk Parameters
```clarity
(configure-agricultural-crop-environmental-risk-assessment-matrix
  crop-variety            ;; Crop type identifier
  drought-threshold       ;; Drought precipitation threshold (mm)
  flood-threshold         ;; Flood precipitation threshold (mm)
  frost-threshold         ;; Frost temperature threshold (scaled)
  heat-threshold          ;; Heat stress temperature threshold (scaled)
  wind-threshold          ;; Wind damage velocity threshold (km/h)
)
```

#### Manage Oracle Network
```clarity
(authorize-meteorological-oracle-network-participant oracle-address)
(revoke-meteorological-oracle-network-authorization oracle-address)
```

## Query Functions

### Policy Information
- `get-agricultural-producer-insurance-details`: Get policy details for a producer
- `get-protocol-configuration-parameters`: Get current protocol settings
- `get-protocol-operational-status`: Check if protocol is active

### Weather Data
- `get-meteorological-data-by-blockchain-height`: Get weather data for specific block
- `verify-meteorological-oracle-authorization`: Check oracle authorization status

### Risk Assessment
- `get-crop-environmental-risk-assessment-parameters`: Get risk thresholds for crop type
- `evaluate-parametric-claim-eligibility`: Check if claim conditions are met
- `calculate-proportional-policy-refund`: Calculate refund amount for policy cancellation

## Economic Model

### Fee Structure
- **Minimum Premium Threshold**: Base premium requirement (default: 100,000 microSTX)
- **Claim Processing Fee**: Service fee for automated claims (default: 10,000 microSTX)

### Claim Triggers
Claims are automatically triggered when weather conditions exceed crop-specific thresholds:
- **Drought**: Precipitation below minimum threshold
- **Flood**: Precipitation above maximum threshold
- **Frost**: Temperature below minimum threshold
- **Heat Stress**: Temperature above maximum threshold
- **Wind Damage**: Wind velocity above threshold

## Security Features

### Access Control
- **Governance Authority**: Controls protocol configuration and oracle management
- **Oracle Authorization**: Only authorized oracles can submit weather data
- **Policy Validation**: Comprehensive checks prevent invalid policies and claims

### Data Integrity
- **Immutable Records**: All policies and weather data stored on blockchain
- **Timestamp Verification**: Weather data includes collection timestamps
- **Duplicate Prevention**: Prevents duplicate data submissions and claims

## Error Handling

The contract includes comprehensive error handling with specific error codes:
- `ERR-INSUFFICIENT-ADMINISTRATIVE-PRIVILEGES` (100): Unauthorized governance action
- `ERR-AGRICULTURAL-PRODUCER-POLICY-ALREADY-EXISTS` (101): Duplicate policy creation
- `ERR-PREMIUM-PAYMENT-BELOW-MINIMUM-THRESHOLD` (106): Insufficient premium payment
- `ERR-METEOROLOGICAL-ORACLE-NOT-AUTHORIZED` (109): Unauthorized oracle submission
- And many more

## Deployment Requirements

### Prerequisites
- Stacks blockchain environment
- Sufficient STX tokens for contract deployment
- Authorized oracle network setup

### Configuration Steps
1. Deploy the smart contract
2. Configure crop risk matrices for supported crops
3. Authorize meteorological oracles
4. Set minimum premium and processing fees
5. Transfer governance if needed

## Governance

The protocol includes a governance system allowing for:
- Oracle network management
- Risk parameter configuration
- Fee structure adjustments
- Protocol operational control
- Emergency fund recovery

## Security Considerations

- **Oracle Risk**: Reliance on external weather data sources
- **Parameter Risk**: Incorrectly configured risk thresholds
- **Smart Contract Risk**: Potential bugs in claim processing logic
- **Economic Risk**: Insufficient reserves for claim payouts