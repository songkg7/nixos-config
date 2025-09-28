{
  description = "haril/nixos-config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils?rev=13faa43c34c0c943585532dacbb457007416d50b";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nuschtosSearch.follows = "nuschtos-search";
    };

    nuschtos-search = {
      url = "github:NuschtOS/search";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    home-manager,
    nix-darwin,
    nixpkgs,
    ...
  } @ inputs: let
    dev-shell = import ./libraries/dev-shell {inherit inputs;};
    home-manager-shared = ./libraries/home-manager;
    nixpkgs-shared = ./libraries/nixpkgs;
    darwinSystems = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    mkDarwinSystem = system:
      nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          home-manager-shared
          nixpkgs-shared
          home-manager.darwinModules.home-manager
          ./modules/shared/configuration.nix
          ./modules/darwin/configuration.nix
          ./modules/darwin/home.nix
        ];
        specialArgs = {inherit inputs;};
      };
  in
    dev-shell
    // {
      darwinConfigurations =
        (nixpkgs.lib.genAttrs darwinSystems mkDarwinSystem)
        // {
          darwin = mkDarwinSystem (builtins.currentSystem or "x86_64-darwin");
          "kyung-keuns-iMac" = mkDarwinSystem (builtins.currentSystem or "x86_64-darwin");
        };

      nixosConfigurations.linux = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager-shared
          nixpkgs-shared
          home-manager.nixosModules.home-manager
          ./modules/shared/configuration.nix
          ./modules/linux/configuration.nix
          ./modules/linux/home.nix
        ];
        specialArgs = {inherit inputs;};
      };
    };
}
