{ self }:

[
  (builtins.readFile "${self}/authorized_keys/efortmeyer_godel_ed25519.pub")
  (builtins.readFile "${self}/authorized_keys/manna_godel_ed25519.pub")
]
