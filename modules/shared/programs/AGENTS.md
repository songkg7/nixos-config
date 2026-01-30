# SHARED PROGRAM MODULES

**Generated:** 2026-01-30 10:19 KST

## OVERVIEW

Cross-platform Home Manager program modules imported by both Darwin and Linux home.nix.

## STRUCTURE

```
./
├── shell/        # zsh, starship, fzf, zoxide, mise
├── git/          # git + delta + gh
├── ai/           # AI tooling modules
├── vim/          # nixvim + AstroNvim integration
├── gpg/          # GPG config + files
└── <program>/    # each has default.nix aggregator
```

## WHERE TO LOOK

| Task                   | Location              | Notes                                  |
| ---------------------- | --------------------- | -------------------------------------- |
| Add new shared program | <program>/default.nix | default.nix aggregates feature files   |
| Update shell defaults  | shell/default.nix     | imports atuin/fzf/starship/mise/zoxide |
| Git tooling config     | git/default.nix       | imports git.nix, delta.nix, gh.nix     |
| AI tool config         | ai/default.nix        | centralizes AI-related packages        |
| Vim config             | vim/default.nix       | links to AstroNvim modules             |

## CONVENTIONS

- Each program directory has a `default.nix` that imports sibling feature files.
- Keep feature-specific modules alongside `default.nix` (e.g., `git/gh.nix`).

## ANTI-PATTERNS

- None documented here.
