nerdfonts_dir:
  file.directory:
    - name: /usr/local/share/fonts/truetype/nerdfonts
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

install_firacode_nerdfont:
  cmd.run:
    - name: |
        wget -q -O /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraCode.zip && \
        sudo unzip -q -o /tmp/FiraCode.zip -d /usr/local/share/fonts/truetype/nerdfonts/ && \
        sudo fc-cache -fv
    - unless: test -f /usr/local/share/fonts/truetype/nerdfonts/FiraCodeNerdFont-Regular.ttf # Check if a specific font file exists
    - require:
      - pkg: unzip_package
      - file: nerdfonts_dir
      - pkg: fontconfig_package

