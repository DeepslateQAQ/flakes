{
  config,
  lib,
  afDevice,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "deepslate";
  home.homeDirectory = "/home/deepslate";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./niri.nix
    # ./noctalia.nix
    ./alacritty.nix
    ./kitty.nix
    ./btop.nix
    ./tmux.nix
    #   ../../modules/user/graphics/mako.nix
    ../../modules/user/graphics/ozone-platform-hint-fix.nix
    #   ../../modules/user/graphics/waybar.nix
    ../../modules/user/runtimes/java8.nix
    ../../modules/user/runtimes/java17.nix
    ../../modules/user/runtimes/java21.nix
    ../../modules/user/runtimes/gcc.nix
    ../../modules/user/runtimes/nodejs.nix
    ../../modules/user/runtimes/python313.nix
    ../../modules/user/runtimes/go.nix
    ../../modules/user/app/abdm.nix
    #   ../../modules/user/app/alacritty.nix
    ../../modules/user/app/chrome.nix
    # ../../modules/user/app/codex.nix
    ../../modules/user/app/cli-tools.nix
    ../../modules/user/app/dingtalk.nix
    ../../modules/user/app/hmcl.nix
    ../../modules/user/app/keepassxc.nix
    ../../modules/user/app/kitty.nix
    ../../modules/user/app/linuxqq.nix
    ../../modules/user/app/lutris.nix
    ../../modules/user/app/localsend.nix
    ../../modules/user/app/piliplus.nix
    ../../modules/user/app/protonplus.nix
    ../../modules/user/app/remmina.nix
    ../../modules/user/app/snipaste.nix
    ../../modules/user/app/sub-store.nix
    ../../modules/user/app/telegram.nix
    ../../modules/user/app/typora.nix
    ../../modules/user/app/vscode.nix
    ../../modules/user/app/wechat.nix
    ../../modules/user/app/wpsoffice.nix
    ../../modules/user/app/zsh.nix
    ../../modules/user/app/musicfox.nix
    # ../../modules/user/graphics/noctalia-shell.nix
    # ../../modules/user/graphics/kanshi.nix
    # ../../modules/user/app/opencode.nix
    ../../modules/user/app/omp.nix
    ../../modules/user/app/nix-unsafe.nix
    ../../modules/user/app/vlc.nix
    ../../modules/user/app/satty.nix
    ../../modules/user/app/splayer.nix
    ../../modules/user/app/clipsync.nix
    ../../modules/user/app/direnv.nix
    ../../modules/user/app/kdeconnect.nix
    ../../modules/user/app/lmstudio.nix
    ../../modules/user/app/mpv.nix
    ../../modules/user/app/ffmpeg.nix
    ../../modules/user/app/nixfmt.nix
    ../../modules/user/app/cherry-studio.nix
  ];

  services.kanshi.settings = lib.optionals (afDevice == "aflare/g5000") [
    {
      profile = {
        name = "internal";
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            position = "0,0";
            scale = 1.5;
          }
        ];
      };
    }
    {
      profile = {
        name = "docked";
        outputs = [
          {
            criteria = "HDMI-A-1";
            status = "enable";
            position = "0,0";
            mode = "1920x1080";
            scale = 1.0;
          }
          {
            criteria = "eDP-1";
            status = "enable";
            position = "1920,0";
            scale = 1.5;
          }
        ];
      };
    }
  ];

  catppuccin = {
    cursors = {
      enable = true;
      # accent = "dark";
    };
    accent = "lavender";
    flavor = "macchiato";
    autoEnable = false;
    enable = true;
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    cursor-theme = config.home.pointerCursor.name;
    cursor-size = config.home.pointerCursor.size;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  home.packages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
  ];

  home.file = {
    # ".zshrc".source = ./.zshrc;
    ".config/fastfetch/config.jsonc".source = ./.config/fastfetch/config.jsonc;
    ".config/user-dirs.dirs".source = ./.config/user-dirs.dirs;
    ".config/user-dirs.locale".source = ./.config/user-dirs.locale;
    ".config/waybar/config".source = ./.config/waybar/config;
    ".config/waybar/style.css".source = ./.config/waybar/style.css;
    ".local/share/fonts".source = ./fonts;
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
  };
}
