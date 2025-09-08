chalkan3_user:
  user.present:
    - name: chalkan3
    - shell: /bin/zsh
    - require:
      - pkg: zsh_package

chalkan3_dotfiles:
  git.latest:
    - name: https://github.com/chalkan3/dotfiles
    - target: /home/chalkan3/.dotfiles
    - user: chalkan3
    - force_checkout: True
    - require:
      - user: chalkan3_user

chalkan3_stow_zsh:
  cmd.run:
    - name: stow zsh
    - cwd: /home/chalkan3/.dotfiles
    - runas: chalkan3
    - require:
      - git: chalkan3_dotfiles
      - pkg: stow_package
      - pkg: lsd_package
