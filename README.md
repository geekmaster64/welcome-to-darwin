# Welcome to Darwin

Old-school macOS login banner: `fortune`, BSD `calendar(1)`, a `cal` with today marked, plus local and public IP. The kind of thing that used to live in `.login` on a Mac OS X box when `/usr/share/calendar` still shipped.

Apple kept `calendar(1)` and deleted the data files. This puts them back, adds Macintosh / NeXT / Darwin dates, and prints a small hostinfo-style header.

No Homebrew. No Python. Stock Darwin tools (`cal`, `calendar`, `scutil`, `pmset`, `perl`, `curl`).

```
──────────────────────────────────────────────────────────────────────────────
  Welcome to Darwin.
  your Mac's ComputerName
  macOS 15.x  ·  Darwin 24.x.x  ·  Apple M-series  ·  32 GB
  Thursday, September 17, 2026  12:15
──────────────────────────────────────────────────────────────────────────────

  Byte my shiny metal disk.
      -- a PowerBook, probably

     September 2026       Today
  Su Mo Tu We Th Fr Sa    Sep 17     Steve Jobs resigns from Apple, 1985
         1  2  3  4  5    Sep 17     Constitution Day / Citizenship Day
   6  7  8  9 10 11 12    Coming up
  13 14 15 16[17]18 19    Sep 19     Talk Like a Pirate Day
  20 21 22 23 24 25 26    Sep 20     Harlan Herrick runs first FORTRAN program, …
  27 28 29 30             Sep 22     Autumnal Equinox
                          Sep 26     Full Moon (11:43:20)

──────────────────────────────────────────────────────────────────────────────
  net    en0  10.0.0.12                   public 203.0.113.4
  power  100% battery  14:32 left         disk   80Gi of 926Gi (9%)
  up     2 days, 2:44                     load   1.65 1.71 2.10
  last   Tue Sep 15 20:10
──────────────────────────────────────────────────────────────────────────────
```

## Install on this Mac

zsh is the macOS default. Clone (or copy) the repo and run the installer:

```sh
git clone https://github.com/geekmaster64/welcome-to-darwin.git
cd welcome-to-darwin
./install.sh
```

Open a new Terminal tab. You should see the banner. Run it anytime with `login-motd`.

The installer:

- copies the banner to `~/.local/bin/login-motd`
- copies fortunes to `~/.local/share/login-motd/fortunes`
- restores calendar files to `~/.calendar/` (will not overwrite an existing `calendar.user`)
- appends an idempotent hook to `~/.zshrc` and puts `~/.local/bin` on your `PATH`

## Other Macs

```sh
git clone https://github.com/geekmaster64/welcome-to-darwin.git
cd welcome-to-darwin && ./install.sh
```

USB stick or AirDrop also works: copy the folder, then `./install.sh` on that machine.

## GitHub

Public repo: [geekmaster64/welcome-to-darwin](https://github.com/geekmaster64/welcome-to-darwin)

The `calendar.user` in this tree is only the commented template — put real dates on the machine, not in git. The sample banner uses fake IPs.

## Customize

| Want | Do |
|---|---|
| Personal dates | `~/.calendar/calendar.user` — `DATE`, then a **tab**, then text. See the comments in that file. |
| More quotes | `~/.local/share/login-motd/fortunes` (`%` separates entries; `-- author` on the last line) |
| Mute on one machine | `touch ~/.hushlogin` (classic) or `MOTD=0` |
| Skip one session | `LOGIN_MOTD_DONE=1` already set by the hook; nested shells will not reprint |
| Uninstall | `./uninstall.sh` (keeps `~/.calendar/calendar.user`) |

`calendar(1)` format is the 4.4BSD one: `09/17	Constitution Day`, `02/MonThird	Presidents' Day`, `NewMoon	New Moon`. `calendar -A 7` is what the banner runs.

## Requirements

- macOS (tested on Darwin 27 / macOS 27; should be fine back through any Mac that still has `/usr/bin/calendar`)
- `zsh` (default since Catalina)
- Network optional: public IP is fetched with a 1.2s timeout and cached for 30 minutes; offline it says `offline` or uses the last cache

## License

MIT for the banner, installer, Mac calendar, and fortunes. `calendar.usholiday` and `calendar.computer` are FreeBSD calendar-data — see `NOTICE`.
