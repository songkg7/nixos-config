{
  add_newline = true;
  continuation_prompt = "[▸▹ ](dimmed white)";
  command_timeout = 3000;

  format = "($nix_shell$container$fill$git_metrics\n)$cmd_duration$hostname$localip$shlvl$shell$env_var$jobs$sudo$username$character";

  right_format = "\n$singularity$kubernetes$directory$vcsh$fossil_branch$git_branch$git_commit$git_state$git_status$hg_branch$pijul_channel$docker_context$package$c$cpp$cmake$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$vlang$vagrant$zig$buf$conda$pixi$meson$spack$memory_usage$aws$gcloud$openstack$azure$crystal$custom$status$os$battery$time";

  fill.symbol = " ";
}
