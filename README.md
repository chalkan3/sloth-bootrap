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

The `install.sh` script is the starting point. You will need to host it somewhere accessible via `curl` (e.g., a GitHub Gist, a web server, etc.).

**Example `install.sh` Content (for reference - the full script has already been generated for you):**

```bash
#!/bin/bash
# ... (full install.sh content)
```

### Step 2: Execute the Bootstrap Script

On the server where you want to set up the environment, run the following command. Remember to replace `https://your-server.com/install.sh` with the actual URL where you hosted the script:

```bash
bash <(curl -sL https://raw.githubusercontent.com/chalkan3/sloth-bootrap/master/install.sh)
```

Observe the colorful log and emojis as the Salt Minion is installed and configured, and your development environment is set up! 🦥



## 📂 Project Structure

```
.
├── install.sh             # Bootstrap script to install and configure the salt-minion
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
    ├── users/             # Salt state to manage users and dotfiles (e.g., chalkan3)
    │   └── init.sls
    ├── zinit/             # Salt state to install zinit
    │   └── init.sls
    └── top.sls            # The main file that defines which states to apply
```

## ⚙️ Customization

*   **User**: To change the user's name or settings, edit `salt/users/init.sls`.
*   **Packages**: To install other system packages, add them to `salt/packages/init.sls`.
*   **Dotfiles**: The `chalkan3/dotfiles` repository is used for dotfiles. You can change the repository URL in `salt/users/init.sls`.
*   **Nerd Fonts**: The FiraCode Nerd Font is installed. You can modify `salt/fonts/init.sls` to install a different font.
*   **Neovim/nvm/Rust/LunarVim**: Configuration for these tools can be found in their respective `salt/` subdirectories.
*   **New States**: Create new directories and `.sls` files within `salt/` and include them in `salt/top.sls` to extend automation.

## 🤝 Contributing

Feel free to contribute, open issues, or suggest improvements!

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for more details. (Note: The LICENSE file is not included in this example, but it's good practice to add one).