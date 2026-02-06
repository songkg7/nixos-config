{
  git_branch = {
    format = " [$branch(:$remote_branch)]($style)";
    symbol = "[△](bold italic bright-blue)";
    style = "italic bright-blue";
    truncation_symbol = "⋯";
    truncation_length = 11;
    ignore_branches = [
      "main"
      "master"
    ];
    only_attached = true;
  };

  git_metrics = {
    format = "([▴$added]($added_style))([▿$deleted]($deleted_style))";
    added_style = "italic dimmed green";
    deleted_style = "italic dimmed red";
    ignore_submodules = true;
    disabled = false;
  };

  git_status = {
    style = "bold italic bright-blue";
    format = "([⎪$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed⎥]($style))";
    conflicted = "[◪◦](italic bright-magenta)";
    ahead = "[▴│[$count](bold white)│](italic green)";
    behind = "[▿│[$count](bold white)│](italic red)";
    diverged = "[◇ ▴┤[$ahead_count](regular white)│▿┤[$behind_count](regular white)│](italic bright-magenta)";
    untracked = "[◌◦](italic bright-yellow)";
    stashed = "[◃◈](italic white)";
    modified = "[●◦](italic yellow)";
    staged = "[▪┤[$count](bold white)│](italic bright-cyan)";
    renamed = "[◎◦](italic bright-blue)";
    deleted = "[✕](italic red)";
  };
}
