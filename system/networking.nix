{ hostName, ... }: {
  networking = {
    inherit hostName;

    networkmanager.enable = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall.enable = true;
    firewall.allowedTCPPorts = [ 11436 ];
    # firewall.allowedUDPPorts = [ ... ];

    # nftables instead of iptables for firewall
    nftables.enable = true;

    hosts = {
      "104.26.10.35" = [ "static1.e621.net" ];
    };
  };
}
