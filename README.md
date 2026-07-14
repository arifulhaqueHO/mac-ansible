# mac-ansible

An Ansible project for provisioning a developer MacBook from a fresh macOS install.

## What this config does

- installs Xcode Command Line Tools when they are missing
- installs Rosetta 2 on Apple Silicon Macs
- installs Xcode Command Line Tools and Homebrew
- installs grouped developer CLI tools and desktop apps

## Repository layout

- `site.yml` — main entrypoint for local provisioning
- `inventories/local/hosts.yml` — localhost inventory
- `roles/bootstrap` — first-run setup for a brand new Mac
- `roles/homebrew` — Homebrew taps, grouped packages, and App Store apps
- `requirements.yml` — required Ansible collections
- `bootstrap.sh` — helper for getting Ansible onto a fresh machine before the playbook runs

## Fresh Mac bootstrap

Run the bootstrap helper on a brand new Mac after cloning this repository:

```bash
./bootstrap.sh
```

The bootstrap script installs Xcode Command Line Tools and Homebrew if needed, installs Ansible, installs the required Ansible collection, and then runs the playbook locally.

## Customization

Edit `/home/runner/work/mac-ansible/mac-ansible/roles/homebrew/defaults/main.yml` to tailor the machine setup:

- `homebrew_formulae` for grouped CLI packages
- `homebrew_casks` for grouped GUI applications
- `homebrew_taps` for additional taps
- `homebrew_mas_apps` for Mac App Store applications

## Running the playbook directly

If Ansible is already installed:

```bash
ansible-galaxy collection install -r requirements.yml
ansible-playbook site.yml --ask-become-pass
```

## Automated validation

GitHub Actions runs automated validation for pull requests and pushes to `main`:

- `yamllint .`
- `ansible-lint`
- `bash -n bootstrap.sh`
- `ansible-playbook --syntax-check site.yml`

## Notes

- The playbook is designed for `localhost` and uses a local connection.
- Some bootstrap steps require administrator privileges.
- Mac App Store installs require the user to already be signed in to the App Store.
