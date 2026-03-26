{lib, ...}: {
  home.sessionVariables = {
    UV_PYTHON = "3.11";
    UV_DEFAULT_INDEX = "https://artifactory.dbgcloud.io/artifactory/api/pypi/cio-ecc-itsdesign-pypi-dev/simple";
    UV_PYTHON_PREFERENCE = "only-managed";
    UV_NATIVE_TLS = "true";
    no_proxy = lib.strings.concatStringsSep "," ["$no_proxy" ".dbgcloud.io" ".testing" ".eex.energy" ".deutsche-boerse.de" ".oa.pnrad.net"];
  };
  home.shellAliases = {
    cal = "ncal -bw -B3 -A2";
  };

  xdg.mimeApps = let
    association = {
      "application/x-remmina" = "xfreerdp-wrapper.desktop";
    };
  in {
    defaultApplications = association;
    associations.added = association;
  };
}
