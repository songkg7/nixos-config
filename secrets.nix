let
  haril = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeXjbE3iBeowyVr6AnZ0GXnAS5ce4n0LVhUHRfXIGt4 agenix-key";
in
{
  "test-secret.age" = {
    publicKeys = [ haril ];
    armor = true;
  };
  "secret1.age" = {
    publicKeys = [ haril ];
    armor = true;
  };
}
