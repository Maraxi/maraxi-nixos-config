# settings.conf and git

pcmanfm-qt rewrites `settings.conf` (window size etc.) every time it closes, and the size changes often in a tiling window manager. The file is a mutable link, so these writes land in this repo.

To avoid a dirty tree (noise in `git status` and the "git tree is dirty" warning during `home-manager switch`), local changes to the file are hidden from git with `skip-worktree`. The file is still tracked.

The flag only exists in the local clone. It is not committed. Set it again after a fresh clone and on every other machine (e.g. `~/nixconfig` on the NixOS desktop):

```
git update-index --skip-worktree user/dotfiles/pcmanfm-qt/settings.conf
```

## Pulling remote changes to the file

If `./update` or `git pull` fails with "Your local changes to the following files would be overwritten", this is the cause. Clear the flag, discard the local copy (this resets the window size, which is harmless), pull and set the flag again:

```
git update-index --no-skip-worktree user/dotfiles/pcmanfm-qt/settings.conf
git checkout -- user/dotfiles/pcmanfm-qt/settings.conf
git pull
git update-index --skip-worktree user/dotfiles/pcmanfm-qt/settings.conf
```

## Intentionally changing the file

Clear the flag, commit the change, set the flag again:

```
git update-index --no-skip-worktree user/dotfiles/pcmanfm-qt/settings.conf
# edit, git add, git commit
git update-index --skip-worktree user/dotfiles/pcmanfm-qt/settings.conf
```

Close pcmanfm-qt first, otherwise it overwrites the edit when it exits.

## Checking which files are flagged

```
git ls-files -v | rg '^S'
```
