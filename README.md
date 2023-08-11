# IP-Report Script

This Bash script collects user input to report an IP address and related information via an API.

## Usage

1. Clone this repository:
    git clone https://github.com/kallemarc/Single-Report-v64-Blocker-for-IPv64.net.git


2. Navigate to the repository directory:
   cd Single-Report-v64-Blocker-for-IPv64.net


3. Make the script executable:
  chmod +x mreport.sh

4. Run the script:
  ./mreport.sh

   
## Input Details

- Enter the poisoned IP address.
- Enter the destination port (1-65535).
- Select a category:
- 1: SSH, 2: HTTPs, ..., 13: UDP.
- Optionally provide additional information.

## API Endpoint

The script sends a POST request to the API endpoint to report the IP and related details.


