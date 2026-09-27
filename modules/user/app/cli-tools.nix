{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    gping
    doggo
    ueberzugpp
    httpie
    tcping-rs
    ov
    fx
    procs
    sd
    dust
    duf
    zip
    unzip
    xclip
    wl-clipboard
    file
    binwalk
    exiftool
    unixtools.xxd
    ouch
    mediainfo
    just
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
      "--cycle"
      "--preview-window=right,60%,border-left"
    ];
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_sensitive = false;
      };
    };
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      p7zip
      jq
      poppler
      fd
      ripgrep
      fzf
      zoxide
      ueberzugpp
    ];
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/*"
    ];
  };

  programs.bat = {
    enable = true;
  };

  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [ ".git/" ];
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.jq.enable = true;

  programs.git = {
    enable = true;
    settings = {
      credential = {
        "https://github.com".helper = [
          ""
          "!/run/current-system/sw/bin/gh auth git-credential"
        ];
        "https://gist.github.com".helper = [
          ""
          "!/run/current-system/sw/bin/gh auth git-credential"
        ];
      };
      user = {
        email = "46892455+DeepslateQAQ@users.noreply.github.com";
        name = "DeepslateQAQ";
      };
      push.autoSetupRemote = true;
      safe.directory = "/tmp";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta.navigate = true;
      merge.conflictStyle = "zdiff3";
    };
  };

  home.activation.archiveLegacyGitConfig = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if [ -e "$HOME/.gitconfig" ] || [ -L "$HOME/.gitconfig" ]; then
      if [ -e "$HOME/.gitconfig.pre-home-manager" ] || [ -L "$HOME/.gitconfig.pre-home-manager" ]; then
        errorEcho "Existing Git configuration archive: $HOME/.gitconfig.pre-home-manager"
        exit 1
      fi
      $DRY_RUN_CMD mv "$HOME/.gitconfig" "$HOME/.gitconfig.pre-home-manager"
    fi
  '';

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "-hbSgO"
      "--git"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };
}
