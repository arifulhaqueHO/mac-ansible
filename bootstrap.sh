#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  sudo touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  PRODUCT="$(softwareupdate -l | awk -F'*' '/\*.*Command Line Tools/ {gsub(/^ Label: /, "", $2); gsub(/^ +/, "", $2); print $2; exit}')"

  if [[ -z "$PRODUCT" ]]; then
    sudo rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
    echo "Unable to locate a Command Line Tools package from softwareupdate." >&2
    exit 1
  fi

  sudo softwareupdate -i "$PRODUCT" --verbose
  sudo rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  BREW_BIN=/opt/homebrew/bin/brew
elif [[ -x /usr/local/bin/brew ]]; then
  BREW_BIN=/usr/local/bin/brew
else
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_BIN=/opt/homebrew/bin/brew
  else
    BREW_BIN=/usr/local/bin/brew
  fi
fi

export PATH="$(dirname "$BREW_BIN"):$PATH"

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "Installing Ansible..."
  "$BREW_BIN" install ansible
fi

echo "Installing required Ansible collections..."
ansible-galaxy collection install -r "$REPO_ROOT/requirements.yml"

echo "Running local MacBook playbook..."
ansible-playbook "$REPO_ROOT/site.yml" --ask-become-pass "$@"
