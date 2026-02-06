{ environment, ... }:
let
  envConfig = (import ../../environments).${environment};
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = envConfig.sshIncludes;
    matchBlocks = {
      "*" = {
        identityAgent = "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock";
      };
    };
  };
}
