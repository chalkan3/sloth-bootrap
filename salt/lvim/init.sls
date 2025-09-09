lvim_install_script:
  cmd.run:
    - name: bash -c "source /home/chalkan3/.cargo/env && LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -sL https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh) --yes"
    - runas: chalkan3
    - unless: test -d /home/chalkan3/.config/lvim
    - require:
      - user: chalkan3_user
      - pkg: make_package
      - pkg: python3_package
      - pkg: python3_pip_package
      - pkg: fd_package
      - pkg: ripgrep_package
      - sls: neovim

lvim_sync_plugins:
  cmd.run:
    - name: lvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    - runas: chalkan3
    - unless: test -d /home/chalkan3/.local/share/lunarvim/site/pack/packer/start/plenary.nvim
    - require:
      - cmd: lvim_install_script