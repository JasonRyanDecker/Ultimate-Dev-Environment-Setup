#!/usr/bin/env bash
# ========================================
# 🔧 Universal Dev Environment Setup (Cross-Platform)
# Node.js + React + TypeScript + VSCode + Vim
# Author: Jason Decker
# ========================================

set -e

# --- Colors ---
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
NC="\033[0m"

banner() {
  echo -e "\n${CYAN}=============================="
  echo -e "$1"
  echo -e "==============================${NC}\n"
}

detect_os() {
  case "$(uname -s)" in
    Linux*)   OS="linux" ;;
    Darwin*)  OS="mac" ;;
    MINGW*|MSYS*|CYGWIN*) OS="windows" ;;
    *)        OS="unknown" ;;
  esac
}

banner "🚀 Starting Jason’s Cross-Platform Dev Environment Setup"
detect_os
echo -e "${GREEN}Detected OS:${NC} $OS"

# --- Linux Install ---
if [ "$OS" = "linux" ]; then
  banner "🧰 Installing Core Packages (Linux)"
  sudo apt update -y && sudo apt install -y curl git build-essential wget vim unzip

# --- macOS Install ---
elif [ "$OS" = "mac" ]; then
  banner "🍎 Installing Core Packages (macOS)"
  if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew update
  brew install git vim wget node nvm

# --- Windows (WSL) ---
elif [ "$OS" = "windows" ]; then
  banner "🪟 WSL Detected"
  echo -e "${YELLOW}Running Linux-style setup in WSL environment...${NC}"
  sudo apt update -y && sudo apt install -y curl git build-essential wget vim unzip
else
  echo -e "${YELLOW}⚠️ Unsupported OS. Please use Linux, macOS, or WSL.${NC}"
  exit 1
fi

# --- Git aliases ---
banner "⚙️ Configuring Git"
git config --global init.defaultBranch main
git config --global alias.st status
git config --global alias.cm "commit -m"
git config --global alias.co checkout
git config --global alias.br branch

# --- NVM + Node ---
banner "🟢 Installing NVM + Node.js (LTS)"
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default lts/*
nvm use default

# --- Global npm tools ---
banner "🌍 Installing Global npm Packages"
npm install -g yarn pnpm vite eslint prettier typescript create-react-app

# --- VS Code ---
banner "🖋️ Installing Visual Studio Code"
if [ "$OS" = "linux" ]; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update -y
  sudo apt install -y code
elif [ "$OS" = "mac" ]; then
  brew install --cask visual-studio-code
fi

# --- Extensions ---
banner "✨ Installing VS Code Extensions"
extensions=(
  dbaeumer.vscode-eslint
  esbenp.prettier-vscode
  ms-vscode.vscode-typescript-next
  msjsdiag.vscode-react-native
  eamodio.gitlens
  bradlc.vscode-tailwindcss
)
for ext in "${extensions[@]}"; do
  code --install-extension "$ext" || true
done

# --- Vim Config ---
banner "📝 Configuring Vim"
cat <<EOF > ~/.vimrc
syntax on
set number
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set cursorline
set background=dark
colorscheme desert
EOF

# --- Projects Setup ---
banner "⚡ Setting Up Example Projects"
mkdir -p ~/Projects && cd ~/Projects
npx create-react-app react-starter --template typescript
npx create-next-app@latest next-starter --typescript --eslint
cd next-starter && npm install -D tailwindcss postcss autoprefixer && npx tailwindcss init -p

banner "🎉 All done!"
echo -e "${GREEN}React Project: ~/Projects/react-starter"
echo -e "Next.js + Tailwind: ~/Projects/next-starter"
echo -e "VS Code: code"
echo -e "Vim: vim${NC}"
