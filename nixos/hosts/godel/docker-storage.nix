{
  services.docker-storage = {
    coldStoragePath = "/mnt/hdd-artifacts";
    buildCachePath = "/mnt/hdd-artifacts/docker/buildx";
    registryDataPath = "/mnt/hdd-registry";
  };
}
