{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "homerow";
  version = "1.4.1";

  src = fetchurl {
    url = "https://builds.homerow.app/v${finalAttrs.version}/Homerow.zip";
    sha256 = "0xz5gw628r4nwp0fyf93pdq7jiplha8lw5fzn3z7i3mg8gcpm6px";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = "Homerow.app";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications/${finalAttrs.sourceRoot}"
    cp -R . "$out/Applications/${finalAttrs.sourceRoot}"
    runHook postInstall
  '';

  meta = {
    description = "Keyboard shortcuts for every button in macOS";
    homepage = "https://homerow.app";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
})
