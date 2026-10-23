# v4l2loopback's `make modules_install` runs depmod and leaves modules.alias*
# in its output, which collides with the kernel's own modules output when the
# NixOS modules tree is built. Disable depmod; the modules tree regenerates
# the map files after merging.
final: prev: {
  linuxPackages_zen = prev.linuxPackages_zen.extend (
    _final: lprev: {
      v4l2loopback = lprev.v4l2loopback.overrideAttrs (old: {
        makeFlags = (old.makeFlags or [ ]) ++ [ "DEPMOD=true" ];
      });
    }
  );
}
