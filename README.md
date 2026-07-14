# mac-ansible

An Ansible project for provisioning a developer MacBook from a fresh macOS install.

## What this config does

- installs Xcode Command Line Tools when they are missing
- installs Rosetta 2 on Apple Silicon Macs
- installs Homebrew
- installs a curated set of developer CLI tools and desktop apps
- applies a small set of macOS defaults for Finder, Dock, and global preferences

## Repository layout

- `site.yml` — main entrypoint for local provisioning
- `inventories/local/hosts.yml` — localhost inventory
- `inventories/local/group_vars/all.yml` — packages, apps, and macOS settings to customize
- `roles/bootstrap` — first-run setup for a brand new Mac
- `roles/homebrew` — Homebrew taps, formulae, casks, and App Store apps
- `roles/macos` — macOS defaults
- `requirements.yml` — required Ansible collections
- `bootstrap.sh` — helper for getting Ansible onto a fresh machine before the playbook runs

## Fresh Mac bootstrap

Run the bootstrap helper on a brand new Mac after cloning this repository:

```bash
./bootstrap.sh
```

The bootstrap script installs Homebrew if needed, installs Ansible, installs the required Ansible collection, and then runs the playbook locally.

## Customization

Edit `/home/runner/work/mac-ansible/mac-ansible/inventories/local/group_vars/all.yml` to tailor the machine setup:

- `macos_homebrew_formulae` for CLI packages
- `macos_homebrew_casks` for GUI applications
- `macos_homebrew_taps` for additional taps
- `macos_mas_apps` for Mac App Store applications
- `macos_defaults_global`, `macos_defaults_finder`, and `macos_defaults_dock` for macOS preferences

## Running the playbook directly

If Ansible is already installed:

```bash
ansible-galaxy collection install -r requirements.yml
ansible-playbook site.yml --ask-become-pass
```

## Notes

- The playbook is designed for `localhost` and uses a local connection.
- Some bootstrap steps require administrator privileges.
- Mac App Store installs require the user to already be signed in to the App Store.
