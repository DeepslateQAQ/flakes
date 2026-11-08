# nixpkgs 已移除 ccal；官方源码站失效，改用作者授权的镜像仓库自行打包，
# 见 overlays/ccal/package.nix。上游恢复后可删除本 overlay。
final: prev: {
  ccal = prev.callPackage ./ccal/package.nix { };
}
