{...}: {
  programs.chromium =
    if setup.isNixOS
    then {}
    else {
      enable = true;
      commandLineArgs = [
        "--proxy-pac-url=http://webproxy.deutsche-boerse.de:8080"
      ];
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      ];
    };
}
