{ delib, lib, ... }:
{
  denixConfiguration =
    {
      modules ? [ ],
    }:
    lib.evalModules {
      modules = [ ./config/denix.nix ] ++ modules;

      specialArgs = {
        inherit delib;
      };
    };

  compileModule =
    {
      configuration,
      moduleSystem,
      applyMyConfig ? configuration.config.moduleSystems.${moduleSystem}.applyMyConfig,
    }:
    {
      imports =
        let
          inherit (configuration) config;

          modules = lib.attrsToList config.modules;
          moduleSystems = lib.attrsToList config.moduleSystems;

          x =
            lib.concatLists (
              lib.map (
                m:
                let
                  mEnabled = delib.getAttrByStrPath config.myconfig "${m.name}.enable" false;
                  mDisabled = !(delib.getAttrByStrPath config.myconfig "${m.name}.enable" true);
                in
                lib.concatLists (
                  lib.map (
                    ms:
                    ms.value.apply {
                      inherit moduleSystem;
                      modules =
                        m.value.${ms.name}.always or [ ]
                        ++ lib.optionals mEnabled m.value.${ms.name}.ifEnabled or [ ]
                        ++ lib.optionals mDisabled m.value.${ms.name}.disabled or [ ];
                    }
                  ) moduleSystems
                )
              ) modules
            )
            ++ [
              (applyMyConfig { inherit (configuration.options) myconfig; })
            ];
        in
        x;
    };
}
