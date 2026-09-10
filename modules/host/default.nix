{ self, inputs, ... }: {

	flake.nixosConfigurations.Lenovo = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.Configuration
		];
	};

}
