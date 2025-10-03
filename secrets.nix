let
  haril = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL1RtDi9ri3XMhCYCX1vPMYnoOMPVpnmvvD4yuJcuzdS agenix-key";
in
{
  "mise-work-env.age" = {
    publicKeys = [ haril ];
  };
}
