{self, ...}: {
  flake.nixosModules.helium = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.helium
    ];
  };

  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: {
    packages.helium = let
      pname = "helium";
      version = "0.14.3.1";

      src = pkgs.fetchurl {
        url = "https://github.com/imputnet/helium-linux/releases/download/${version}/${pname}-${version}-x86_64.AppImage";
        sha256 = "sha256-umRDXcHlDRDWpdP4wxr81q+cUXkjiIxyg2AcJRFQaMA=";
      };
    in
      pkgs.appimageTools.wrapType2 rec {
        inherit pname version src;

        _enableFeatures = ["VaapiVideoDecoder"];

        extraPkgs = pkgs: [pkgs.libva];

        extraBwrapArgs = [
          "--ro-bind-try /etc/chromium /etc/chromium"
        ];

        nativeBuildInputs = [pkgs.makeWrapper];

        extraInstallCommands = let
          contents = pkgs.appimageTools.extract {inherit pname version src;};
        in ''
          wrapProgram $out/bin/${pname} \
            --add-flags \"--enable-features=${pkgs.lib.strings.concatStringsSep "," _enableFeatures}\"
          install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
          cp -r ${contents}/usr/share/icons $out/share
        '';
      };
  };
}
