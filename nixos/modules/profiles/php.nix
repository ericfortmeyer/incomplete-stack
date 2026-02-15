{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    php
    phpExtensions.bcmath
    phpExtensions.curl
    phpExtensions.gd
    phpExtensions.imagick
    phpExtensions.intl
    phpExtensions.mbstring
    phpExtensions.opcache
    phpExtensions.pdo
    phpExtensions.pdo_mysql
    phpExtensions.pdo_pgsql
    phpExtensions.redis
    phpExtensions.sodium
    phpExtensions.xml
    phpExtensions.zip
    phpPackages.composer
    phpPackages.psysh
    phpstan
  ];
}
