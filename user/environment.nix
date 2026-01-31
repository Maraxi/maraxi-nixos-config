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
    IPYTHONDIR = XDG_DATA_HOME + "/ipython";

    CARGO_HOME = XDG_DATA_HOME + "/cargo";
    RUSTUP_HOME = XDG_DATA_HOME + "/rustup";

    PARALLEL_HOME = XDG_CONFIG_HOME + "/parallel";

    MPLAYER_HOME = XDG_CONFIG_HOME + "/mplayer";

    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=" + XDG_CONFIG_HOME + "/java";

    DOCKER_CONFIG = XDG_CONFIG_HOME + "/docker";
    MACHINE_STORAGE_PATH = XDG_DATA_HOME + " /docker-machine";

    KUBECONFIG = XDG_CONFIG_HOME + "/kube";
    KUBECACHEDIR = XDG_CACHE_HOME + "/kube";

    NPM_CONFIG_USERCONFIG = XDG_CONFIG_HOME + "/npm/npmrc";

    CUDA_CACHE_PATH = XDG_CACHE_HOME + "/nv";
  };
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  xdg.mimeApps = let
    browser =
      if setup.isNixOS
      then "firefox.desktop"
      else "google-chrome.desktop";
    image_viewer = ["org.gnome.gThumb.desktop" "feh.desktop"];
    video_viewer = ["org.gnome.gThumb.desktop" "vlc.desktop"];
    association = {
      "application/json" = "nvim.desktop";
      "application/pdf" = ["org.gnome.Evince.desktop" browser];
      "application/x-gnome-saved-search" = "nemo.desktop";
      "default-url-scheme-handler" = browser;
      "default-web-browser" = browser;
      "image/gif" = video_viewer;
      "image/jpeg" = image_viewer;
      "image/png" = image_viewer;
      "inode/directory" = "nemo.desktop";
      "message/rfc822" = "thunderbird.desktop";
      "text/html" = browser;
      "text/plain" = "nvim.desktop";
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/mailto" =
        if setup.isNixOS
        then "thunderbird.desktop"
        else browser;
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/unknown" = browser;
    };
  in {
    enable = true;
    defaultApplications = association;
    associations.added = association;
  };
}
