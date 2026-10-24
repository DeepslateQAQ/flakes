{ lib, pkgs, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # The upstream module only grants CAP_SYS_ADMIN as permitted (+p), so
  # Sunshine cannot raise it and logs "Failed to gain CAP_SYS_ADMIN" on
  # Wayland. Grant it as effective+permitted like a setcap wrapper.
  security.wrappers.sunshine.capabilities = lib.mkForce "cap_sys_admin+ep";

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
