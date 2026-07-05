# CLAUDE.md

Guidance for Claude (and Claude Code) when working in this repo.

## What this is

**Omarchy-supplement** is a personal customization layer for [Omarchy](https://omarchy.org),
a Hyprland-based Arch Linux setup. Instead of editing Omarchy's own files (which upstream
updates would overwrite), this repo keeps overrides separate and wires them in via a
`source =` line and symlinks. The installers are backup-safe: existing files are moved to
`.bak` before anything is replaced.

Repo lives at `~/Omarchy-supplement` on the target machine. Several configs reference that
path directly (e.g. keybinds calling `$HOME/Omarchy-supplement/bin/...`), so the repo is
expected to sit there.

## Layout

- `install.sh` — top-level entry point; runs the two installers below in order.
- `install-hyprland-overrides.sh` — main installer. Appends `source = .../hyprland-overrides.conf`
  to `~/.config/hypr/hyprland.conf`, symlinks `hypridle.conf`, installs the Gmail `.desktop`
  handler, sets Gmail as the default `mailto:` app in `~/.config/mimeapps.list`, and symlinks
  everything in `bin/` into `~/.local/bin`.
- `install-dotfiles.sh` — clones [Dotfiles-V2](https://github.com/NJBLAGA/Dotfiles-V2) to `~/Dotfiles`
  and `stow`s: ghostty, starship, tmux, waybar, nvim, bash. Requires GNU `stow`.
- `hyprland-overrides.conf` — the core file. Vim-style `hjkl` keybindings (focus / resize /
  swap / move-workspace), dual-monitor workspace layout (1–5 on DP-1, 6–10 on eDP-1), rules
  pinning Omarchy floating TUIs and portal file-pickers to DP-1, and web-app launchers
  (Gmail, ChatGPT, Claude, NordPass, keyboard configurator). Unbinds the Omarchy defaults it
  replaces, each with an explanatory comment.
- `hypridle.conf` — idle behavior: screensaver at 15 min, lock at 16 min, lock-on-sleep.
- `gmail.desktop` — desktop entry making Gmail (via Chromium) the `mailto:` handler.
- `bin/nvim-cheatsheet` — generates a Neovim keybinding cheatsheet and opens it in a floating
  Ghostty terminal via fzf. Bound to `SUPER+CTRL+/`.
- `bin/nvim-cheatsheet-ui` — the fzf UI half, run inside the terminal by the script above.

## Conventions

- **Don't edit Omarchy's files directly.** Add overrides here; they load via the sourced
  config. Keep this repo the single source of truth for personal customizations.
- **Keybinds use `bindd`** (Hyprland's documented-bind form) so descriptions show up in the
  keybindings menu. When adding a bind that reuses a key Omarchy already claims, add a matching
  `unbind` in the "Unbinds" section with a comment saying what moved where.
- **Installers must stay idempotent and backup-safe.** Check for existing symlinks/lines before
  acting; back up real files to `.bak` rather than overwriting.
- **Monitor assumptions:** external `DP-1` (primary) + laptop `eDP-1`. Rules fall back to the
  laptop screen automatically when DP-1 is disconnected — preserve that behavior.
- After changing `hyprland-overrides.conf`, reload with `hyprctl reload` (also bound to `SUPER+R`).

## Testing changes

There's no CI. Validate by: reloading Hyprland config after edits, and re-running the relevant
installer (they're safe to re-run) to confirm symlinks/lines are correct.
