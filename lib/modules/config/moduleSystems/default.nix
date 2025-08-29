{ delib, lib, ... }:
{
  imports = [
    ./darwin.nix
    ./home.nix
    ./nixos.nix
  ];

  options = with delib; {
    moduleSystems = attrsOfOption (submoduleWith {
      modules = [
        (
          { config, name, ... }:
          {
            options = {
              name = readOnly (strOption name);
              apply = functionToOption list (
                { moduleSystem, modules }: lib.optionals (moduleSystem == config.name) modules
              );
              applyMyConfig = functionToOption attrs (
                { myconfig }:
                {
                  options.myconfig = myconfig;
                }
              );
            };
          }
        )
      ];
    }) { };
  };
}
