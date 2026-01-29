{ user-profile, ... }:
{
  programs.git = {
    enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHfugxfdZ+OHTxqc3RQB+4Y0J18Vea3UNt/9nH6fXL8";
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
      "gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      "gpg \"ssh\"".allowedSignersFile = "/Users/haril/.config/git/allowed_signers";
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
    };

    lfs.enable = true;

    includes = [
      {
        condition = "gitdir:~/projects/42dot/";
        path = "~/.config/git/gitconfig-work";
      }
    ];
  };
}
