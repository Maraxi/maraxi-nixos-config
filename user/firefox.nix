{config, ...}: {
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    # package
    # enableGnomeExtensions
    # languagePacks
    # policies
    # nativeMessagingHosts
    # profiles = {
    #   default = {
    #     id = 0;
    #     name = "Default";
    #     isDefault = true;
    #   };
    # };
  };
}
