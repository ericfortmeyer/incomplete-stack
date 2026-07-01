{ config, ... }:

{
    services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      # (Optional) keep SSH sessions alive
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
    };
  };
}
