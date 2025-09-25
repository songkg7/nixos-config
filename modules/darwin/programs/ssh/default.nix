{...}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      # Only set `IdentityAgent` not connected remotely via SSH.
      # This allows using agent forwarding when connecting remotely.
      Match host * exec "test -z $SSH_TTY"
        IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  }
}
