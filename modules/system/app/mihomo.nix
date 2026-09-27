{ pkgs, ... }: {
  services.mihomo = {
    enable = true;
    tunMode = true;
    processesInfo = true;
    configFile = "/etc/mihomo/config.yaml";
    webui = pkgs.zashboard;
  };
  networking.firewall.trustedInterfaces = [
    "ds-mihomo-tun"
    "Mihomo"
    "lo"
  ];
  networking.firewall.enable = false;
}
