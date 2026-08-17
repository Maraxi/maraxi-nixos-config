{ pkgs, ... }: {
  home.packages = [ pkgs.nextcloud-client ];

  systemd.user =
    let
      nextcloud = "nextcloud-autosync";
    in
    {
      startServices = "sd-switch";

      services.${nextcloud} = {
        Unit = {
          Description = "Auto sync Nextcloud";
          # After = ["network-online.target" "suspend.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.nextcloud-client}/bin/nextcloudcmd -h -n --path /Stefan /home/stefan/Documents/nextcloud raspberrypi/nextcloud";
          TimeoutStopSec = "180";
          KillMode = "process";
          KillSignal = "SIGINT";
        };
        # Install.WantedBy = ["multi-user.target" "suspend.target"];
      };
      timers.${nextcloud} = {
        Unit.Description = "Automatic sync files with Nextcloud when booted up after 5 minutes then rerun every 60 minutes";
        Timer.OnBootSec = "5min";
        Timer.OnUnitActiveSec = "60min";
        Install.WantedBy = [ "timers.target" ];
      };
      paths.${nextcloud} = {
        Path.PathModified = "/home/stefan/Documents/nextcloud/KeePass";
        Install.WantedBy = [ "paths.target" ];
      };
    };
}
