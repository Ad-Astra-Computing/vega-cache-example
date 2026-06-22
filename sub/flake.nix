{
  description = "Vega subflake (?dir=) reproduction test fixture, in a subdirectory.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/50ab793786d9de88ee30ec4e4c24fb4236fc2674";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        # Deterministic, repo-unique, lives only in this subdirectory flake. Vega
        # should record its provenance as github:<repo>?dir=sub and reproduce it
        # as github:<repo>/<rev>?dir=sub#subprobe.
        subprobe = pkgs.runCommand "vega-subflake-probe-1" { } ''
          mkdir -p "$out"
          printf 'vega subflake ?dir= reproduction probe v1\n' > "$out/probe.txt"
        '';
        default = self.packages.${system}.subprobe;
      };
    };
}
