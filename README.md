# mac-ansible

Modular Ansible setup for macOS using roles.

## What it installs

### Homebrew packages
- git
- lazygit
- lazydocker
- fzf
- zsh
- starship
- zoxide

### Apps (manual website downloads)
- Google Chrome
- Visual Studio Code
- Trillium

### Shell
- oh-my-zsh

## Structure

- `/home/runner/work/mac-ansible/mac-ansible/site.yml` – main playbook
- `/home/runner/work/mac-ansible/mac-ansible/roles/homebrew` – Homebrew formulae
- `/home/runner/work/mac-ansible/mac-ansible/roles/apps` – GUI apps from manual website downloads
- `/home/runner/work/mac-ansible/mac-ansible/roles/shell` – zsh/oh-my-zsh setup
- `/home/runner/work/mac-ansible/mac-ansible/group_vars/all/packages.yml` – package/app lists

## Usage

1. Install required Ansible collection:
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```
2. Run the playbook:
   ```bash
   ansible-playbook site.yml
   ```

## Manual app source configuration

Edit `/home/runner/work/mac-ansible/mac-ansible/group_vars/all/packages.yml` under `manual_apps` to keep each app's direct download URL current.
App installation copies app bundles into `/Applications` and may require sudo privileges.
