{pkgs-be02d8, ...}: {
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--proxy-pac-url=http://webproxy.deutsche-boerse.de:8080"
      "--high-dpi-support=1"
      "--force-device-scale-factor=1"
    ];
    package = pkgs-be02d8.ungoogled-chromium;
    extensions = [
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "ohcpnigalekghcmgcdcenkpelffpdolg";} # colorpick-eyedropper
      # {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark-reader
      {id = "poahndpaaanbpbeafbkploiobpiiieko";} # display-anchors
      {id = "oboonakemofpalcgghocfoadofidjkkk";} # keepassxc-browser
      {id = "clngdbkpkpeebahjckkjfobafhncgmne";} # stylus
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
      {id = "jinjaccalgkegednnccohejagnlnfdag";} # violentmonkey
    ];
  };
}
