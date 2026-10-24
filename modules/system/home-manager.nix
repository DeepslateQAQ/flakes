{ inputs, slateId, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    overwriteBackup = true;
    extraSpecialArgs = {
      inherit inputs slateId;
    };
    users.deepslate = import ../../home/deepslate;
  };
}
