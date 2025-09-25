{
  config,
  pkgs,
  ...
}: {
  homebrew.enable = true;
  homebrew.casks = [
    "1password"
    "1password-cli"
  ];
}