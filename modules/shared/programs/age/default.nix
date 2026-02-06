{
  config,
  lib,
  environment,
  pkgs,
  ...
}:
let
  secretsPath = ../../../../secrets;
  homeConfig = "${config.home.homeDirectory}/.config";
  envConfig =
    if pkgs.stdenv.isDarwin then
      (import ../../../darwin/environments).${environment}
    else
      { ageSecrets.hasAwsConfig = false; };
in
{
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
    secrets = {
      gitconfig-work = {
        file = secretsPath + /gitconfig-work.age;
        path = "${homeConfig}/git/gitconfig-work";
      };
      allowed-signers = {
        file = secretsPath + /allowed-signers.age;
        path = "${homeConfig}/git/allowed_signers";
      };
      "mise.work.toml" = {
        file = secretsPath + /mise-work-env.age;
        path = "${homeConfig}/mise/conf.d/mise.work.toml";
      };
      "mise.personal.toml" = {
        file = secretsPath + /mise-personal-env.age;
        path = "${homeConfig}/mise/conf.d/mise.personal.toml";
      };
    }
    // lib.optionalAttrs envConfig.ageSecrets.hasAwsConfig {
      "awsconfig-work" = {
        file = secretsPath + /awsconfig-work.age;
        path = "${config.home.homeDirectory}/.aws/config";
      };
    };
  };
}
