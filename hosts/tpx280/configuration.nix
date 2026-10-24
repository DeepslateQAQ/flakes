{
  config,
  pkgs,
  ...
}:
let
  g5000SshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILAvceyap4WV8mciJ386n3hgN7bJoh9LyQMGpFAdGGPj 31850@LXTLAPTOP_2";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/base.nix
    ../../modules/system/graphics/gnome.nix
    ../../modules/system/graphics/plymouth.nix
    ../../modules/system/graphics/niri.nix
    ../../modules/system/graphics/dms.nix
    ../../modules/system/ime/fcitx.nix
    ../../modules/system/app/mihomo.nix
    ../../modules/system/app/sunshine.nix
    ../../modules/system/app/tailscale.nix
    ../../modules/system/app/easytier.nix
    ../../modules/system/app/ydotool.nix
    ../../modules/system/app/mission-center.nix
    ../../modules/system/app/nh.nix
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable = true;
  hardware.intelgpu = {
    # UHD 620（Gen9.5）的 VAAPI 由 iHD 提供；Sunshine 只用 VAAPI。
    # mediaRuntime 只影响 QSV/oneVPL，intel-media-sdk 已 EOL 且被 nixpkgs 标记 insecure。
    vaapiDriver = "intel-media-driver";
    computeRuntime = "legacy";
    mediaRuntime = "vpl-gpu-rt";
  };

  services.fwupd.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.libinput.enable = true;

  services.easytier.instances.ctmc.extraArgs = [
    "--hostname"
    "tpx280.slate"
  ];

  systemd.services.mihomo.serviceConfig = {
    AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 5;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.deepslate.openssh.authorizedKeys.keys = [ g5000SshKey ];
  users.users.root.openssh.authorizedKeys.keys = [ g5000SshKey ];

  networking.hostName = "tpx280";
  system.stateVersion = "26.05";
}
