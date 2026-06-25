_: {
  imports = [
    ./antigravity.nix
    ./codex.nix
  ];

  programs.opencode = {
    enable = true;
  };
}
