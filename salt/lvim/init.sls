lvim_install_script:
  cmd.run:
    - name: LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -sL https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) --yes
    - runas: chalkan3
    - unless: test -d /home/chalkan3/.config/lvim # Check if lvim config directory exists
    - require:
      - user: chalkan3_user
      - pkg: make_package
      - pkg: python3_package
      - pkg: python3_pip_package
      - pkg: fd_package
      - pkg: ripgrep_package
      - sls: neovim # Ensure neovim is installed