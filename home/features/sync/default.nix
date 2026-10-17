{
  config,
  lib,
  ...
}: let
  tailnet = "allosaurus-dojo.ts.net";
  deviceIds = {
    zephyrion = "UEUKNTP-5QOZVMC-G4MOVNY-U6WEUV4-MSY66J2-33ICS2N-KMZCASU-U5A3QAG";
    deep-m6-mini = "VEN73VJ-JBKYH74-Y7HOW4Z-YZWBARV-KJ3WYYB-ZIFNNQW-2IWHQJ2-77K45AN";
  };
in {
  options.sync.folders = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {};
  };

  config.services.syncthing = {
    enable = true;
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      options = {
        globalAnnounceEnabled = false;
        localAnnounceEnabled = false;
        relaysEnabled = false;
        natEnabled = false;
        urAccepted = -1;
      };
      devices =
        lib.mapAttrs (name: id: {
          inherit id;
          addresses = ["tcp://${name}.${tailnet}:22000"];
        })
        deviceIds;
      folders =
        lib.mapAttrs (id: path: {
          inherit path;
          devices = lib.attrNames deviceIds;
          versioning = {
            type = "trashcan";
            params.cleanoutDays = "30";
          };
        })
        config.sync.folders;
    };
  };
}
