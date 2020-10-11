let
  src = fetchGit {
    url = "https://github.com/juliosueiras-nix/nix-psp";
    ref = "refs/heads/master";
  };
in {
  test = (builtins.getFlake("git+https://github.com/juliosueiras-nix/nix-psp?ref=${src.rev}")).outputs.hydraJobs;
}
