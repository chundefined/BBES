# Bug Bounty Environment Setup

This script (`setup-bugbounty.sh`) provides a complete, professional setup for a modern bug bounty and reconnaissance environment. It installs widely used offensive security tools via secure and compatible methods, accounting for recent changes in Kali’s Python and system package policies.

---

## Tools Installed

| Tool                    | Description                                                                                   |
|-------------------------|-----------------------------------------------------------------------------------------------|
| **Go (1.22.3)**          | Required for modern security tooling such as `httpx`, `nuclei`, etc.                         |
| **assetfinder**          | Passive subdomain enumeration using public sources.                                          |
| **subfinder**            | Fast, active/passive subdomain discovery.                                                    |
| **httpx**                | HTTP probing tool for discovering live hosts and collecting metadata.                        |
| **gau**                  | Retrieves known URLs from public archives and indexers.                                      |
| **waybackurls**          | Extracts historical URLs from the Wayback Machine.                                           |
| **katana**               | Modern web crawler for reconnaissance and dynamic URL discovery.                            |
| **ffuf**                 | Fast web fuzzer useful for directory and endpoint discovery.                                 |
| **nuclei**               | Template-based vulnerability scanner supporting CVEs, misconfigs, exposures, and more.      |
| **amass**                | Advanced attack surface mapping tool (DNS, WHOIS, certs, ASN).                              |
| **paramspider**          | Collects GET parameters and endpoints, used to identify injection points.                    |
| **wfuzz**                | Flexible web fuzzer for brute-force and injection-based attacks.                             |
| **sqlmap**               | Automatic SQL injection and database takeover tool.                                          |
| **XSStrike**             | Advanced XSS scanner and payload generator (runs from an isolated Python venv).              |
| **SecLists**             | Comprehensive wordlist collection for fuzzing and enumeration.                              |
| **PayloadsAllTheThings** | Reference collection of payloads for various attack types (XSS, SSRF, IDOR, etc.).          |

---

## Requirements

- Kali Linux Rolling 2024.1 or later
- Administrative privileges (`sudo`)

---

## Installation

1. Download or clone the repository.
2. Make the script executable:

   ```bash
   chmod +x setup-bugbounty.sh
   ```

3. Execute the script:

   ```bash
   ./setup-bugbounty.sh
   ```

Upon completion, all tools will be installed, updated, and ready for use in your terminal session.

---


## Example Usage

- **httpx**
  ```bash
  echo target.com | httpx
  ```

- **subfinder**
  ```bash
  subfinder -d target.com
  ```

- **nuclei**
  ```bash
  nuclei -u https://target.com -t cves/
  ```

- **XSStrike**
  ```bash
  xsstrike     # Enabled via alias, runs xsstrike.py in venv
  ```

---

## Security Considerations

This script follows the latest best practices:

- Avoids conflicts between system and user-installed Python tools.
- Uses `pipx` or `venv` where appropriate to respect Kali's external package restrictions (PEP 668).
- Ensures `$HOME/go/bin` and `$HOME/.local/bin` are included in the user’s PATH.
- Avoids the use of `pip install --user` system-wide.
- Safe to re-run multiple times (idempotent) without duplicating or corrupting installations.

---

## Extendability

This setup can be extended to include additional reconnaissance or exploitation tools such as:

- `dnsx`, `shuffledns`, `dalfox`, `dirsearch`
- Automatic reconnaissance pipelines
- Containerized deployments (Docker)
- Session management via `tmux` or terminal multiplexers

---

