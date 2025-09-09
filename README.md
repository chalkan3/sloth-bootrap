# 🦥 Salt Stack Bootstrap: Comprehensive Environment Setup 🚀

Welcome to your automated Salt Stack bootstrap project! This repository contains an installation script and Salt states to quickly set up a complete development environment on your system.

## ✨ Features

This project offers an elegant and efficient solution for:

*   **Automated Salt Minion Installation**: A bootstrap script (`install.sh`) that detects your operating system and installs `salt-minion` autonomously.
*   **Pretty and Colorful Logs**: The installation script features a visually appealing progress log, with vibrant colors and emojis, including our sloth friends! 🦥
*   **Masterless Configuration**: The `salt-minion` is configured to operate in masterless mode, allowing local execution of Salt states via `salt-call --local`.
*   **Zsh Installation**: Ensures `zsh` is installed on your system.
*   **Custom User Creation**: Automatic creation of the `chalkan3` user with `zsh` set as their default shell.
*   **Dotfiles Management**: Clones your `dotfiles` repository and uses `stow` to create symlinks for Zsh configuration.
*   **Modern `ls` Replacement**: Installs `lsd` for enhanced directory listings.
*   **Nerd Fonts Installation**: Installs FiraCode Nerd Font for improved terminal aesthetics and icon support.
*   **Neovim Installation**: Installs the latest stable Neovim from its AppImage, configured for the `chalkan3` user.
*   **Node Version Manager (nvm)**: Installs `nvm` and sets up the latest LTS Node.js version as default for the `chalkan3` user.
*   **Rust Toolchain**: Installs `rustup` and `cargo` for Rust development.
*   **LunarVim Installation**: Installs LunarVim, a Neovim distribution, with its dependencies.

## 🛠️ How to Use

Follow these steps to get your environment up and running:

### Step 1: Get the Bootstrap Script (`install.sh`)

The `install.sh` script is the starting point. You can execute it directly from the repository using `curl`.

### Step 2: Execute the Bootstrap Script

On the server where you want to set up the environment, run the following command:

```bash
bash <(curl -sL https://raw.githubusercontent.com/chalkan3/sloth-bootrap/master/install.sh)
```

You will be prompted to set a password for the `chalkan3` user during the installation. Observe the colorful log and emojis as the Salt Minion is installed and configured, and your development environment is set up! 🦥



## 📂 Project Structure

```
.
├── install.sh             # Bootstrap script to install and configure the salt-minion
├── uninstall.sh           # Script to uninstall the environment
├── README.md              # This file
└── salt/
    ├── fonts/             # Salt state to install Nerd Fonts
    │   └── init.sls
    ├── lsd/               # Salt state to install lsd
    │   └── init.sls
    ├── lvim/              # Salt state to install LunarVim
    │   └── init.sls
    ├── neovim/            # Salt state to install Neovim
    │   └── init.sls
    ├── nvm/               # Salt state to install nvm and Node.js
    │   └── init.sls
    ├── packages/          # Salt state to install system packages (e.g., zsh, stow, python, make, fd, ripgrep)
    │   └── init.sls
    ├── rust/              # Salt state to install rustup and cargo
    │   └── init.sls
    ├── uninstall/         # Salt state to uninstall the environment
    │   └── init.sls
    ├── users/             # Salt state to manage users and dotfiles (e.g., chalkan3)
    │   └── init.sls
    ├── zinit/             # Salt state to install zinit
    │   └── init.sls
    └── top.sls            # The main file that defines which states to apply
```

## ⚙️ Customization

Here are some examples of how you can customize the Salt states to fit your needs.

*   **User**: To change the user's name, edit `salt/users/init.sls`. For example, to change the user from `chalkan3` to `myuser`:

    '''yaml
    # salt/users/init.sls
    myuser_user:
      user.present:
        - name: myuser
        - shell: /bin/zsh
        # ... other user settings
    
    myuser_dotfiles:
      git.latest:
        - name: https://github.com/myuser/dotfiles
        - target: /home/myuser/.dotfiles
        - user: myuser
        # ... other git settings
    '''
    Remember to update all instances of `chalkan3` to `myuser` in the file.

*   **Packages**: To install other system packages, add them to `salt/packages/init.sls`. For example, to install `htop`:

    '''yaml
    # salt/packages/init.sls
    htop_package:
      pkg.installed:
        - name: htop
    '''

*   **Dotfiles**: The `chalkan3/dotfiles` repository is used for dotfiles. You can change the repository URL in `salt/users/init.sls`.

*   **Nerd Fonts**: The FiraCode Nerd Font is installed. You can modify `salt/fonts/init.sls` to install a different font by changing the URL and file names.

*   **New States**: Create new directories and `.sls` files within `salt/` and include them in `salt/top.sls` to extend automation. For example, to add a new state for installing `mytool`:
    1.  Create `salt/mytool/init.sls` with the installation logic.
    2.  Add `- mytool` to `salt/top.sls`.

## 🤝 Contributing

Feel free to contribute, open issues, or suggest improvements!

## 🗑️ Uninstallation

To completely remove the installed environment, including the `chalkan3` user, all installed packages, and configurations, you can run the `uninstall.sh` script.

**Using `curl` (recommended):**
```bash
bash <(curl -sL https://raw.githubusercontent.com/chalkan3/sloth-bootrap/master/uninstall.sh)
```

**Running locally (if you have cloned the repository):**
```bash
bash uninstall.sh
```

This script will:
- Remove the `chalkan3` user and their home directory.
- Uninstall all system packages installed by the bootstrap script.
- Remove all configuration files and directories created for Neovim, LunarVim, nvm, Rust, etc.
- Purge the `salt-minion` package and clean up Salt configuration files.

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for more details. (Note: The LICENSE file is not included in this example, but it's good practice to add one).
