#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This bootstrap script supports only macOS."
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Xcode Command Line Tools are required. Launching installer..."
  xcode-select --install || true
  echo "Complete installation, then rerun: bash bootstrap.sh"
  exit 1
fi

if [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  BREW_BIN="/opt/homebrew/bin/brew"
else
  BREW_BIN="/usr/local/bin/brew"
fi

eval "$($BREW_BIN shellenv)"

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "Installing Ansible with Homebrew..."
  "$BREW_BIN" install ansible
fi

echo "Installing required Ansible collections..."
ansible-galaxy collection install -r collections/requirements.yml

echo "Running playbook..."
ansible-playbook -i inventories/production/hosts.yml site.yml "$@"