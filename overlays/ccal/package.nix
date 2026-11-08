{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  ghostscript_headless, # 提供 ccalpdf 需要的 ps2pdf
}:

# nixpkgs 已删除 ccal（官方发布地址 https://ccal.chinesebay.com 失效），
# 这里沿用原来的构建方式，只把源码换成作者授权的镜像仓库
# （github:liangqi/ccal，内容即 2.5.3 源码）。
stdenv.mkDerivation (finalAttrs: {
  pname = "ccal";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "liangqi";
    repo = "ccal";
    rev = "327614b181e77d9f36580a9dc0ece1fff7e2eb00";
    hash = "sha256-KlbE/4jw4Z9pewD8idSvT5XFB4gGGF8RNX4oCZzk9mk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "CXX:=$(CXX)"
    "BINDIR=$(out)/bin"
    "MANDIR=$(out)/share/man"
  ];

  installTargets = [
    "install"
    "install-man"
  ];

  # ccalpdf 依赖 PATH 里的 ps2pdf
  postFixup = ''
    wrapProgram $out/bin/ccalpdf \
      --prefix PATH : ${lib.makeBinPath [ ghostscript_headless ]}:$out/bin
  '';

  meta = {
    homepage = "https://ccal.chinesebay.com/ccal.htm";
    description = "Command line Chinese calendar viewer, similar to cal";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sharzy ];
    platforms = lib.platforms.all;
    mainProgram = "ccal";
  };
})
