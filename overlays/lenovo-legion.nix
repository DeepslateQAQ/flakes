# The upstream install target copies the module by hand, bypassing Kbuild's
# modules_install and therefore the kmodigest signing step. aggregateModules
# then fails on the missing legion-laptop.ko.cer (NixOS/nixpkgs#575192).
final: prev: {
  linuxPackages_zen = prev.linuxPackages_zen.extend (
    lfinal: lprev: {
      lenovo-legion-module = lprev.lenovo-legion-module.overrideAttrs (old: {
        makeFlags = (old.makeFlags or [ ]) ++ [
          "INSTALL_MOD_PATH=${placeholder "out"}"
          "INSTALL_MOD_DIR=kernel/drivers/platform/x86"
          "DEPMOD=true"
        ];
        installTargets = [ "modules_install" ];
        installFlags = [
          "-C"
          "${lfinal.kernel.dev}/lib/modules/${lfinal.kernel.modDirVersion}/build"
          "M=$(PWD)"
        ];
      });
    }
  );
}
