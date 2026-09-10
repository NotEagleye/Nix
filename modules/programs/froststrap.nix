{ self, ... }:
{
  flake.nixosModules.Froststrap = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.Froststrap
    ];
  };

  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {

    packages.Froststrap =
      let
        pname = "Froststrap";
        version = "2.0.0";
        beta = "10";

        src = pkgs.fetchurl {
          url = "https://github.com/Froststrap/${pname}/releases/download/v${version}-beta.${beta}/${pname}-linux-x64.AppImage";
          sha256 = "sha256-aWtDYjD9mjTFGivVtiWRI8m8RxiUO7e5h73t1xt4lSc=";
        };

        contents = pkgs.appimageTools.extract {
          inherit pname version src;
        };

      in pkgs.stdenv.mkDerivation {
        inherit pname version;

        src = contents;

        nativeBuildInputs = [
          pkgs.makeWrapper
        ];

        installPhase = ''
          mkdir -p $out/bin
          mkdir -p $out/share/applications

          cp -r . $out/

          makeWrapper \
            $out/usr/bin/Froststrap \
            $out/bin/Froststrap \
            --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath [
                pkgs.icu
                pkgs.libICE
                pkgs.libSM
                pkgs.libX11
                pkgs.openssl
                pkgs.zlib
                pkgs.stdenv.cc.cc.lib
              ]
            } \
            --prefix PATH : "${pkgs.lib.makeBinPath [
              pkgs.glib
            ]}" \
            --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT false \
            --set ICU_DATA "${pkgs.icu}/share/icu"

          if [ -f $out/${pname}.desktop ]; then
            install -Dm444 \
              $out/${pname}.desktop \
              $out/share/applications/${pname}.desktop

            sed -i \
              "s|^Exec=.*|Exec=Froststrap|" \
              $out/share/applications/${pname}.desktop
          fi

          if [ -d $out/usr/share/icons ]; then
            mkdir -p $out/share
            cp -r $out/usr/share/icons $out/share/
          fi
        '';

        meta = {
          description = "Froststrap Roblox bootstrapper";
          homepage = "https://github.com/Froststrap/Froststrap";
          platforms = [ "x86_64-linux" ];
          mainProgram = "Froststrap";
        };
      };
  };
}
