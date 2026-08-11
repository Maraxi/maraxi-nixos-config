{ pkgs, ... }: {
  # xdg-portals for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
    config = {
      common.default = [ "wlr" ];
    };
  };
}
