{
  config,
  lib,
  pkgs,
  user-profile,
  ...
}:
let
  isDarwin = pkgs.stdenv.isDarwin;
  headlessSigningKey = "${config.home.homeDirectory}/.ssh/git-signing-headless";

  git-ssh-sign-wrapper = pkgs.writeShellScriptBin "git-ssh-sign-wrapper" ''
    set -euo pipefail

    if [ -n "''${SSH_CONNECTION:-}" ]; then
      args=()
      while [ $# -gt 0 ]; do
        case "$1" in
          -f)
            shift
            args+=("-f" "${headlessSigningKey}")
            shift
            ;;
          *)
            args+=("$1")
            shift
            ;;
        esac
      done
      exec ${pkgs.openssh}/bin/ssh-keygen "''${args[@]}"
    else
      exec /Applications/1Password.app/Contents/MacOS/op-ssh-sign "$@"
    fi
  '';
in
{
  programs.git = {
    enable = true;
    signing = {
      key = user-profile.personal.sshSigningKey;
      signByDefault = true;
    };
    ignores = [
      "*~"
      ".DS_Store"
      ".idea"
      ".envrc"
      ".direnv"
      "mise.local.toml"
      "mise.*.local.toml"
      ".osgrep"
      ".sisyphus"
      ".worktrees"
    ];

    settings = {
      user = {
        name = user-profile.personal.name;
        email = user-profile.personal.email;
      };
      alias = {
        st = "status";
        a = "!git add $(git status -s | fzf -m | awk '{print $2}')";
        unstage = "reset HEAD --";
        bs = "!git switch $(git branch | fzf)";
        poi = "!git branch --merged | grep -v '\\*\\|main\\|master\\|int\\|dev' | xargs -n 1 git branch -d";
      };
      column.ui = "auto";
      branch.sort = "-committerdate";
      core = {
        autocrlf = "input";
        editor = "nvim";
        fsmonitor = true;
        untrackedCache = true;
      };
      init.defaultBranch = "main";
      commit = {
        gpgsign = true;
        verbose = true;
      };
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      pull.rebase = true;
      tag = {
        gpgSign = true;
        sort = "version:refname";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      help.autocorrect = "prompt";
      gpg.format = "ssh";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
      pager = {
        diff = "delta";
        log = "delta";
        reflog = "delta";
        show = "delta";
      };
      delta = {
        "plus-style" = "syntax #012800";
        "minus-style" = "syntax #340001";
        "syntax-theme" = "ansi";
        "navigate" = true;
        "side-by-side" = true;
      };
      merge.conflictstyle = "zdiff3";
      advice = {
        skippedCherryPicks = false;
      };
    }
    // lib.optionalAttrs isDarwin {
      "gpg \"ssh\"".program = "${git-ssh-sign-wrapper}/bin/git-ssh-sign-wrapper";
      "gpg \"ssh\"".allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
    };

    lfs.enable = true;

    includes = lib.optionals isDarwin [
      {
        condition = "gitdir:~/projects/42dot/";
        path = "~/.config/git/gitconfig-work";
      }
    ];
  };
}
