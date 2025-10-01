{
  inputs,
  system,
  ...
}: let
  pkgs = import inputs.nixpkgs {inherit system;};
in
  pkgs.mkShell {
    packages = with pkgs; [
      # for Nix
      nixfmt-rfc-style
      alejandra
      nixpkgs-fmt
      deadnix
      nix-tree
      nix-du

      git-lfs

      # utilities
      lefthook
      yq
      tree
      wget
      nmap
      zip
      rsync
      tmux
      screen

      # system info
      fastfetch
    ];

    env = {
      NIX_CONFIG = "experimental-features = nix-command flakes";
    };

    # 셸 진입 시 실행할 스크립트
    shellHook = ''
       # Install lefthook pre-commit hooks if not already installed
       if [ ! -f .git/hooks/pre-commit ]; then
         lefthook install
       fi

       # Clear screen for clean output
       clear

      # Display system info with fastfetch
      echo "🚀 NixOS Config Development Environment"

      # Dynamic separator line that fills terminal width
      cols=$(tput cols 2>/dev/null || echo 80)
      separator=$(printf "━%.0s" $(seq 1 $cols))
      echo "$separator"

      fastfetch --config none --logo nixos_small --structure "Title:Separator:OS:Host:Kernel:Uptime:Packages:Shell:Terminal:CPU:Memory"

      echo "$separator"
      echo ""

      # Project info
      echo "📍 Working directory: $(pwd)"
      echo "🔧 Project: Personal NixOS Configuration"
      echo ""

      # Available tools summary
      echo "📦 Available dev tools:"
      echo "├─ Nix formatters: alejandra (default), nixfmt-rfc-style, nixpkgs-fmt"
      echo "├─ Nix analyzers:  deadnix, statix, nix-tree, nix-du"
      echo "└─ Utilities:      yq, tree, git-lfs, tmux, screen"
      echo ""

      # Quick reference
      echo "⚡ Quick commands:"
      printf "  %-20s %s\n" "nix fmt ." "Format all Nix files (alejandra)"
      printf "  %-20s %s\n" "alejandra ." "Format with alejandra directly"
      printf "  %-20s %s\n" "nix flake check" "Validate configuration"
      printf "  %-20s %s\n" "nix flake update" "Update dependencies"
      printf "  %-20s %s\n" "nix flake show" "Show dependency tree"
      printf "  %-20s %s\n" "deadnix --edit" "Remove unused code"
      echo ""

      # Note about home.nix tools
      echo "💡 Additional tools from home.nix: git, ripgrep, fd, jq, htop, lazygit, etc."
      echo ""

      # Welcome message
      echo "🎯 Ready for NixOS configuration development!"
      echo ""
    '';
  }
