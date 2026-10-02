{ inputs, pkgs, ... }: {
  imports = [
    inputs.nur.repos.af-nur.homeModules.linuxqq-clipsync
  ];

  services.linuxqq-clipsync.enable = true;
}
