# mac-ansible

Ansible project to bootstrap a macOS developer machine with Homebrew formulas and casks.

Current scope is intentionally minimal:
- Install Homebrew if missing
- Configure Homebrew taps
- Install CLI packages (formulas)
- Install desktop apps (casks)

The project targets macOS 15 and later.

## Project Structure

```text
.
├── ansible.cfg
├── bootstrap.sh
├── collections
│   └── requirements.yml
├── inventories
│   └── production
│       ├── group_vars
│       │   └── all.yml
│       ├── host_vars
│       │   └── localhost.yml
│       └── hosts.yml
├── roles
│   └── homebrew
│       ├── defaults
│       │   └── main.yml
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── README.md
│       └── tasks
│           └── main.yml
└── site.yml
```

## Prerequisites

1. macOS 15+ (Sequoia or newer)
2. Internet access for Homebrew and package downloads
3. Local admin rights for package and application installation

Recommended Ansible version: 2.15+

## Installation

1. Clone this repository.

2. For a fresh Mac (recommended), run:

```bash
bash bootstrap.sh
```

This script will:
- prompt/install Xcode Command Line Tools if missing
- install Homebrew if missing
- install Ansible if missing
- install required Ansible collections
- run the playbook

3. For an already prepared machine, install required collections manually:

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

4. Review package lists and toggles in inventories/production/group_vars/all.yml.

## Execution

Run syntax check:

```bash
ansible-playbook -i inventories/production/hosts.yml site.yml --syntax-check
```

Dry run (no changes):

```bash
ansible-playbook -i inventories/production/hosts.yml site.yml --check --diff
```

Apply changes:

```bash
ansible-playbook -i inventories/production/hosts.yml site.yml
```

Run only Homebrew-related tasks by tag:

```bash
ansible-playbook -i inventories/production/hosts.yml site.yml --tags brew
```

Useful tag filters:
- brew_install
- brew_taps
- brew_formulas
- brew_casks
- brew_upgrade

## Configuration

Primary variables live in inventories/production/group_vars/all.yml:

- homebrew_taps
- homebrew_trusted_taps
- homebrew_formulae_groups
- homebrew_formulae
- homebrew_cask_groups
- homebrew_casks
- homebrew_update_before_install
- homebrew_upgrade_all
- homebrew_cleanup_after_install

Host-specific overrides can be added in inventories/production/host_vars/localhost.yml.

## Rollback Guidance

This project installs packages and applications but does not force-uninstall by default.

Options:
1. Remove specific formulas manually:
	brew uninstall <formula>
2. Remove specific casks manually:
	brew uninstall --cask <cask>
3. Disable packages in group_vars and re-run playbook to stop future installs.

If you require automated uninstall behavior, add a dedicated teardown playbook with explicit package state absent tasks.

## Troubleshooting

1. Homebrew install fails
	- Ensure you are logged in as a local admin user.
	- Ensure Xcode Command Line Tools are installed:
	  xcode-select -p
	  If missing, run:
	  xcode-select --install
	- Re-run with verbose output:
	  ansible-playbook -i inventories/production/hosts.yml site.yml -vv

2. Cask installation prompts for permissions
	- Some GUI apps require macOS permission prompts or first-launch approval.
	- Re-run the playbook after approving prompts.

3. Ansible cannot find collection modules
	- Run ansible-galaxy collection install -r collections/requirements.yml again.
	- Confirm community.general is installed.

4. Playbook reports unsupported macOS version
	- Check your macOS major version with sw_vers.
	- Update homebrew_min_macos_major_version only if you accept unsupported behavior.

## Idempotency Notes

Role tasks are written to be idempotent:
- Homebrew installation runs only when brew is missing.
- Taps, formulas, and casks are managed with state present.
- Optional upgrade behavior is controlled by variables.

Run the apply command twice to validate no unexpected changes on the second run.