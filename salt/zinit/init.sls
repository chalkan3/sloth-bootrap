zinit_install:
  git.latest:
    - name: https://github.com/zdharma-continuum/zinit.git
    - target: /home/chalkan3/.zinit/bin
    - user: chalkan3
    - force_checkout: True
    - require:
      - user: chalkan3_user
      - pkg: zsh_package