{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cni-plugins
    containerd
    cri-tools
    fluxcd
    helm
    k9s
    kind
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    minikube
    nerdctl
    stern
  ];
}
