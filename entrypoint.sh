#!/usr/bin/env bash

set -e

STACK_PATH=$1
REVIEWER=$2

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

BRANCH=updating-$(date +%s)

git checkout -b "$BRANCH"

UPDATE_OUTPUT=$(stack update -c "$STACK_PATH")
echo "$UPDATE_OUTPUT"

echo ""
echo "============================="
echo "  Generating updated resources.."
echo "============================="
echo ""

GENERATE_OUTPUT=$(stack generate -c "$STACK_PATH")
echo "$GENERATE_OUTPUT"

echo ""
echo "============================="
echo "  Pushing changes to git.."
echo "============================="
echo ""

git config --global user.email "action@github.com"
git config --global user.name "Github Action"

git status

git add .
git commit -m "Updating Gimlet Stack"

git push origin "$BRANCH"

if [ -n "$REVIEWER" ]; then
  gh pr create \
    --title "Updating Gimlet Stack" \
    --body "$UPDATE_OUTPUT <br/><br/> $GENERATE_OUTPUT" \
    --reviewer "$REVIEWER"
else
  gh pr create \
    --title "Updating Gimlet Stack" \
    --body "$UPDATE_OUTPUT <br/><br/> $GENERATE_OUTPUT"
fi
