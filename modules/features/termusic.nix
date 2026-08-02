{self, ...}: {
  flake.nixosModules.termusic = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.termusic
    ];
  };

  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages.termusic = pkgs.rustPlatform.buildRustPackage rec {
      pname = "termusic";
      version = "0.13.2";

      src = pkgs.fetchFromGitHub {
        owner = "tramhao";
        repo = "termusic";
        rev = "v${version}";
        hash = "sha256-GAbUvxRWKy5tDjf+G5cKXgwNs9Rm52h7mICyDFlrCoo=";
      };

      cargoHash = "sha256-xFQObWhONoRBAdEZblBDQeQtq/KmaCWWnCwv3XEmG2k=";

      doCheck = false;

      buildInputs = [pkgs.alsa-lib pkgs.dbus pkgs.glib pkgs.openssl pkgs.sqlite];
      nativeBuildInputs = [pkgs.pkg-config pkgs.protobuf];
    };
  };
}
