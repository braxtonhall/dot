# dot

My dotfiles, stored as a **bare git repo whose work-tree is `$HOME`**. There are no
symlinks and no install script — tracked paths *are* their real paths in the home
directory, so `.zshrc` in this repo is `~/.zshrc` on the machine.

The repo lives at `~/.cfg` and is driven through an alias:

```sh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

That alias is defined in the tracked `.zshrc`, so once you're set up it's always there.

## New machine setup

**0. Command line tools.** A fresh Mac has no git until you install them:

```sh
xcode-select --install
```

**1. Clone the repo bare into `~/.cfg`.**

```sh
git clone --bare git@github.com:braxtonhall/dot.git $HOME/.cfg
```

If SSH keys aren't on the machine yet, use
`https://github.com/braxtonhall/dot.git` instead and fix the remote later.

**2. Define the alias by hand, just this once.** It normally comes from `.zshrc`,
which you don't have yet:

```sh
alias dotfiles='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

**3. Check the files out over `$HOME`.**

```sh
dotfiles checkout
```

This will **fail if the machine already has a `.zshrc` or `.gitconfig`** — which a
Mac set up normally usually does. Git refuses rather than overwriting, and lists what
is in the way. Back those up and retry:

```sh
mkdir -p ~/.dotfiles-backup
dotfiles checkout 2>&1 | grep -E '^[[:space:]]+\.' | awk '{print $1}' | \
  xargs -I{} sh -c 'mkdir -p "$HOME/.dotfiles-backup/$(dirname {})" && mv "$HOME/{}" "$HOME/.dotfiles-backup/{}"'
dotfiles checkout
```

Then diff the backups against what landed — a machine that has been in use for a
while usually has local additions worth keeping.

**4. Stop `dotfiles status` listing your entire home directory.**

```sh
dotfiles config --local status.showUntrackedFiles no
```

Without this, every untracked file in `$HOME` shows up as untracked. This setting is
local to `~/.cfg` and is *not* carried by the clone, so it has to be set per machine.

**5. Apply the macOS system preferences.**

```sh
sh ~/.config/macos/defaults.sh
```

Then **log out and back in** — those settings are read at login. Safe to re-run at
any time; re-running also re-asserts anything an OS upgrade reset.

## Everyday use

```sh
dotfiles status
dotfiles add ~/.zshrc
dotfiles commit -m "..."
dotfiles push
```

Only ever `add` paths that are already tracked, or ones you consciously want tracked.

## Deliberately not in here

- **Secrets.** This repo is public. API tokens, credentials and anything
  machine-specific belong in a gitignored file sourced from `.zshrc`, or in Keychain —
  never in a tracked file.
- **Installed packages.** Homebrew formulae, nvm node versions and jenv JDKs are not
  captured yet; they still have to be reinstalled by hand.
