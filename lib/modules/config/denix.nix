{
  delib,
  lib,
  config,
  options,
  ...
}:
{
  imports = [
    ./moduleSystems/default.nix
  ];

  options =
    with delib;
    let
      foo = apply (anythingOption [ ]) lib.toList;
    in
    {
      myconfig = submoduleWithOption {
        modules = builtins.concatLists (
          builtins.attrValues (
            builtins.mapAttrs (
              mName: m:
              map (x: { options = delib.setAttrByStrPath x mName; }) m.options
              ++ m.myconfig.always
              ++ map (
                x:
                { config, ... }:
                {
                  config = lib.mkIf (delib.getAttrByStrPath config "${mName}.enable" false) x;
                }
              ) m.myconfig.ifEnabled
              ++ map (
                x:
                { config, ... }:
                {
                  config = lib.mkIf (!(delib.getAttrByStrPath config "${mName}.enable" true)) x;
                }
              ) m.myconfig.ifDisabled
            ) config.modules
          )
        );
      } { };

      modules = attrsOfOption (submoduleWith {
        # NOTE: requires https://github.com/NixOS/nixpkgs/pull/437972
        onlyDefinesConfig = true;
        modules = [
          (
            { name, ... }:
            {
              options = {
                options = apply (allowAttrs (listOfOption attrs [ ])) lib.toList;
                myconfig = {
                  ifEnabled = foo;
                  ifDisabled = foo;
                  always = foo;
                };
              }
              // builtins.mapAttrs (name: value: {
                ifEnabled = foo;
                ifDisabled = foo;
                always = foo;
              }) config.moduleSystems;

            }
          )
          (
            { name, ... }:
            {
              config = {
                _module.args = {
                  cfg = delib.getAttrByStrPath config.myconfig name { };
                  opt = delib.getAttrByStrPath options.myconfig.type.getSubOptions name { };
                };
              };
            }
          )
        ];
      });
    };
}
