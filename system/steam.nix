{ pkgs, ... }: {
  programs.steam = {
    enable = true;
    # The module also installs steam.run (steam-run: a second FHS env with its own 32/64-bit mesa, llvm and
    # python). It is unused and not needed by Steam itself. The module calls `.override` on the package, which
    # regenerates `run`, so the replacement has to be applied on the overridden result.
    package =
      let
        noRun =
          steam:
          steam
          // {
            run = pkgs.emptyDirectory;
            override = args: noRun (steam.override args);
          };
      in
      noRun pkgs.steam;
    # extest.enable = true; # Using steam input on wayland
    # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
}
