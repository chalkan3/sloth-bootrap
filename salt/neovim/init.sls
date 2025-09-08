neovim_dir:
  file.directory:
    - name: /home/chalkan3/.local/bin
    - user: chalkan3
    - group: chalkan3
    - mode: 755
    - makedirs: True
    - require:
      - user: chalkan3_user # Ensure user exists before creating their directory

neovim_tmp_dir:
  file.directory:
    - name: /home/chalkan3/tmp
    - user: chalkan3
    - group: chalkan3
    - mode: 755
    - makedirs: True
    - require:
      - user: chalkan3_user

neovim_download:
  cmd.run:
    - name: wget -O /home/chalkan3/tmp/nvim-linux-x86_64.appimage https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.appimage
    - runas: chalkan3 # Run as chalkan3
    - unless: test -f /home/chalkan3/.local/bin/nvim # Only download if nvim is not installed
    - require:
      - file: neovim_dir
      - file: neovim_tmp_dir

neovim_install:
  cmd.run:
    - name: chmod u+x /home/chalkan3/tmp/nvim-linux-x86_64.appimage && mv /home/chalkan3/tmp/nvim-linux-x86_64.appimage /home/chalkan3/.local/bin/nvim
    - runas: chalkan3
    - require:
      - cmd: neovim_download
    - unless: test -f /home/chalkan3/.local/bin/nvim # Only install if nvim is not installed

neovim_path_config:
  file.append:
    - name: /home/chalkan3/.zshrc
    - text: |
        # Add ~/.local/bin to PATH if it exists
        if [ -d "$HOME/.local/bin" ] ; then
            PATH="$HOME/.local/bin:$PATH"
        fi
    - unless: grep -q "$HOME/.local/bin" /home/chalkan3/.zshrc
    - require:
      - user: chalkan3_user
      - cmd: neovim_install # Ensure neovim is installed before configuring path