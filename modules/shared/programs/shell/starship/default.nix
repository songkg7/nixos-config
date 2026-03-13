let
  format = import ./format.nix;
  prompt = import ./prompt.nix;
  git = import ./git.nix;
  languages = import ./languages.nix;
in
{
  programs.starship = {
    enable = true;
    settings = format // prompt // git // languages;
  };
}
