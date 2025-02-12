{setup, ...}: {
  home.sessionVariables = rec {
    EDITOR = "nvim";
    VISUAL = "nvim";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    RUFF_CACHE_DIR = XDG_CACHE_HOME + "/ruff_cache";

    PYTHON_HISTORY = XDG_DATA_HOME + "/python-history";
    IPYTHON_DIR = XDG_DATA_HOME + "/ipython";

    CARGO_HOME = XDG_DATA_HOME + "/cargo";
    RUSTUP_HOME = XDG_DATA_HOME + "/rustup";

    PARALLEL_HOME = XDG_CONFIG_HOME + "/parallel";

    MPLAYER_HOME = XDG_CONFIG_HOME + "/mplayer";

    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=" + XDG_CONFIG_HOME + "/java";

    DOCKER_CONFIG = XDG_CONFIG_HOME + "/docker";
    MACHINE_STORAGE_PATH = XDG_DATA_HOME + " /docker-machine";

    KUBECONFIG = XDG_CONFIG_HOME + "/kube";
    KUBECACHEDIR = XDG_CACHE_HOME + "/kube";
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
