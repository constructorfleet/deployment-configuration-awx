#!/usr/bin/env bash
BASE_DIR=$(dirname "$(realpath "$0")")
source .print_utils.sh

function verify_venv() {
  writeln "$(style_text "Verifying virtualenv is present..." $BLUE $BOLD)"
  if [[ ! -d "$BASE_DIR/venv" ]]; then
    python3 -m pip install virtualenv
    interpreter_path=$(which python3)
    writeln "$(style_text "Initializing virtualenv $(style_text "venv" $YELLOW $REGULAR) $(style_text "$(python3 --version)" $PURPLE $BOLD )..." $CYAN $REGULAR)"
    python3 -m virtualenv --python $interpreter_path "$BASE_DIR/venv"
  else
    writeln "$(style_text "Virtualenv is present!" $GREEN $BOLD)"
  fi
  source "${BASE_DIR}/venv/bin/activate"
  PATH="${BASE_DIR}/venv/bin:$PATH" VIRTUAL_ENV="${BASE_DIR}/venv" pip3 install --upgrade pip
}

function install_pip_requirements() {
  writeln "$(style_text "Installing pip requirements..." $BLUE $BOLD)"
  source "${BASE_DIR}/venv/bin/activate"
  PATH="${BASE_DIR}/venv/bin:$PATH" VIRTUAL_ENV="${BASE_DIR}/venv" pip3 install -r pip.requirements.yml
  writeln "$(style_text "All pip requirements installed!" $GREEN $BOLD)"
}

function setup_git_hooks() {
  writeln "$(style_text "Setting up git hooks..." $BLUE $BOLD)"
  cp -vf git_hooks/* .git/hooks/.
  writeln "$(style_text "Git hooks setup!" $GREEN $BOLD)"
}

function setup_vault_password() {
  if [[ ! -f "$ANSIBLE_VAULT_PASSWORD_FILE" ]]; then
    write "$(style_text "Enter Vault Password: " $BLUE $BOLD)";
    read -s vault_password;
    echo "$ANSIBLE_VAULT_PASSWORD_FILE";
    echo "$vault_password" > "$ANSIBLE_VAULT_PASSWORD_FILE";
  fi
}

verify_venv
install_pip_requirements
setup_git_hooks
setup_vault_password
