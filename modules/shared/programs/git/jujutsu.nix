{ profileConfig, ... }:
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = profileConfig.user.fullName;
        email = profileConfig.user.email;
      };
    };
  };
}
