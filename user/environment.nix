{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    PYTHON_HISTORY = "$HOME/.local/share/python-history";
    IPYTHON_DIR = "$HOME/.local/share/ipython";
  };
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  xdg.mimeApps = let
    association = {
      "application/pdf" = ["org.gnome.Evince.desktop" "firefox.desktop"];
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "image/png" = "feh.desktop";
    };
  in {
    enable = true;
    defaultApplications = association;
    associations.added = association;
  };
}
