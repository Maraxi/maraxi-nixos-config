# `/etc/nix/nix.conf`

    build-users-group = nixbld
    experimental-features = nix-command flakes
    use-xdg-base-directories = true

# `.config/nix/nix.conf`

## Authentication and rate limits

store result from `$ gh auth token` as

    access-tokens = github.com=gho_**

## Zscaler connection blocking / rate limiting

    # Restrict parallel HTTP requests to prevent Zscaler burst resets
    max-jobs = 4

    # Increase timeout for transient Zscaler drops
    connect-timeout = 60
