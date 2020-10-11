let
  src = fetchGit {
    url = "https://github.com/juliosueiras-nix/nix-psp";
    ref = "heads/master";
  };
in {
  test = (builtins.getFlake("git+https://github.com/juliosueiras-nix/nix-psp?ref=${src.rev}")).outputs.hydraJobs;
}
