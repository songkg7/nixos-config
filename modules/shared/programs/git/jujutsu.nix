{ user-profile, ... }:
{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = user-profile.personal.name;
        email = user-profile.personal.email;
      };
    };
  };
}
