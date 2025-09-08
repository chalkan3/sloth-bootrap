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
    - name: wget -O /tmp/nvim.appimage https://github.com/neovim/neovim/releases/download/v0.11.3/nvim.appimage
    - unless: test -f /home/chalkan3/.local/bin/nvim # Only download if nvim is not installed
    - require:
      - file: neovim_dir

neovim_install:
  cmd.run:
    - name: chmod u+x /tmp/nvim.appimage && mv /tmp/nvim.appimage /home/chalkan3/.local/bin/nvim
    - runas: chalkan3
    - require:
      - cmd: neovim_download
    - unless: test -f /home/chalkan3/.local/bin/nvim # Only install if nvim is not installed