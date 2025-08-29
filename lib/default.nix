{ lib, ... }:
let
  inherit (import ./toplevel/lib.nix { inherit lib; }) mkLib;
in
mkLib "delib" (delib: {
  fixedPoints = delib._callLib ./toplevel/fixed-points.nix;
  inherit (delib.fixedPoints)
    fix
    fixWithUnfix
    recursivelyExtends
    recursivelyComposeExtensions
    recursivelyComposeManyExtensions
    makeRecursivelyExtensible
    makeRecursivelyExtensibleWithCustomName
    ;

  inherit (delib._callLib ./toplevel/lib.nix) mkLib;

  modules = delib._callLib ./modules;
  inherit (delib.modules) denixConfiguration compileModule;

  attrset = delib._callLib ./attrset.nix;
  inherit (delib.attrset) getAttrByStrPath setAttrByStrPath hasAttrs;

  options = delib._callLib ./options.nix;
  # builtins.concatStringsSep " " (builtins.attrNames lib.options)
  inherit (delib.options)
    allowAnything
    allowAttrs
    allowAttrsLegacy
    allowAttrsOf
    allowBool
    allowCoercedTo
    allowEnum
    allowFloat
    allowFunction
    allowFunctionTo
    allowInt
    allowIntBetween
    allowList
    allowListOf
    allowNull
    allowNumber
    allowOneOf
    allowPackage
    allowPath
    allowPort
    allowSingleLineStr
    allowStr
    allowSubmodule
    allowSubmoduleWith
    anything
    anythingOption
    apply
    attrs
    attrsLegacy
    attrsLegacyOption
    attrsOf
    attrsOfOption
    attrsOption
    bool
    boolOption
    coercedTo
    coercedToOption
    defaultText
    description
    enum
    enumOption
    example
    float
    floatOption
    function
    functionOption
    functionTo
    functionToOption
    int
    intBetween
    intBetweenOption
    intOption
    internal
    list
    listOf
    listOfOption
    listOption
    null
    nullOption
    number
    numberOption
    oneOf
    oneOfOption
    package
    packageOption
    path
    pathOption
    port
    portOption
    readOnly
    relatedPackages
    singleLineStr
    singleLineStrOption
    str
    strOption
    submodule
    submoduleOption
    submoduleWith
    submoduleWithOption
    visible
    ;
})
