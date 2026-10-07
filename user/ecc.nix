{ config, ... }: {
  home.sessionVariables = rec {
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    SSL_CERT_DIR = "/etc/ssl/certs/";
    NODE_EXTRA_CA_CERTS = SSL_CERT_FILE;
    REQUESTS_CA_BUNDLE = SSL_CERT_FILE;
    CURL_CA_BUNDLE = SSL_CERT_FILE;
    PIP_CERT = SSL_CERT_FILE;
    UV_DEFAULT_INDEX = "https://artifactory.dbgcloud.io/artifactory/api/pypi/cio-ecc-itsdesign-pypi-dev/simple";
    UV_PYTHON = "3.13";
    UV_PYTHON_PREFERENCE = "only-managed";
    UV_SYSTEM_CERTS = "true";
    TNS_ADMIN = "$HOME/.config/tns_ora";
  };

  programs.bash.shellAliases = {
    tox = "TERM=xterm-256color tox";
    # opencode-r = "$HOME/repositories/opencode_containerized/opencode.sh";
    # opencode = "$HOME/repositories/opencode_containerized/opencode.sh -w --rw";
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
