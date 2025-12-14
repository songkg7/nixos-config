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
    };

    nuschtos-search = {
      url = "github:NuschtOS/search";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs =
    {
      flake-utils,
      home-manager,
      nix-darwin,
      nixos-wsl,
      nixpkgs,
      ...
    }@inputs:
    let
      home-manager-shared = ./libraries/home-manager;
      nixpkgs-shared = ./libraries/nixpkgs;
      user-profile = {
        personal = {
          name = "haril song";
          email = "songkg7@gmail.com";
        };
      };

      # Darwin 시스템 생성 함수
      mkDarwinSystem =
        system: environment:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            inputs.agenix.darwinModules.default
            home-manager-shared
            nixpkgs-shared
            home-manager.darwinModules.home-manager
            { home-manager.extraSpecialArgs = { inherit environment user-profile; }; }
            ./modules/shared/configuration.nix
            ./modules/darwin/configuration.nix
            ./modules/darwin/home.nix
          ];
          specialArgs = { inherit inputs environment user-profile; };
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
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
          inputs.agenix.nixosModules.default
          nixos-wsl.nixosModules.default
          home-manager-shared
          nixpkgs-shared
          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit user-profile;
              environment = "personal";
            };
          }
          ./modules/shared/configuration.nix
          ./modules/linux/configuration.nix
          ./modules/linux/home.nix
        ];
        specialArgs = {
          inherit inputs user-profile;
          environment = "personal";
        };
      };
    };
}
