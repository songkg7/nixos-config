# HOME MANAGER LIBRARY

**Generated:** 2026-01-30 10:19 KST

## OVERVIEW

Shared Home Manager library modules with OS-specific splits.

## STRUCTURE

```
./
├── default.nix           # sharedModules entry
├── programs/             # custom HM program modules
└── systems/
    ├── darwin/           # macOS-only HM modules
    └── linux/            # Linux-only HM modules
```

## WHERE TO LOOK

| Task                     | Location                    | Notes                           |
| ------------------------ | --------------------------- | ------------------------------- |
| Shared HM module wiring  | default.nix                 | sets home-manager.sharedModules |
| Custom HM program module | programs/<name>/default.nix | optional local HM extensions    |
| OS-specific HM config    | systems/<os>/default.nix    | imported via lib.mkIf           |

## CONVENTIONS

- `default.nix` uses `lib.mkIf` with `isDarwin`/`isLinux` to include OS modules.
- Custom HM modules mirror the `programs/<name>/default.nix` pattern.

## ANTI-PATTERNS

- None documented here.
