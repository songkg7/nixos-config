_: {
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ./files/public.key;
        trust = "ultimate";
      }
    ];
  };
}
