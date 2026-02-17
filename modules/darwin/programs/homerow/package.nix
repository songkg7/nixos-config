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
    sha256 = "sha256-VGsCe/jX6tJFVMKri/c/ZZrQw1dxKzkFHfHw9hiNoAY=";
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
