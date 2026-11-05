{
  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 36969 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
