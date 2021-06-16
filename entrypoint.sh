#!/usr/bin/env bash

set -e

STACK_PATH=$1
REVIEWER=$2

echo "============================="
echo "  Checking for updates.."
echo "============================="
echo ""

CHECK_OUTPUT=$(stack update --check -o json -c "$STACK_PATH" 2>&1)

echo "$CHECK_OUTPUT"
UP_TO_DATE_STR="Already up to date"

if [[ "$CHECK_OUTPUT" =~ .*"$UP_TO_DATE_STR".* ]]; then
  echo ""
  exit 0
fi

CURRENT_VERSION=$(echo $CHECK_OUTPUT | jq -r '.currentVersion')
LATEST_VERSION=$(echo $CHECK_OUTPUT | jq -r '.latestVersion')

echo ""
echo "============================="
echo "Updating from $CURRENT_VERSION to $LATEST_VERSION.."
echo "============================="
echo ""

BRANCH="updating-$CURRENT_VERSION-to-$LATEST_VERSION"

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

GIT_STATUS=$(git status)

if [[ "$GIT_STATUS" =~ .*"nothing to commit".* ]]; then
  echo "Already updated. Exiting."
  exit 0
fi

git add .
git commit -m "Updating Gimlet Stack"

git push origin "$BRANCH"

BODY="
$UPDATE_OUTPUT

---

$GENERATE_OUTPUT
"

echo "$BODY"

if [ -n "$REVIEWER" ]; then
  gh pr create \
    --title "Updating stack from $CURRENT_VERSION to $LATEST_VERSION.." \
    --body "$BODY" \
    --reviewer "$REVIEWER"
else
  gh pr create \
    --title "Updating stack from $CURRENT_VERSION to $LATEST_VERSION.." \
    --body "$BODY"
fi
