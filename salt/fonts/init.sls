install_firacode_nerdfont:
  cmd.run:
    - name: |
        wget -q --show-progress -O /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip && \
        sudo unzip -o /tmp/FiraCode.zip -d /usr/local/share/fonts/truetype/nerdfonts/ && \
        sudo fc-cache -fv
    - unless: test -f /usr/local/share/fonts/truetype/nerdfonts/FiraCodeNerdFont-Regular.ttf # Check if a specific font file exists
    - require:
      - pkg: unzip_package
