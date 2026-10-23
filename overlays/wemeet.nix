# Native Wayland screen sharing for wemeet (NixOS/nixpkgs#574875, head 06e6cac6e191).
# Drop this overlay once the PR reaches nixos-unstable.
final: prev:
let
  patched = prev.applyPatches {
    name = "wemeet-native-screenshare";
    src = "${prev.path}/pkgs/by-name/we/wemeet";
    patches = [ ./wemeet/native-screenshare.patch ];
  };
in
{
  wemeet = prev.callPackage "${patched}/package.nix" { };
}
