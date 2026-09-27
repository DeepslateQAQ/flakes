{ pkgs, ... }: {
  users.users.deepslate = {
    isNormalUser = true;
    description = "深板岩酱 Deepslate";
    uid = 1000;
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "libvirtd"
      "i2c"
      "docker"
      "input"
      "greeter"
    ];
    shell = pkgs.zsh;
  };
}
