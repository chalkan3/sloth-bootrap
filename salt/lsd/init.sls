lsd_download:
  cmd.run:
    - name: wget -O /tmp/lsd.deb https://github.com/lsd-rs/lsd/releases/download/v1.1.5/lsd_1.1.5_amd64.deb
    - unless: dpkg -s lsd # Only download if lsd is not installed

lsd_install:
  cmd.run:
    - name: sudo dpkg -i /tmp/lsd.deb && sudo apt-get install -f
    - require:
      - cmd: lsd_download
    - unless: dpkg -s lsd # Only install if lsd is not installed