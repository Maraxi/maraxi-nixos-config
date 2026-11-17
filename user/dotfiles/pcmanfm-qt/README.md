# pcmanfm-qt

`settings.conf` is rewritten by pcmanfm-qt itself, so local changes are hidden from git with `skip-worktree`:

```sh
git update-index --skip-worktree pcmanfm-qt/settings.conf     # hide local changes
git update-index --no-skip-worktree pcmanfm-qt/settings.conf  # undo
```

- The flag is local to this clone (stored in `.git/index`).
- If an upstream change touches the file, `git pull` will refuse. Clear the flag, stash or copy the file aside, pull, restore, then set the flag again.
- List flagged files with `git ls-files -v | rg '^S '`.
