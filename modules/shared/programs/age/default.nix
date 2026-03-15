{
  config,
  lib,
  profileConfig,
  ...
}:
let
  secretsPath = ../../../../secrets;
  homeConfig = "${config.home.homeDirectory}/.config";
in
{
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
    secrets = {
      allowed-signers = {
        file = secretsPath + /allowed-signers.age;
        path = "${homeConfig}/git/allowed_signers";
      };
      "mise.personal.toml" = {
        file = secretsPath + /mise-personal-env.age;
        path = "${homeConfig}/mise/conf.d/mise.personal.toml";
      };
    }
    // lib.optionalAttrs profileConfig.secrets.hasAwsConfig {
      "awsconfig-work" = {
        file = secretsPath + /awsconfig-work.age;
        path = "${config.home.homeDirectory}/.aws/config";
      };
      "mise.work.toml" = {
        file = secretsPath + /mise-work-env.age;
        path = "${homeConfig}/mise/conf.d/mise.work.toml";
      };
      gitconfig-work = {
        file = secretsPath + /gitconfig-work.age;
        path = "${homeConfig}/git/gitconfig-work";
      };
    };
  };
}
