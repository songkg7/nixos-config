{ config
, pkgs
, lib
, ...
}:
let
  homerowPackage = pkgs.callPackage ./package.nix { };
  cfg = config.programs.homerow;

  boolValue = x: if x then "YES" else "NO";

  writeValue =
    value:
    if lib.isBool value then
      "-bool ${boolValue value}"
    else if lib.isInt value then
      "-int ${toString value}"
    else if lib.isFloat value then
      "-float ${lib.strings.floatToString value}"
    else if lib.isString value then
      "-string '${value}'"
    else
      throw "invalid value type for homerow config: ${toString value}";

  writeDefault =
    key: value: "/usr/bin/defaults write com.superultra.Homerow '${key}' ${writeValue value}";

  homerowDefaults =
    let
      allConfig = cfg.config // {
        "NSStatusItem Visible Item-0" = cfg.config.show-menubar-icon;
      };
      filteredConfig = lib.filterAttrs (_n: v: v != null) allConfig;
    in
    lib.mapAttrsToList writeDefault filteredConfig;
in
{
  options.programs.homerow = {
    enable = lib.mkEnableOption "homerow";

    package = lib.mkOption {
      type = lib.types.package;
      default = homerowPackage;
      description = "The homerow package to use.";
    };

    config = {
      auto-deactivate-scrolling = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Automatic scroll deactivation";
      };
      auto-deactivate-scrolling-delay-s = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.int
          lib.types.float
        ];
        default = 1;
        description = "Deactivation delay";
      };
      auto-switch-input-source-id = lib.mkOption {
        type = lib.types.str;
        default = "com.apple.keylayout.ABC";
        description = "Input source";
      };
      check-for-updates-automatically = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Check for updates automatically";
      };
      dash-speed-multiplier = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.int
          lib.types.float
        ];
        default = 1.5;
        description = "Dash speed";
      };
      disabled-bundle-paths = lib.mkOption {
        type = lib.types.listOf (
          lib.types.oneOf [
            lib.types.path
            lib.types.str
          ]
        );
        default = [ ];
        description = "Ignored applications";
        apply =
          value:
          if !(lib.isList value) then
            value
          else
            "(${(lib.strings.concatStringsSep "," (lib.map (val: "\"${val}\"") value))})";
      };
      enable-hyper-key = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Hyperkey enabled";
      };
      hide-labels-when-nothing-is-searched = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Hide labels before search";
      };
      is-auto-click-enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatic click";
      };
      is-scroll-shortcuts-enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Scroll commands";
      };
      label-characters = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Label characters";
      };
      label-font-size = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "Label size";
      };
      launch-at-login = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Launch on login";
      };
      map-arrow-keys-to-scroll = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Arrow keys";
      };
      non-search-shortcut = lib.mkOption {
        type = lib.types.str;
        default = "⌥⌘Space";
        description = "Shortcut";
      };
      scroll-keys = lib.mkOption {
        type = lib.types.str;
        default = "HJKL";
        description = "Scroll keys";
      };
      scroll-px-per-ms = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.int
          lib.types.float
        ];
        default = 1;
        description = "Scroll speed";
      };
      scroll-shortcut = lib.mkOption {
        type = lib.types.str;
        default = "⇧⌘J";
        description = "Shortcut (Scrolling)";
      };
      scroll-show-numbers = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show scroll area numbers";
      };
      search-shortcut = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Search Shortcut";
      };
      show-menubar-icon = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Show menubar icon";
      };
      theme-id = lib.mkOption {
        type = lib.types.str;
        default = "original";
        description = "Theme";
      };
      use-search-predicate = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Browser labels";
      };
    };
  };

  config = lib.mkMerge [
    {
      programs.homerow = {
        enable = lib.mkDefault true;
        config = {
          launch-at-login = lib.mkDefault true;
          check-for-updates-automatically = lib.mkDefault false;
          dash-speed-multiplier = lib.mkDefault 2;
          label-font-size = lib.mkDefault 10;
          non-search-shortcut = lib.mkDefault "⌥F";
          scroll-px-per-ms = lib.mkDefault 1.5;
          search-shortcut = lib.mkDefault "⌥⌘↩";
          scroll-shortcut = lib.mkDefault "⌃J";
        };
      };
    }

    (lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];

      home.activation.homerowDefaults = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${lib.concatStringsSep "\n" homerowDefaults}
      '';

      launchd.agents.homerow = {
        enable = true;
        config = {
          ProgramArguments = [
            "${config.home.homeDirectory}/Applications/${cfg.package.sourceRoot}/Contents/MacOS/Homerow"
          ];
          KeepAlive = true;
          ProcessType = "Interactive";
          StandardOutPath = "${config.xdg.cacheHome}/homerow.log";
          StandardErrorPath = "${config.xdg.cacheHome}/homerow.log";
        };
      };
    })
  ];

}
