{pkgs, ...}: {
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [brlaser];
  };
  # Color management service for cups
  services.colord.enable = true;
  hardware.printers.ensurePrinters = [
    {
      name = "Brother_MFC_L2710DW_series";
      deviceUri = "dnssd://Brother%20MFC-L2710DW%20series._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-3c2af45641b1";
      model = "drv:///brlaser.drv/brl2710w.ppd";
      ppdOptions = {
        PageSize = "A4";
        Duplex = "DuplexNoTumble";
      };
    }
  ];

  # Enable sane for scanner
  hardware.sane.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.etc."papersize".text = "a4";
}
