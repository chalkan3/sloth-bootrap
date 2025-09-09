zsh_package:
  pkg.installed:
    - name: zsh

stow_package:
  pkg.installed:
    - name: stow

unzip_package:
  pkg.installed:
    - name: unzip

make_package:
  pkg.installed:
    - name: make

python3_package:
  pkg.installed:
    - name: python3

python3_venv_package:
  pkg.installed:
    - name: python3-venv

python3_pip_package:
  pkg.installed:
    - name: python3-pip
    - require:
      - pkg: python3_venv_package # Ensure venv is installed before pip

fd_package:
  pkg.installed:
    - name: fd-find

ripgrep_package:
  pkg.installed:
    - name: ripgrep

fzf_package:
  pkg.installed:
    - name: fzf
