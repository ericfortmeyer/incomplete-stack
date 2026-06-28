{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ghc
    cabal-install
    stack
    haskell-language-server
    hlint
    dotnet-sdk
    lean4
    agda
    idris2
    coq
  ];
}
