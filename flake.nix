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

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-steipete = {
      url = "github:steipete/homebrew-tap";
      flake = false;
    };

    homebrew-antoniorodr = {
      url = "github:antoniorodr/homebrew-memo";
      flake = false;
    };

    homebrew-yakitrak = {
      url = "github:yakitrak/homebrew-yakitrak";
      flake = false;
    };

    homebrew-openhue = {
      url = "github:openhue/homebrew-cli";
      flake = false;
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    determinate.url = "github:DeterminateSystems/determinate";
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
      nixpkgs-shared = ./libraries/nixpkgs;
      nixpkgsPolicy = import ./libraries/nixpkgs/policy.nix { lib = nixpkgs.lib; };
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          inherit (nixpkgsPolicy) overlays config;
        };
      userProfile = {
        username = "haril";
        personal = {
          name = "haril song";
          email = "songkg7@gmail.com";
          sshSigningKey = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFmb4oZ2xckQFPlFFl90Hy9sblwNAwC20JPuMj236hVB songkg7@gmail.com";
        };
      };
      darwinEnvironments = import ./modules/darwin/environments;
      defaultDarwinProfile = {
        packages = [ ];
        brews = [ ];
        casks = [ ];
        masApps = { };
        dockApps = [ ];
        sshIncludes = [ ];
        passwordManager = {
          desktopCasks = [ ];
          enableBitwardenCli = false;
          sshIdentityAgent = null;
          sshAuthSock = null;
          gitSshProgram = null;
        };
        sshRuntime = {
          backend = null;
          cacheTtlSshSeconds = null;
          identityAgent = null;
          identityFile = null;
          pinentry = null;
        };
        ageSecrets = {
          hasAwsConfig = false;
        };
      };
      resolveProfilePackages =
        pkgs: profileName: packageNames:
        map (
          name:
          if builtins.hasAttr name pkgs then
            pkgs.${name}
          else
            throw "Unknown package `${name}` in Darwin profile `${profileName}`"
        ) packageNames;
      mkProfileConfig =
        { system, profileName }:
        let
          isDarwin = nixpkgs.lib.hasSuffix "darwin" system;
          pkgsForSystem = mkPkgs system;
          username = userProfile.username;
          rawDarwinProfile =
            if isDarwin then
              nixpkgs.lib.recursiveUpdate defaultDarwinProfile darwinEnvironments.${profileName}
            else
              defaultDarwinProfile;
        in
        {
          name = profileName;
          platform = {
            inherit system isDarwin;
          };
          user = {
            inherit username;
            homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
            fullName = userProfile.personal.name;
            email = userProfile.personal.email;
            sshSigningKey = userProfile.personal.sshSigningKey;
          };
          home = {
            stateVersion = "25.11";
            extraPackages =
              if isDarwin then
                resolveProfilePackages pkgsForSystem profileName rawDarwinProfile.packages
              else
                [ ];
          };
          passwordManager = rawDarwinProfile.passwordManager;
          ssh = {
            includes = rawDarwinProfile.sshIncludes;
            runtime = rawDarwinProfile.sshRuntime;
          };
          secrets = rawDarwinProfile.ageSecrets;
          darwin = {
            brewPrefix = "/opt/homebrew";
            homebrew = {
              brews = rawDarwinProfile.brews;
              casks = rawDarwinProfile.casks;
              desktopCasks = rawDarwinProfile.passwordManager.desktopCasks;
              masApps = rawDarwinProfile.masApps;
            };
            dockApps = rawDarwinProfile.dockApps;
          };
        };

      # Darwin 시스템 생성 함수
      mkDarwinSystem =
        system: profileName:
        let
          profileConfig = mkProfileConfig { inherit system profileName; };
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            inputs.determinate.darwinModules.default
            inputs.agenix.darwinModules.default
            inputs.nix-homebrew.darwinModules.nix-homebrew
            nixpkgs-shared
            home-manager.darwinModules.home-manager
            { home-manager.extraSpecialArgs = { inherit inputs profileConfig; }; }
            ./modules/shared/configuration.nix
            ./modules/darwin/configuration.nix
            ./modules/darwin/home.nix
          ];
          specialArgs = { inherit inputs profileConfig; };
        };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = mkPkgs system;
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
        personal = mkDarwinSystem "aarch64-darwin" "personal";
      };

      # Linux configuration
      nixosConfigurations.linux =
        let
          system = "x86_64-linux";
          profileConfig = mkProfileConfig {
            inherit system;
            profileName = "personal";
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            inputs.determinate.nixosModules.default
            inputs.agenix.nixosModules.default
            nixos-wsl.nixosModules.default
            nixpkgs-shared
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = { inherit inputs profileConfig; }; }
            ./modules/shared/configuration.nix
            ./modules/linux/configuration.nix
            ./modules/linux/home.nix
          ];
          specialArgs = {
            inherit inputs profileConfig;
          };
        };
    };
}
