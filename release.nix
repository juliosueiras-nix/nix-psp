{
  result = (import <src/lib.nix> {
    nixpkgs = (<nixpkgs>);
    nixpkgs-mozilla = (<nixpkgs-mozilla>);
  }).createPSPSDK  {
    allowCFWSDK = true;
  };
}
