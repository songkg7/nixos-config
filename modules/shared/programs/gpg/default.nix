{ config, ... }:
{
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ./files/public.key;
        trust = "ultimate";
      }
    ];
  };

  home.file.".test/secret1" = {
    source = config.age.secrets.secret1.file;
  };
}
