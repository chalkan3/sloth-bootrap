rustup_install_script:
  cmd.run:
    - name: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    - runas: chalkan3
    - unless: test -f /home/chalkan3/.cargo/bin/rustup # Only run if rustup is not installed
    - require:
      - user: chalkan3_user

rust_env_config:
  file.append:
    - name: /home/chalkan3/.zshrc
    - text: |
        # Rustup environment variables
        . "$HOME/.cargo/env"
    - unless: grep -q ".cargo/env" /home/chalkan3/.zshrc
    - require:
      - cmd: rustup_install_script