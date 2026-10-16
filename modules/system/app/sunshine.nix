{ pkgs, ... }:
let
  sunshine-cuda = pkgs.sunshine.override { cudaSupport = true; };
in {
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    package = sunshine-cuda;
  };

  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    # capabilities = "cap_sys_admin+ep";
    source = "${sunshine-cuda}/bin/sunshine";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
