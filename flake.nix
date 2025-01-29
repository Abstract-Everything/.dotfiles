{
  description = "Jonathan's dotfiles";

  inputs = { };

  outputs = { self }:
    {
      home = import ./home.nix;
      nixgl = import ./nixgl.nix;
    };
}
