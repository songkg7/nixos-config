{
  config,
  lib,
  profileConfig,
  ...
}:
let
  passwordManager = profileConfig.passwordManager;
  gpgSshSettings =
    if profileConfig.platform.isDarwin then
      {
        allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      }
      // lib.optionalAttrs (passwordManager.gitSshProgram != null) {
        program = passwordManager.gitSshProgram;
      }
    else
      null;
in
{
  programs.git = {
    enable = true;
    signing = {
      key = profileConfig.user.sshSigningKey;
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
      ".omc"
      ".claude"
    ];

    settings = {
      user = {
        name = profileConfig.user.fullName;
        email = profileConfig.user.email;
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
      # pager.{diff,log,reflog,show} 는 programs.delta.enableGitIntegration 이 자동 설정.
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
    // lib.optionalAttrs profileConfig.platform.isDarwin {
      "gpg \"ssh\"" = gpgSshSettings;
    };

    lfs.enable = true;

    includes = lib.optionals profileConfig.platform.isDarwin [
      {
        condition = "gitdir:~/projects/42dot/";
        path = "~/.config/git/gitconfig-work";
      }
    ];
  };
}
