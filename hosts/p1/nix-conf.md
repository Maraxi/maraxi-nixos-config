# `/etc/nix/nix.conf`

    build-users-group = nixbld
    experimental-features = nix-command flakes
    use-xdg-base-directories = true

# `.config/nix/nix.conf`

## Authentication and rate limits

store result from `$ gh auth token` as

    access-tokens = github.com=gho_**
