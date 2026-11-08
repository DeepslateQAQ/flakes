{ config, pkgs, ... }: {
  imports = [
    ./network/bonjour.nix
  ];

  boot.loader.systemd-boot.enable = true;

  networking.networkmanager.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = (import ../../flake.nix).nixConfig.substituters;
    extra-substituters = (import ../../flake.nix).nixConfig.extra-substituters;
    trusted-public-keys = (import ../../flake.nix).nixConfig.trusted-public-keys;
    extra-trusted-public-keys = (import ../../flake.nix).nixConfig.extra-trusted-public-keys;
  };
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
    "olm-3.2.16"
    "pnpm-10.29.2"
    "electron-40.10.5"
    "dingtalk-8.2.8.260818002"
  ];

  services.openssh.enable = true;
  services.flatpak.enable = true;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  services.xserver.excludePackages = [ pkgs.xterm ];
  programs.zsh.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.atd.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      zlib
      zstd
      stdenv.cc.cc
      stdenv.cc.cc.lib
      gcc-unwrapped.lib
      curl
      openssl
      expat
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd
      libxcomposite
      libxtst
      libxrandr
      libxext
      libx11
      libxfixes
      libGL
      libva
      pipewire
      libxcb
      libxdamage
      libxshmfence
      libxxf86vm
      libelf
      glib
      gtk2
      networkmanager
      vulkan-loader
      libgbm
      libdrm
      libxcrypt
      coreutils
      pciutils
      zenity
      libxinerama
      libxcursor
      libxrender
      libxscrnsaver
      libxi
      libsm
      libice
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      ffmpeg
      libudev0-shim
      gtk3
      icu
      libnotify
      gsettings-desktop-schemas
      libxt
      libxmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew_1_10
      libidn
      tbb
      flac
      freeglut
      libjpeg
      libpng
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_mixer
      SDL_ttf
      SDL2_ttf
      SDL2_mixer
      libappindicator-gtk3
      libdbusmenu-gtk3
      libindicator-gtk3
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      libxft
      libvdpau
      dbus
      freetype
      fontconfig
      fuse
      e2fsprogs
      mesa
      libxkbcommon
      at-spi2-core
      at-spi2-atk
      alsa-lib
      libpulseaudio
      libsecret
      systemd
      pango
      cairo
      gdk-pixbuf
      libglvnd

      # WebView 运行时：WebKitGTK（Tauri / pywebview / wails / webkit 壳的 AppImage）。
      # 旧的 4.0 与 libsoup2 已被 nixpkgs 删除，只剩这两套 ABI。
      webkitgtk_4_1 # libwebkit2gtk-4.1.so.0 / libjavascriptcoregtk-4.1.so.0（GTK3）
      webkitgtk_6_0 # libwebkitgtk-6.0.so.4 / libjavascriptcoregtk-6.0.so.1（GTK4）
      libsoup_3
      gtk4
      libadwaita
      graphene # GTK4 必然带它，webkitgtk-6.0 的 pkg-config 也一样
      harfbuzz # webkit2gtk pkg-config 会直接链到它
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base

      # FHS 应用常见缺口（网络认证、Wayland、旧 GL/X11、托盘、xcb-util 系列）
      krb5
      libtirpc
      libbsd
      keyutils
      wayland
      libdecor
      libgudev
      libGLU
      libXpm
      libayatana-appindicator
      xcbutil
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      xcbutilwm
      xcbutilcursor
      xcbutilxrm
    ];
  };

  # GIO 的运行时模块（TLS 后端/代理）不在 nix-ld 的 LD 路径上，但
  # programs.dconf / services.gvfs / services.gnome.glib-networking 已经把它们
  # 写进 GIO_EXTRA_MODULES，FHS 应用直接继承 session 环境即可，故此处不重复定义。

  # 自带 OpenSSL 的 FHS 应用（AppImage、自解压安装包、别人的 JDK/Node 之类）
  # 常按发行版的 openssldir 找信任库：Debian 系编出来是 /usr/lib/ssl/{cert.pem,certs}，
  # NixOS 上这两个路径都不存在，结果不是「某张证书验不过」而是「一个根都加载不到」，
  # 表现为任何 TLS 连接都不可信。显式把系统 bundle 交给它们即可。
  # 用 caBundle 的 /nix/store 路径而不是 /etc/ssl/certs/*：后者是指向 /etc/static 的符号
  # 链接，只 bind 了 /etc/ssl/certs 的沙箱（WebKit bwrap 等）解析不到链接目标。
  # 不设 SSL_CERT_DIR：/etc/ssl/certs 里没有 hashed 证书，指过去只是把 CApath 变成空目录。
  environment.sessionVariables.SSL_CERT_FILE = config.security.pki.caBundle;
  environment.sessionVariables.CURL_CA_BUNDLE = config.security.pki.caBundle;

  programs.git.enable = true;
  programs.vim.enable = true;
  programs.nano.enable = true;
  programs.tmux.enable = true;

  environment.systemPackages = with pkgs; [
    nano-syntax-highlighting
    curl
    wget
    fastfetch
    btop
    gh
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    maple-mono.NF-CN-unhinted
    corefonts
    vista-fonts
    vista-fonts-chs
  ];

  fonts.fontconfig = {
    localConf = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
      <!-- Keep Adwaita Sans glyphs and use the Noto sans chain afterwards. -->
      <alias binding="strong">
        <family>Adwaita Sans</family>
        <prefer>
          <family>Adwaita Sans</family>
          <family>Noto Sans</family>
          <family>Noto Sans CJK SC</family>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>

      <alias binding="strong">
        <family>ui-sans-serif</family>
        <prefer>
          <family>Noto Sans</family>
          <family>Noto Sans CJK SC</family>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>
      <alias binding="strong">
        <family>ui-serif</family>
        <prefer>
          <family>Noto Serif</family>
          <family>Noto Serif CJK SC</family>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>
      <alias binding="strong">
        <family>ui-monospace</family>
        <prefer>
          <family>Maple Mono NF CN</family>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>
      <alias binding="strong">
        <family>ui-emoji</family>
        <prefer>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>

      <!-- Remove Korean CJK faces without rejecting the shared TTC files. -->
      <selectfont>
        <rejectfont>
          <pattern>
            <patelt name="family"><string>Noto Sans CJK KR</string></patelt>
          </pattern>
          <pattern>
            <patelt name="family"><string>Noto Sans Mono CJK KR</string></patelt>
          </pattern>
          <pattern>
            <patelt name="family"><string>Noto Serif CJK KR</string></patelt>
          </pattern>
        </rejectfont>
      </selectfont>
      </fontconfig>
    '';

    defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"
        "Noto Color Emoji"
      ];
      monospace = [ "Maple Mono NF CN" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  i18n.defaultLocale = "zh_CN.UTF-8";
  time.timeZone = "Asia/Shanghai";

  hardware.bluetooth.enable = true;
  security.pam.services.swaylock = { };
}
