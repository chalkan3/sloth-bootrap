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
      - sls: lsd

chalkan3_stow_lvim:
  cmd.run:
    - name: stow lvim
    - cwd: /home/chalkan3/.dotfiles
    - runas: chalkan3
    - require:
      - git: chalkan3_dotfiles
      - pkg: stow_package
      - sls: lvim # Ensure lvim is installed
      - cmd: chalkan3_stow_zsh # Run after zsh stow if order matters
