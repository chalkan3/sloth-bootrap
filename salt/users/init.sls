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