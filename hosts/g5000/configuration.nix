{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../profiles/base.nix
    ../../modules/system/hardware/ddcutil.nix
    ../../modules/system/hardware/wacom.nix
    ../../modules/system/graphics/gnome.nix
    ../../modules/system/graphics/plymouth.nix
    ../../modules/system/app/mihomo.nix
    ../../modules/system/app/easytier.nix
    ../../modules/system/app/mission-center.nix
    ../../modules/system/virtualisation/kvm.nix
    ../../modules/system/app/steam.nix
    ../../modules/system/app/syncthing.nix
    ../../modules/system/app/gpu-screen-recorder.nix
    ../../modules/system/graphics/niri.nix
    ../../modules/system/graphics/dms.nix
    ../../modules/system/ime/fcitx.nix
    ../../modules/system/app/obs-studio.nix
    # ../../modules/system/app/ollama.nix
    ../../modules/system/app/sunshine.nix
    ../../modules/system/app/nh.nix
    ../../modules/system/hardware/modem.nix
    ../../modules/system/app/nix-keep-drv.nix
    # ../../modules/system/hardware/fprintd.nix
    ../../modules/system/app/tailscale.nix
    ../../modules/system/app/ydotool.nix
  ];

  hardware.nvidia.prime.offload = {
    enable = true;
    enableOffloadCmd = true;
  };
  hardware.nvidia.modesetting.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  services.syncthing.user = "deepslate";

  systemd.tmpfiles.rules = [
    "d /var/lib/syncthing 0700 deepslate syncthing -"
  ];

  services.easytier.instances.ctmc.extraArgs = [
    "--hostname"
    "g5000.slate"
  ];

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
  # system.boot.loader.kernelFile = "vmlinuz";

  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];

  environment.etc."flatpak/overrides/global".text = ''
    [Environment]
    GDK_BACKEND=wayland,x11
    QT_QPA_PLATFORM=wayland;xcb
    SDL_VIDEODRIVER=wayland
    ELECTRON_OZONE_PLATFORM_HINT=wayland
  '';

  networking.hostName = "lithosphere";
  system.stateVersion = "26.05";
}
