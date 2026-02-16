{ pkgs }:
{
  # Homebrew prefix path based on architecture
  # Apple Silicon: /opt/homebrew
  # Intel: /usr/local
  brewPrefix = if pkgs.stdenv.isAarch64 then "/opt/homebrew" else "/usr/local";
}
