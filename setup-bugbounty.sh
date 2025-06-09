#!/bin/bash
set -euo pipefail

GREEN='\033[1;32m'
NC='\033[0m'

function header {
  echo -e "${GREEN}==> $1${NC}"
}

#header "1. Configuring Kali Repos & GPG"
#sudo tee /etc/apt/sources.list > /dev/null <<EOF
#deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
#EOF

#curl -fsSL https://archive.kali.org/archive-key.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/kali-archive-keyring.gpg > /dev/null

#sudo apt clean
#sudo rm -rf /var/lib/apt/lists/*
#sudo apt update -o Acquire::ForceIPv4=true
#sudo apt full-upgrade -y

header "2. Installing Base Packages"
sudo apt install -y git curl wget unzip build-essential libpcap-dev jq python3-pip libffi-dev libssl-dev pipx

# Ensure pipx environment is usable
header "Installing pipx if missing"

if ! command -v pipx &>/dev/null; then
  sudo apt install -y pipx
  python3 -m pipx ensurepath
  export PATH="$PATH:$HOME/.local/bin"
fi


header "3. Installing Go (1.22.3)"
GO_VER="1.22.3"
if ! command -v go &>/dev/null || ! go version | grep -q "$GO_VER"; then
  curl -fsSL "https://go.dev/dl/go${GO_VER}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf /tmp/go.tar.gz
fi

export PATH="$PATH:/usr/local/go/bin:$HOME/go/bin"
if ! grep -q 'export PATH=.*\$HOME/go/bin' ~/.bashrc; then
  echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
fi

header "4. Preventing python3-httpx suggestion"
sudo apt-mark hold python3-httpx || true

header "5. Installing/Updating Go Tools"
declare -A TOOLS=(
  [assetfinder]="github.com/tomnomnom/assetfinder@latest"
  [subfinder]="github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
  [httpx]="github.com/projectdiscovery/httpx/cmd/httpx@latest"
  [gau]="github.com/lc/gau/v2/cmd/gau@latest"
  [waybackurls]="github.com/tomnomnom/waybackurls@latest"
  [katana]="github.com/projectdiscovery/katana/cmd/katana@latest"
  [ffuf]="github.com/ffuf/ffuf@latest"
  [nuclei]="github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
)

for name in "${!TOOLS[@]}"; do
  echo -e "${GREEN}→ Installing/updating $name...${NC}"
  go install "${TOOLS[$name]}"
done

header "6. Making httpx (Go) globally available"
if [ -f "$HOME/go/bin/httpx" ]; then
  sudo cp -f "$HOME/go/bin/httpx" /usr/local/bin/httpx
fi

header "7. Installing/Updating Amass"
if dpkg -s amass &>/dev/null; then
  sudo apt install --only-upgrade -y amass amass-common
else
  sudo apt install -y amass amass-common
fi

header "8. Installing ParamSpider via pipx"
mkdir -p "$HOME/tools"
if [ -d "$HOME/tools/paramspider" ]; then
  git -C "$HOME/tools/paramspider" pull
else
  git clone https://github.com/devanshbatham/paramspider.git "$HOME/tools/paramspider"
fi
pipx install --force "$HOME/tools/paramspider"

header "9. Installing wfuzz"
sudo apt install -y wfuzz

header "10. Installing/Updating sqlmap"
if [ -d "$HOME/tools/sqlmap" ]; then
  git -C "$HOME/tools/sqlmap" pull
else
  git clone --depth=1 https://github.com/sqlmapproject/sqlmap.git "$HOME/tools/sqlmap"
fi

header "11. Installing/Updating XSStrike using Python venv"

XS_DIR="$HOME/tools/XSStrike"
XS_VENV="$XS_DIR/.venv"

if [ -d "$XS_DIR" ]; then
  git -C "$XS_DIR" pull
else
  git clone https://github.com/s0md3v/XSStrike.git "$XS_DIR"
fi

if [ ! -d "$XS_VENV" ]; then
  python3 -m venv "$XS_VENV"
fi

source "$XS_VENV/bin/activate"
pip install --upgrade pip
pip install -r "$XS_DIR/requirements.txt"
deactivate

# Crear alias ejecutable opcional
echo "alias xsstrike='python3 $XS_DIR/xsstrike.py'" >> ~/.bashrc


header "12. Cloning Wordlists"
mkdir -p "$HOME/wordlists"
[ -d "$HOME/wordlists/SecLists" ] || git clone https://github.com/danielmiessler/SecLists.git "$HOME/wordlists/SecLists"
[ -d "$HOME/wordlists/PayloadsAllTheThings" ] || git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git "$HOME/wordlists/PayloadsAllTheThings"

header "✅ Environment Ready!"
echo -e "${GREEN}→ Please run: source ~/.bashrc or restart your terminal session.${NC}"
