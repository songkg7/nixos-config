{ config, ... }:
let
  secretsPath = ../../../../secrets;
  homeConfig = "${config.home.homeDirectory}/.config";
in
{
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
    secrets = {
      gitconfig-work = {
        file = secretsPath + /gitconfig-work.age;
        path = "${homeConfig}/git/gitconfig-work";
      };
      "mise.work.toml" = {
        file = secretsPath + /mise-work-env.age;
        path = "${homeConfig}/mise/conf.d/mise.work.toml";
      };
      "mise.personal.toml" = {
        file = secretsPath + /mise-personal-env.age;
        path = "${homeConfig}/mise/conf.d/mise.personal.toml";
      };
    };
  };
}
