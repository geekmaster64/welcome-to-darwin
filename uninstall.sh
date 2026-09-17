#!/bin/zsh
# Remove the zsh hook and installed files. Keeps ~/.calendar/calendar.user.

emulate -L zsh

zshrc=${HOME}/.zshrc
if [[ -f $zshrc ]]; then
  perl -i -0pe 's/\n?# >>> welcome-to-darwin >>>.*?<<< welcome-to-darwin <<<\n?//s' "$zshrc"
fi

rm -f "${HOME}/.local/bin/login-motd"
rm -rf "${HOME}/.local/share/login-motd" "${HOME}/.cache/login-motd"

print -- "Removed the banner and hook."
print -- "Left in place (your dates live here):"
print -- "  ~/.calendar/"
print -- "Delete that directory too if you want a full wipe:"
print -- "  rm -rf ~/.calendar"
