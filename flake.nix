{
  description = "haril/nixos-config";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs =
    {
      flake-utils,
      agenix,
      home-manager,
      nix-darwin,
      nixpkgs,
      ...
    }@inputs:
    let
      home-manager-shared = ./libraries/home-manager;
      nixpkgs-shared = ./libraries/nixpkgs;

      # Darwin 시스템 생성 함수
      mkDarwinSystem =
        system: environment:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            agenix.nixosModules.default
            home-manager-shared
            nixpkgs-shared
            home-manager.darwinModules.home-manager
            { home-manager.extraSpecialArgs = { inherit environment; }; }
            ./modules/shared/configuration.nix
            ./modules/darwin/configuration.nix
            ./modules/darwin/home.nix
          ];
          specialArgs = { inherit inputs environment; };
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.agenix = agenix.packages.${system}.default;

        devShells.default = import ./libraries/dev-shell { inherit inputs system; };

        formatter = pkgs.nixfmt-tree;
      }
    )
    // {
      # Darwin configurations
      darwinConfigurations = {
        work = mkDarwinSystem "aarch64-darwin" "work";
        personal = mkDarwinSystem "x86_64-darwin" "personal";
      };

      # Linux configuration
      nixosConfigurations.linux = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
          home-manager-shared
          nixpkgs-shared
          home-manager.nixosModules.home-manager
          ./modules/shared/configuration.nix
          ./modules/linux/configuration.nix
          ./modules/linux/home.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };
}
