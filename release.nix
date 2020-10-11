let
  src = fetchGit {
    url = "https://github.com/juliosueiras-nix/nix-psp";
    ref = "master";
  };
in {
  test = (builtins.getFlake("git+https://github.com/juliosueiras-nix/nix-psp?rev=${src.rev}")).outputs.hydraJobs;
}
