{
  description = "AstRiverse RE Compute Node - NixOS Flakes";

  nixConfig = {
    substituters = [
      # [Nixpkgs Official Cache]
      # TUNA Mirror
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # NJU Mirror
      "https://mirrors.nju.edu.cn/nix-channels/store"
      # NixOS Official
      "https://cache.nixos.org"
    ];
    extra-substituters = [
      # [Cachix Cache]
      "https://af-nur.cachix.org"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      # [Numtide Cache]
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    extra-trusted-public-keys = [
      "af-nur.cachix.org-1:687IgiHqfOdqzW/AXQGtoKO7PH5Tx3kbCRn7XODV17M="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  inputs = {
    # NixOS Nixpkgs

    # [TUNA Mirror]
    # nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    # [NJU Mirror]
    # nixpkgs.url = "git+https://mirror.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    # [Github]
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs.git?ref=nixos-unstable&shallow=1";

    # NixOS Hardware Configurations
    nixos-hardware = {
      # [ghfast.top Mirror]
      # url = "git+https://ghfast.top/https://github.com/NixOS/nixos-hardware.git?shallow=1";
      # [Github]
      url = "git+https://github.com/NixOS/nixos-hardware.git?shallow=1";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix User Repository
    nur = {
      # [ghfast.top Mirror]
      # url = "git+https://ghfast.top/https://github.com/nix-community/NUR.git?shallow=1";
      # [Github]
      url = "git+https://github.com/nix-community/NUR.git?shallow=1";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      # [ghfast.top Mirror]
      # url = "git+https://ghfast.top/https://github.com/nix-community/home-manager.git?shallow=1";
      # [Github]
      url = "git+https://github.com/nix-community/home-manager.git?shallow=1";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fix-python
    fix-python = {
      # [ghfast.top Mirror]
      # url = "git+https://ghfast.top/https://github.com/GuillaumeDesforges/fix-python.git?shallow=1";
      # [Github]
      url = "git+https://github.com/GuillaumeDesforges/fix-python.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # LLM Agents (oh-my-pi)
    llm-agents = {
      # [ghfast.top Mirror]
      # url = "git+https://ghfast.top/https://github.com/numtide/llm-agents.nix.git?shallow=1";
      # [Github]
      url = "git+https://github.com/numtide/llm-agents.nix.git?shallow=1";
    };

    catppuccin = {
      # url = "git+https://ghfast.top/https://github.com/catppuccin/nix.git?shallow=1";
      # [Github]
      url = "git+https://github.com/catppuccin/nix.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dank Material Shell
    dms = {
      # [Github]
      url = "git+https://github.com/AvengeMedia/DankMaterialShell.git?shallow=1";
      # [ghfast.top Mirror]
      # url = "git+https://ghfast.top/https://github.com/AvengeMedia/DankMaterialShell.git?shallow=1";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DMS Greeter
    dank-greeter = {
      # [Github]
      url = "git+https://github.com/AvengeMedia/dank-greeter.git?shallow=1";
      # [ghfast.top Mirror]
      # url = "git+https://ghfast.top/https://github.com/AvengeMedia/dank-greeter.git?shallow=1";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri (SHORiN-KiWATA fork)
    niri = {
      # [ghfast.top Mirror]
      # url = "git+https://ghfast.top/https://github.com/SHORiN-KiWATA/niri.git?shallow=1";
      # [Github]
      url = "git+https://github.com/SHORiN-KiWATA/niri.git?shallow=1";

      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      nur,
      home-manager,
      ...
    }@inputs:
    let
      specialArgs = { inherit inputs; };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      nixosModules = {
        nur = { ... }: {
          nixpkgs.overlays = [
            inputs.nur.overlays.default
          ];
        };
        nixpkgs = { ... }: {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [
            (final: prev: {
              openssl_1_1 = (prev.callPackage ./overlays/openssl-1.1/default.nix { }).openssl_1_1;
            })
            (final: prev: {
              openldap =
                if prev.stdenv.hostPlatform.system == "i686-linux" then
                  prev.openldap.overrideAttrs (old: {
                    doCheck = false;
                    doInstallCheck = false;
                  })
                else
                  prev.openldap;
            })
          ];
        };
      };

      nixosConfigurations = {
        g5000 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = specialArgs // {
            afDevice = "aflare/g5000";
          };
          modules = [
            self.nixosModules.nur
            self.nixosModules.nixpkgs
            ./hosts/g5000/configuration.nix
            nixos-hardware.nixosModules.lenovo-legion-16irx8h
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
