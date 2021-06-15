#!/usr/bin/env bash

set -e

STACK_PATH=$1

echo "Checking for updates.."

CHECK_OUTPUT=$(stack update --check -c "$STACK_PATH")

echo "$CHECK_OUTPUT"

if [[ "$CHECK_OUTPUT" == *"Already up to date"* ]]; then
  exit 0
fi

echo "Updating.."

stack update -c "$STACK_PATH"
