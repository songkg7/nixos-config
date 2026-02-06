{
  deno = {
    format = " [deno](italic) [∫ $version](green bold)";
    version_format = "\${raw}";
  };

  lua = {
    format = " [lua](italic) [$symbol$version]($style)";
    version_format = "\${raw}";
    symbol = "⨀ ";
    style = "bold bright-yellow";
  };

  nodejs = {
    format = " [node](italic) [◫ ($version)](bold bright-green)";
    version_format = "\${raw}";
    detect_files = [
      "package-lock.json"
      "yarn.lock"
    ];
    detect_folders = [ "node_modules" ];
    detect_extensions = [ ];
  };

  python = {
    format = " [py](italic) [$symbol$version]($style)";
    symbol = "[⌉](bold bright-blue)⌊ ";
    version_format = "\${raw}";
    style = "bold bright-yellow";
  };

  ruby = {
    format = " [rb](italic) [$symbol$version]($style)";
    symbol = "◆ ";
    version_format = "\${raw}";
    style = "bold red";
  };

  rust = {
    format = " [rs](italic) [$symbol$version]($style)";
    symbol = "⊃ ";
    version_format = "\${raw}";
    style = "bold red";
  };

  package = {
    format = " [pkg](italic dimmed) [$symbol$version]($style)";
    version_format = "\${raw}";
    symbol = "◨ ";
    style = "dimmed yellow italic bold";
  };

  swift = {
    format = " [sw](italic) [$symbol$version]($style)";
    symbol = "◁ ";
    style = "bold bright-red";
    version_format = "\${raw}";
  };

  aws = {
    disabled = true;
    format = " [aws](italic) [$symbol $profile $region]($style)";
    style = "bold blue";
    symbol = "▲ ";
  };

  buf = {
    symbol = "■ ";
    format = " [buf](italic) [$symbol $version $buf_version]($style)";
  };

  c = {
    symbol = "ℂ ";
    format = " [$symbol($version(-$name))]($style)";
  };

  cpp = {
    symbol = "ℂ ";
    format = " [$symbol($version(-$name))]($style)";
  };

  conda = {
    symbol = "◯ ";
    format = " conda [$symbol$environment]($style)";
  };

  pixi = {
    symbol = "■ ";
    format = " pixi [$symbol$version ($environment )]($style)";
  };

  meson = {
    symbol = "◇ ";
    format = " meson [$symbol$project]($style)";
  };

  dart = {
    symbol = "◁◅ ";
    format = " dart [$symbol($version )]($style)";
  };

  docker_context = {
    symbol = "◧ ";
    format = " docker [$symbol$context]($style)";
  };

  elixir = {
    symbol = "△ ";
    format = " exs [$symbol $version OTP $otp_version ]($style)";
  };

  elm = {
    symbol = "◩ ";
    format = " elm [$symbol($version )]($style)";
  };

  golang = {
    symbol = "∩ ";
    format = " go [$symbol($version )]($style)";
  };

  haskell = {
    symbol = "❯λ ";
    format = " hs [$symbol($version )]($style)";
  };

  java = {
    symbol = "∪ ";
    format = " java [$symbol($version )]($style)";
  };

  julia = {
    symbol = "◎ ";
    format = " jl [$symbol($version )]($style)";
  };

  memory_usage = {
    symbol = "▪▫▪ ";
    format = " mem [$ram( $swap)]($style)";
  };

  nim = {
    symbol = "▴▲▴ ";
    format = " nim [$symbol($version )]($style)";
  };

  spack = {
    symbol = "◇ ";
    format = " spack [$symbol$environment]($style)";
  };
}
