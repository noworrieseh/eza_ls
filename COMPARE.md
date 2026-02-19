# macOS BSD ls vs GNU ls (gls) Comparison

Shared options with **different meanings** between macOS BSD `ls` and GNU `gls`:

| Option | BSD (macOS) | GNU (gls) | eza_ls |
|--------|-------------|-----------|--------|
| `-g` | no effect (legacy) | long without owner | emulates GNU: `--long --no-user --group` |
| `-o` | no effect (legacy) | long without group | emulates GNU: `--long` |
| `-U` | use time created for sorting/printing | do not sort | emulates BSD: `--created` |
| `-B` | escape non-printable as `_xxx` | ignore backup files (`~`) | emulates GNU: `--bytes` |
| `-b` | escape non-printable (C codes) | same as `-B` (escape) | unsupported: eza uses unicode |
| `-T` | complete time (full timestamp) | tab size | emulates BSD: `--time-style=full-iso` |
| `-X` | don't cross device boundaries | sort by extension | emulates GNU: `--sort=extension` |
| `-D` | custom date format | dired output (Emacs) | emulates BSD: `--time-style=+FORMAT` |
