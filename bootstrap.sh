#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
