{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.deepslate = {
    isNormalUser = true;
    description = "深板岩酱 Deepslate";
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals (config.users.groups ? input) [ "input" ]
    ++ lib.optionals (config.users.groups ? greeter) [ "greeter" ]
    ++ lib.optionals (config.users.groups ? kvm) [ "kvm" ]
    ++ lib.optionals (config.users.groups ? libvirtd) [ "libvirtd" ]
    ++ lib.optionals (config.users.groups ? docker) [ "docker" ]
    ++ lib.optionals (config.users.groups ? i2c) [ "i2c" ];
    shell = pkgs.zsh;
  };
}
