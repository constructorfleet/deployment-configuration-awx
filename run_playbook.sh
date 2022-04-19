#!/bin/bash
source "$(pwd)/.print_utils.sh"

environment=${ANSIBLE_ENVIRONMENT:-DEV}

if [[ ! -d venv ]]; then
  writeln "$(style_text "No venv detected, please run ./setup_dev_env.sh first" $RED $BOLD)"
  exit 1
fi

if [[ ! -f .vars.yml ]]; then
  touch .vars.yml
fi
source "$(pwd)/venv/bin/activate"
PATH="$(pwd)/venv/bin:$PATH" VIRTUAL_ENV="$(pwd)/venv" ansible-playbook "$@"
