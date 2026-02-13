_: {
  programs.ghostty = {
    enable = true;
    package = null;
    enableZshIntegration = true;
    settings = {
      theme = "Dark Pastel";
      font-family = [
        "MonaspiceKr Nerd Font Propo"
        "D2CodingLigature Nerd Font Propo"
      ];
      macos-option-as-alt = "left";
    };
  };
}
