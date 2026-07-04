# mac-ansible

An Ansible playbook for automating macOS workstation setup.

## What it automates

- Homebrew taps
- Homebrew packages
- Manually managed package installs (custom commands)
- SSH key and config setup
- GPG key import

## Files

- `/home/runner/work/mac-ansible/mac-ansible/playbook.yml` - main playbook
- `/home/runner/work/mac-ansible/mac-ansible/group_vars/all.yml` - editable configuration values
- `/home/runner/work/mac-ansible/mac-ansible/collections/requirements.yml` - required Ansible collections

## Prerequisites

- macOS host
- Ansible installed
- Homebrew installed

Install required Ansible collection:

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

## Configure

Edit `/home/runner/work/mac-ansible/mac-ansible/group_vars/all.yml`.

Example:

```yaml
homebrew_taps:
  - homebrew/cask-fonts

homebrew_packages:
  - git
  - gnupg
  - neovim

manual_packages:
  - install_command: "softwareupdate --install-rosetta --agree-to-license"
    creates: "/Library/Apple/usr/share/rosetta/rosetta"

ssh_private_key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...
  -----END OPENSSH PRIVATE KEY-----

ssh_public_key: "ssh-ed25519 AAAA... user@example.com"

ssh_config: |
  Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

gpg_private_key: |
  -----BEGIN PGP PRIVATE KEY BLOCK-----
  ...
  -----END PGP PRIVATE KEY BLOCK-----

gpg_public_key: |
  -----BEGIN PGP PUBLIC KEY BLOCK-----
  ...
  -----END PGP PUBLIC KEY BLOCK-----
```

## Run

```bash
ansible-playbook -i localhost, playbook.yml
```
