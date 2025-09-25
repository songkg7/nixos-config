{
  config,
  pkgs,
  ...
}: {
  # AstroNvim 템플릿을 ~/.config/nvim에 설치
  home.file.".config/nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "AstroNvim";
      repo = "template";
      rev = "89ebfd35d6415634d82cc6f2991bf66c842872d0";
      sha256 = "sha256-nxPdSG4TMpNwB8d4s3Iw/uULZgx04HBYf+QSwZXQyH8=";
    };
  };

  # neovim이 설치되어 있는지 확인
  home.packages = with pkgs; [
    neovim
  ];
}