nvm_install_script:
  cmd.run:
    - name: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    - runas: chalkan3
    - unless: test -d /home/chalkan3/.nvm # Only run if nvm is not installed
    - require:
      - user: chalkan3_user

nvm_source_config:
  file.append:
    - name: /home/chalkan3/.zshrc
    - text: |
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    - unless: grep -q "NVM_DIR" /home/chalkan3/.zshrc
    - require:
      - cmd: nvm_install_script

node_lts_install:
  cmd.run:
    - name: |
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
        nvm install --lts && nvm alias default lts
    - runas: chalkan3
    - unless: test -f /home/chalkan3/.nvm/default/bin/node # Check if LTS node is installed and set as default
    - require:
      - file: nvm_source_config

npm_global_config:
  cmd.run:
    - name: npm config set prefix '~/.npm-global'
    - runas: chalkan3
    - unless: npm config get prefix | grep -q '~/.npm-global' # Check if already configured
    - require:
      - cmd: node_lts_install # Ensure node/npm is installed