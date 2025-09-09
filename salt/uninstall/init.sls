
remove_rust:
  cmd.run:
    - name: /home/chalkan3/.cargo/bin/rustup self uninstall -y
    - runas: chalkan3
    - onlyif: test -f /home/chalkan3/.cargo/bin/rustup

remove_lunarvim:
  file.absent:
    - name: /home/chalkan3/.config/lvim
    - onlyif: test -d /home/chalkan3/.config/lvim

remove_lunarvim_data:
  file.absent:
    - name: /home/chalkan3/.local/share/lunarvim
    - onlyif: test -d /home/chalkan3/.local/share/lunarvim

remove_nvm:
  file.absent:
    - name: /home/chalkan3/.nvm
    - onlyif: test -d /home/chalkan3/.nvm

remove_zinit:
  file.absent:
    - name: /home/chalkan3/.zinit
    - onlyif: test -d /home/chalkan3/.zinit

remove_dotfiles:
  file.absent:
    - name: /home/chalkan3/.dotfiles
    - onlyif: test -d /home/chalkan3/.dotfiles

remove_neovim:
  file.absent:
    - name: /home/chalkan3/.local/bin/nvim
    - onlyif: test -f /home/chalkan3/.local/bin/nvim

remove_chalkan3_user:
  user.absent:
    - name: chalkan3
    - purge: True
    - require:
      - cmd: remove_rust
      - file: remove_lunarvim
      - file: remove_lunarvim_data
      - file: remove_nvm
      - file: remove_zinit
      - file: remove_dotfiles
      - file: remove_neovim

remove_nerdfonts:
  file.absent:
    - name: /usr/local/share/fonts/truetype/nerdfonts

remove_lsd:
  pkg.removed:
    - name: lsd

remove_packages:
  pkg.removed:
    - pkgs:
      - zsh
      - stow
      - unzip
      - make
      - python3
      - python3-venv
      - python3-pip
      - fd-find
      - ripgrep
