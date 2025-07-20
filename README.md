# Smart Volcano Monitoring System

A comprehensive blockchain-based volcano monitoring system built on Stacks using Clarity smart contracts. This system provides real-time tracking of volcanic activity, coordinated emergency response, and global data sharing for volcanic research.

## System Overview

The Smart Volcano Monitoring System consists of five interconnected smart contracts:

### 1. Seismic Activity Contract (`seismic-activity.clar`)
- Tracks earthquake patterns and seismic readings
- Records magnitude, depth, and frequency data
- Calculates eruption risk levels based on seismic patterns
- Maintains historical seismic data for analysis

### 2. Gas Emission Contract (`gas-emission.clar`)
- Monitors volcanic gas concentrations (SO2, CO2, H2S)
- Tracks gas emission rates and composition changes
- Provides early warning indicators for eruptions
- Records gas measurement data with timestamps

### 3. Evacuation Planning Contract (`evacuation-planning.clar`)
- Manages evacuation zones and population data
- Coordinates emergency response procedures
- Tracks evacuation status and shelter capacity
- Maintains emergency contact information

### 4. Aviation Safety Contract (`aviation-safety.clar`)
- Manages flight restriction zones around active volcanoes
- Tracks ash cloud movements and altitudes
- Issues aviation safety alerts and NOTAMs
- Coordinates with air traffic control systems

### 5. Research Data Contract (`research-data.clar`)
- Centralizes volcanic monitoring data for global sharing
- Manages research permissions and data access
- Tracks data contributions from monitoring stations
- Facilitates international volcanic research collaboration

## Key Features

- **Real-time Monitoring**: Continuous tracking of volcanic indicators
- **Risk Assessment**: Automated calculation of eruption probabilities
- **Emergency Coordination**: Integrated evacuation and safety protocols
- **Data Integrity**: Blockchain-based immutable record keeping
- **Global Collaboration**: Shared research data platform
- **Multi-hazard Approach**: Comprehensive monitoring of all volcanic threats

## Contract Functions

### Seismic Activity
- Record seismic events with magnitude and location
- Calculate risk levels based on activity patterns
- Retrieve historical seismic data
- Generate eruption probability assessments

### Gas Emissions
- Log gas concentration measurements
- Track emission rate changes over time
- Set threshold alerts for dangerous levels
- Analyze gas composition trends

### Evacuation Planning
- Define evacuation zones by risk level
- Register population and infrastructure data
- Coordinate evacuation procedures
- Track shelter capacity and resources

### Aviation Safety
- Establish flight restriction zones
- Monitor ash cloud dispersion
- Issue aviation safety alerts
- Coordinate airspace closures

### Research Data
- Submit monitoring data from stations
- Request access to research datasets
- Share findings with global community
- Maintain data quality standards

## Installation

1. Install Clarinet CLI
2. Clone this repository
3. Run `clarinet check` to validate contracts
4. Use `npm test` to run the test suite
5. Deploy contracts using `clarinet deploy`

## Usage

Each contract can be deployed independently or as part of the complete system. The contracts are designed to work together while maintaining modularity for specific use cases.

## Testing

The system includes comprehensive tests using Vitest to ensure contract functionality and data integrity. Run tests with:

\`\`\`bash
npm test
\`\`\`

## Contributing

This system is designed for global volcanic monitoring collaboration. Contributions from volcanologists, emergency management professionals, and blockchain developers are welcome.

## License

Open source for global volcanic safety and research collaboration.
