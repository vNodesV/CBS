# kAtch

## Overview

`kAtch` is a module of `vServ` from `vNodes[V]`, aiming at making the life of blockchain Validators easier. It simplifies tasks like node monitoring, retrieving blockchain information, and checking statuses, reducing operational overhead for Validators and streamlining their workflows.

## Directory Structure

- `config/`
  - `node_config.sh`: Configuration file to define node-specific settings.

- `func/`
  - `check_status.sh`: Script to check the status of nodes.
  - `chain_info.sh`: Script to retrieve blockchain-related information.
  - `get_heights.sh`: Script to monitor and retrieve block heights.

- `kAtch.sh`
  - The main entry point script that sources configuration and function scripts to perform various tasks.

## Installation

To use `kAtch`, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/vNodesV/vServ.git
   ```

2. Navigate to the `kAtch` directory:

   ```bash
   cd vServ/kAtch
   ```

3. Ensure that the scripts have executable permissions:

   ```bash
   chmod +x kAtch.sh func/*.sh
   ```

## Usage

Run the main script to start using `kAtch`:

```bash
./kAtch.sh
```

### Key Functionalities

- **Check Node Status:**

  ```bash
  ./func/check_status.sh
  ```

- **Retrieve Blockchain Information:**

  ```bash
  ./func/chain_info.sh
  ```

- **Monitor Block Heights:**

  ```bash
  ./func/get_heights.sh
  ```

## Configuration

Before running the scripts, ensure that the `config/node_config.sh` file is updated with the correct node and environment settings. This file is sourced by the main script and defines important parameters for your setup.

## About the Coder

This project is brought to you by a 100% self-taught coder, driven by curiosity and a passion for simplifying complex systems. With no formal programming education, this work reflects dedication to learning and solving real-world problems in blockchain validation.

## Terms & Conditions / Disclaimer

The `kAtch` module and associated scripts are provided as-is, without any warranty or guarantee of functionality. While every effort has been made to ensure accuracy and reliability, users are responsible for verifying suitability for their specific use cases. The developer assumes no liability for any issues, losses, or damages that may arise from using this software.

By using `kAtch`, you agree to these terms and take full responsibility for its implementation.

## Contributing

Contributions are highly welcome! Feel free to reach out with improvements, development ideas, tips, or tricks. You can also submit issues or pull requests directly via [gh](https://github.com/vNodesV/vServ).

## License

This project is licensed under the MIT License. See the LICENSE file for details.
