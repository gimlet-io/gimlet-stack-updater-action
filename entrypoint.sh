#!/usr/bin/env bash

set -e

STACK_PATH=$1

echo "============================="
echo "  Checking for updates.."
echo "============================="
echo ""

CHECK_OUTPUT=$(stack update --check -c "$STACK_PATH" 2>&1)

echo "$CHECK_OUTPUT"
UP_TO_DATE_STR="Already up to date"

if [[ "$CHECK_OUTPUT" =~ .*"$UP_TO_DATE_STR".* ]]; then
  echo ""
  exit 0
fi

echo ""
echo "============================="
echo "  Updating.."
echo "============================="
echo ""

stack update -c "$STACK_PATH"
