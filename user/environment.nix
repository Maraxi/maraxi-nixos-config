{ mutableLink, ... }: {
  home.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    RUFF_CACHE_DIR = XDG_CACHE_HOME + "/ruff_cache";
    # UV_EXCLUDE_NEWER = "3 days";

    PYTHON_HISTORY = XDG_STATE_HOME + "/python-history";
    IPYTHONDIR = XDG_DATA_HOME + "/ipython";

    CARGO_HOME = XDG_DATA_HOME + "/cargo";
    RUSTUP_HOME = XDG_DATA_HOME + "/rustup";

    GOPATH = XDG_DATA_HOME + "/go";
    GOMODCACHE = XDG_CACHE_HOME + "/go/mod";

    PARALLEL_HOME = XDG_CONFIG_HOME + "/parallel";

    MPLAYER_HOME = XDG_CONFIG_HOME + "/mplayer";

    _JAVA_OPTIONS =
      "-Djava.util.prefs.userRoot="
      + XDG_CONFIG_HOME
      + "/java "
      + "-Djavafx.cachedir="
      + XDG_CACHE_HOME
      + "/openjfx";

    DOCKER_CONFIG = XDG_CONFIG_HOME + "/docker";
    MACHINE_STORAGE_PATH = XDG_DATA_HOME + "/docker-machine";

    KUBECONFIG = XDG_CONFIG_HOME + "/kube";
    KUBECACHEDIR = XDG_CACHE_HOME + "/kube";

    NPM_CONFIG_USERCONFIG = XDG_CONFIG_HOME + "/npm/npmrc";

    CUDA_CACHE_PATH = XDG_CACHE_HOME + "/nv";
  };
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];
  home.file.".local/bin" = mutableLink dotfiles/bin;
}
