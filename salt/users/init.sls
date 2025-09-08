chalkan3_user:
  user.present:
    - name: chalkan3
    - shell: /bin/zsh
    - require:
      - pkg: zsh_package
