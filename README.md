# 🦥 Salt Stack Bootstrap: Zsh & User Configuration 🚀

Welcome to your automated Salt Stack bootstrap project! This repository contains an installation script and Salt states to quickly set up your environment, installing `zsh` and creating a dedicated user with it as their default shell.

## ✨ Features

This project offers an elegant and efficient solution for:

*   **Automated Salt Minion Installation**: A bootstrap script (`install.sh`) that detects your operating system and installs `salt-minion` autonomously.
*   **Pretty and Colorful Logs**: The installation script features a visually appealing progress log, with vibrant colors and emojis, including our sloth friends! 🦥
*   **Masterless Configuration**: The `salt-minion` is configured to operate in masterless mode, allowing local execution of Salt states via `salt-call --local`.
*   **Zsh Installation**: A dedicated Salt state to ensure `zsh` is installed on your system.
*   **Custom User Creation**: Automatic creation of the `chalkan3` user with `zsh` set as their default shell.

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
bash <(curl -sL https://raw.githubusercontent.com/chalkan3/sloth-bootstrap/main/install.sh)
```

Observe the colorful log and emojis as the Salt Minion is installed and configured! 🦥

### Step 3: Copy Salt States

After the `install.sh` script completes, you will need to copy the Salt state files (`.sls`) from this repository to the `/srv/salt` directory on your server. This is where the `salt-minion` looks for states in masterless mode.

Assuming you are in the root directory of this project (`/home/chalkan3/.projects/sloth-bootstrap`), execute:

```bash
sudo cp -r salt/* /srv/salt/
```

### Step 4: Apply Salt States

With the Salt states in place, you can now instruct the `salt-minion` to apply them locally. This will install `zsh` and create the `chalkan3` user.

```bash
sudo salt-call --local state.apply
```

🎉 Congratulations! Your environment should now have `zsh` installed and the `chalkan3` user configured to use it.

## 📂 Project Structure

```
. 
├── install.sh             # Bootstrap script to install and configure the salt-minion
├── README.md              # This file
└── salt/
    ├── packages/
    │   └── init.sls       # Salt state to install packages (e.g., zsh)
    ├── users/
    │   └── init.sls       # Salt state to manage users (e.g., chalkan3)
    └── top.sls            # The main file that defines which states to apply
```

## ⚙️ Customization

*   **User**: To change the user's name or settings, edit `salt/users/init.sls`.
*   **Packages**: To install other packages, add them to `salt/packages/init.sls`.
*   **New States**: Create new directories and `.sls` files within `salt/` and include them in `salt/top.sls` to extend automation.

## 🤝 Contributing

Feel free to contribute, open issues, or suggest improvements!

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for more details. (Note: The LICENSE file is not included in this example, but it's good practice to add one).