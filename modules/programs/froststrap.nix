{self, ...}: {
  flake.nixosModules.froststrap = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.froststrap
    ];
  };

  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages.froststrap = let
      pname = "Froststrap";
      version = "2.0.0";
      beta = "10";

      src = pkgs.fetchurl {
        url = "https://github.com/Froststrap/${pname}/releases/download/v${version}-beta.${beta}/${pname}-linux-x64.AppImage";
        sha256 = "sha256-aWtDYjD9mjTFGivVtiWRI8m8RxiUO7e5h73t1xt4lSc=";
      };
    in
      pkgs.appimageTools.wrapType2 rec {
        inherit pname version src;

        extraPkgs = pkgs:
          with pkgs; [
            icu
            zlib
            openssl
          ];

        extraInstallCommands = let
          contents = pkgs.appimageTools.extract {inherit pname version src;};
        in ''
          install -m 444 -D ${contents}/${pname}.desktop $out/share/applications/${pname}.desktop

          sed -i "s|^Exec=.*|Exec=${pname}|" $out/share/applications/${pname}.desktop

          if [ -d "${contents}/usr/share/icons" ]; then
            mkdir -p $out/share
            cp -r ${contents}/usr/share/icons $out/share/
          fi
        '';
      };
  };
}
