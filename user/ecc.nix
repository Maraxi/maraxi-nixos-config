{ config, ... }: {
  home.sessionVariables = {
    UV_DEFAULT_INDEX = "https://artifactory.dbgcloud.io/artifactory/api/pypi/cio-ecc-itsdesign-pypi-dev/simple";
    UV_PYTHON = "3.13";
    UV_PYTHON_PREFERENCE = "only-managed";
    UV_SYSTEM_CERTS = "true";
    TNS_ADMIN = "$HOME/.config/tns_ora";
  };

  programs.bash.shellAliases = {
    tox = "TERM=xterm-256color tox";
  };

  home.sessionPath = [ "$HOME/p1-bin" ];
  home.file."p1-bin".source = config.lib.meta.mkMutableSymlink ../hosts/p1;

  xdg.mimeApps =
    let
      association = {
        "application/x-remmina" = "xfreerdp-wrapper.desktop";
        "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";
      };
    in
    {
      defaultApplications = association;
      associations.added = association;
    };
}
