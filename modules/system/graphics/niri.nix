{ inputs, pkgs, ... }:
let
  niriPackage = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
in
{
  programs.niri.package = niriPackage.overrideAttrs (prev: {
    checkFlags = (prev.checkFlags or [ ]) ++ [
      "--skip=closing_window_stays_in_place_during_left_refill"
      "--skip=closing_windows_stay_in_place_during_rightmost_refill"
    ];
  });

  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    xwayland-satellite
    swaylock
    swayidle
    brightnessctl
    playerctl
    wireplumber
  ];

  xdg.portal = {
    config = {
      niri = {
        "org.freedesktop.impl.portal.ScreenCast" = [ "niri" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "niri" ];
        default = [
          "gnome"
          "gtk"
        ];
      };
    };
  };
}
