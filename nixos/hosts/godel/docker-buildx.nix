{
  services.docker-buildx = {
    enable = true;
    builderName = "cold-storage";
    platforms = [ "linux/amd64" "linux/arm64" ];
  };   
}
