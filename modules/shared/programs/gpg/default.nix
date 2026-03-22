{
  lib,
  pkgs,
  profileConfig,
  ...
}:
let
  sshRuntime = profileConfig.ssh.runtime;
  isPersonalDarwinSshAgent = profileConfig.platform.isDarwin && sshRuntime.backend == "ssh-agent";
  sshAgentSocket = "${profileConfig.user.homeDirectory}/.ssh/agent.sock";
  sshIdentityFile =
    if sshRuntime.identityFile == null then
      null
    else
      lib.replaceStrings [ "~/" ] [ "${profileConfig.user.homeDirectory}/" ] sshRuntime.identityFile;
  sshAgentExe = lib.getExe' pkgs.openssh "ssh-agent";
  sshAddExe = lib.getExe' pkgs.openssh "ssh-add";
in
{
  config = lib.mkMerge [
    {
      programs.gpg = {
        enable = true;
      };
    }

    (lib.mkIf isPersonalDarwinSshAgent {
      programs.zsh.initContent = lib.mkAfter ''
        _personal_ssh_agent_socket='${sshAgentSocket}'
        _personal_ssh_signing_key='${sshIdentityFile}'

        _personal_ssh_agent_healthy() {
          SSH_AUTH_SOCK="$_personal_ssh_agent_socket" ${sshAddExe} -l >/dev/null 2>&1

          case $? in
            0|1) return 0 ;;
            *) return 1 ;;
          esac
        }

        _personal_ssh_agent_ensure() {
          local agent_output

          if [[ -n "$SSH_CONNECTION" ]]; then
            return 0
          fi

          mkdir -p "${profileConfig.user.homeDirectory}/.ssh"

          if ! _personal_ssh_agent_healthy; then
            rm -f "$_personal_ssh_agent_socket"
            agent_output="$(${sshAgentExe} -s -a "$_personal_ssh_agent_socket" 2>/dev/null)" || return $?
            eval "$agent_output" >/dev/null
          fi

          export SSH_AUTH_SOCK="$_personal_ssh_agent_socket"
        }

        ssh-personal-load() {
          if [[ -n "$SSH_CONNECTION" ]]; then
            echo "ssh-personal-load is only available in local shells" >&2
            return 1
          fi

          _personal_ssh_agent_ensure || return $?
          ${sshAddExe} "$_personal_ssh_signing_key"
        }

        _personal_ssh_agent_ensure >/dev/null 2>&1 || true
      '';
    })
  ];
}
