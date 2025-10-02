{environment, ...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes =
      if environment == "personal"
      then ["~/.orbstack/ssh/config"]
      else if environment == "work"
      then ["~/.colima/ssh_config"]
      else [];
    matchBlocks = {
      "*" = {
        identityAgent = "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
    };
  };
}
