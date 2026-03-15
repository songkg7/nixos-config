{
  pkgs,
  profileConfig,
  ...
}:
let
  username = profileConfig.user.username;
in
{
  home-manager.users.${username} =
    { ... }:
    {
      home.packages = with pkgs; [
        unzip
      ];
    };
}
