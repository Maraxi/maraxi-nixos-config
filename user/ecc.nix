{lib, ...}: {
  home.sessionVariables = {
    UV_DEFAULT_INDEX = "https://artifactory.dbgcloud.io/artifactory/api/pypi/cio-ecc-itsdesign-pypi-dev/simple";
    UV_PYTHON = "3.13";
    UV_PYTHON_PREFERENCE = "only-managed";
    UV_SYSTEM_CERTS = "true";
    TNS_ADMIN = "$HOME/.config/tns_ora";
  };
  home.shellAliases = {
    cal = "ncal -bw -B3 -A2";
  };

  xdg.mimeApps = let
    association = {
      "application/x-remmina" = "xfreerdp-wrapper.desktop";
      "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";
    };
  in {
    defaultApplications = association;
    associations.added = association;
  };
}
