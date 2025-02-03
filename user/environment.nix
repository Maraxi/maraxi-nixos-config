{setup, ...}: {
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
    browser =
      if setup.isNixOS
      then "firefox.desktop"
      else "chromium-browser.desktop";
    association = {
      "application/pdf" = ["org.gnome.Evince.desktop" browser];
      "default-url-scheme-handler" = browser;
      "default-web-browser" = browser;
      "image/png" = "feh.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "text/html" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/mailto" = "thunderbird.desktop";
      "x-scheme-handler/unknown" = browser;
    };
  in {
    enable = true;
    defaultApplications = association;
    associations.added = association;
  };
}
