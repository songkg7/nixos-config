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
    flake-utils,
    home-manager,
    nix-darwin,
    nixpkgs,
    ...
  } @ inputs: let
    home-manager-shared = ./libraries/home-manager;
    nixpkgs-shared = ./libraries/nixpkgs;

    # Darwin 시스템 생성 함수
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

    darwinSystems = ["x86_64-darwin" "aarch64-darwin"];
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = import ./libraries/dev-shell {inherit inputs system;};

      formatter = pkgs.alejandra;
    })
    // {
      # Darwin configurations
      darwinConfigurations =
        (nixpkgs.lib.genAttrs darwinSystems mkDarwinSystem)
        // {
          intel-darwin = mkDarwinSystem "x86_64-darwin";
          apple-darwin = mkDarwinSystem "aarch64-darwin";
        };

      # Linux configuration
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
