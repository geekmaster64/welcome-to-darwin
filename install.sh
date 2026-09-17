#!/bin/zsh
# Install welcome-to-darwin onto this Mac: banner, calendar files, zsh hook.

emulate -L zsh
setopt err_exit

if [[ $(uname -s) != Darwin ]]; then
  print -u2 -- "welcome-to-darwin is for macOS (needs calendar, scutil, pmset)."
  exit 1
fi

here=${0:A:h}
bin_dst=${HOME}/.local/bin
share_dst=${HOME}/.local/share/login-motd
cal_dst=${HOME}/.calendar
zshrc=${HOME}/.zshrc

mkdir -p "$bin_dst" "$share_dst" "$cal_dst" "${HOME}/.cache/login-motd"

install -m 755 "$here/bin/login-motd" "$bin_dst/login-motd"
install -m 644 "$here/share/fortunes" "$share_dst/fortunes"

for f in calendar calendar.mac calendar.usholiday calendar.computer; do
  install -m 644 "$here/calendar/$f" "$cal_dst/$f"
done

if [[ -e $cal_dst/calendar.user ]]; then
  print -- "keeping existing ~/.calendar/calendar.user"
else
  install -m 644 "$here/calendar/calendar.user" "$cal_dst/calendar.user"
fi

touch "$zshrc"
perl - "$zshrc" <<'PERL'
use strict;
use warnings;

my $path = $ARGV[0];
open my $fh, '<', $path or die "$path: $!";
my $src = do { local $/; <$fh> };
close $fh;

$src =~ s/\n?# >>> welcome-to-darwin >>>.*?<<< welcome-to-darwin <<<\n?//s;
$src =~ s/\n?# Darwin login banner:.*?^fi\n?//sm;

my $block = <<'EOF';

# >>> welcome-to-darwin >>>
# Mute with:  touch ~/.hushlogin   or   MOTD=0
# Personal dates: ~/.calendar/calendar.user  (DATE<TAB>text)
case ":$PATH:" in
  *:"$HOME/.local/bin":*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
if [[ -o interactive && -t 1 && -z ${LOGIN_MOTD_DONE:-} && ${TERM:-} != dumb ]]; then
  export LOGIN_MOTD_DONE=1
  [[ -x $HOME/.local/bin/login-motd ]] && $HOME/.local/bin/login-motd
fi
# <<< welcome-to-darwin <<<
EOF

$src =~ s/\s+\z/\n/;
open my $out, '>', $path or die "$path: $!";
print $out $src, $block;
close $out;
PERL

print -- ""
print -- "Installed."
print -- "  banner    $bin_dst/login-motd"
print -- "  fortunes  $share_dst/fortunes"
print -- "  calendar  $cal_dst/"
print -- "  hook      $zshrc"
print -- ""
print -- "Open a new Terminal tab, or run:  login-motd"
print -- "Add your dates in ~/.calendar/calendar.user (TAB after the date)."
print -- ""

if [[ -t 1 ]]; then
  LOGIN_MOTD_FORCE=1 "$bin_dst/login-motd" || true
fi
