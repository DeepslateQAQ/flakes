{ pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    python313
    inputs.fix-python.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  programs.uv.enable = true;
}
