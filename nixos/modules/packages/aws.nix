{ pkgs, ... }:
{
  environment.defaultPackages = with pkgs; [
    awscli
    aws-iam-authenticator
    granted
  ];
}
