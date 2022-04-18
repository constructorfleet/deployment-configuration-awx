#!/bin/bash

source .helper_scripts/print_utils.sh

write "$(style_text "Enter Variable Name: " $BLUE $BOLD)"
read var_name
write "$(style_text "Enter Variable Value: " $BLUE $BOLD)"
read -s var_value

source "$(pwd)/venv/bin/activate"
PATH="$(pwd)/venv/bin:$PATH" VIRTUAL_ENV="$(pwd)/venv" ansible-vault encrypt_string -n $var_name $var_value | tail -r | tail -n +1 | tail -r
