neovim_dir:
  file.directory:
    - name: /home/chalkan3/.local/bin
    - user: chalkan3
    - group: chalkan3
    - mode: 755
    - makedirs: True
    - require:
      - user: chalkan3_user # Ensure user exists before creating their directory

neovim_download:
  cmd.run:
    - name: wget -O /tmp/nvim-linux-x86_64.appimage https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-x86_64.appimage
    - unless: test -f /home/chalkan3/.local/bin/nvim # Only download if nvim is not installed
    - require:
      - file: neovim_dir

neovim_install:
  cmd.run:
    - name: chmod u+x /tmp/nvim-linux-x86_64.appimage && mv /tmp/nvim-linux-x86_64.appimage /home/chalkan3/.local/bin/nvim
    - runas: chalkan3
    - require:
      - cmd: neovim_download
    - unless: test -f /home/chalkan3/.local/bin/nvim # Only install if nvim is not installed