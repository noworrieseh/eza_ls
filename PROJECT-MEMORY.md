# eza_ls Project

## Overview
`eza_ls` is a bash script that wraps the `eza` command to behave like `ls`. It translates ls flags to their eza equivalents.

## Files
- `eza_ls` - Main wrapper script
- `test_eza_ls.sh` - Test suite (186 tests)
- `ls_options.json` - Structured JSON documentation of all ls options

## Usage
```bash
./eza_ls [flags] [directory]
./eza_ls --eza [flags] [directory]  # Print eza command instead of executing
./eza_ls --help    # Show help
./eza_ls --unsupported  # List unsupported options
```

## Key Design Decisions

### 1. Two-Pass Processing
The script uses two passes over arguments:
- **Pass 1 (scan_arg)**: Collects flags that affect other flags (e.g., `-r`, `-S`, `-l`, `-g`, `-o`)
- **Pass 2 (process_arg)**: Builds the actual eza arguments

This ensures flag order independence:
- `-al -S` = `-alS` = `-la -S` = `-laS`

### 2. Size Sort Reversal
- `ls -S` sorts largest first
- `eza --sort=size` sorts smallest first
- Solution: When `-S` is seen without `-r`, add `--reverse` automatically

### 3. Argument-Consuming Flags
Flags that require an additional argument use an index-based approach:
- Maintain `arg_index` variable to track current position
- Use `process_arg "$arg" 1` to consume next argument
- Must also increment in `scan_arg` for proper two-pass processing

### 4. Combined Flag Processing
Combined flags like `-la` are split and processed in reverse order so that:
- `-al` processes `-l` first, then `-a`
- This ensures flags that depend on order (like `-S` and `-r`) work correctly

### 5. The `-a` Flag
- `ls -a` shows `.` and `..`
- `eza --all` shows hidden files but NOT `.` and `..`
- Solution: Use `--all --all` to match ls behavior

### 6. Default Arguments
The script always adds defaults if not specified:
- `.` - current directory (if no directory given)
- `--bytes` - unless `-h` is used
- `-g` - show group (unless `-G`, `-o`, or `-g` is used)

### 7. Long Flag Handling (needs_long)
Some flags imply `-l` (long format). To avoid adding `--long` twice:
- `-l`, `-g`, `-o`, `--full-time` set `needs_long=1`
- `--long` is added once at the end after all flag processing
- This prevents: `-lg` adding `--long --long`

### 8. Unsupported Option Warnings
Unsupported flags produce a warning to stderr:
```bash
eza_ls: warning: unsupported option(s): -Q --dired
```

### 9. Value Validation
Options with allowed values (color, classify, hyperlink, indicator-style) validate input and warn on invalid values:
- `--color=invalid` → warning: --color value must be auto, always, or never

### 10. BSD vs GNU Behavior
- `-D`: Uses BSD behavior (`--time-style=+FORMAT`)
- `-U`: Uses BSD behavior (`--created`)
- `-T`: Uses BSD behavior (`--time-style=full-iso`)
- `-X`: Uses GNU behavior (`--sort=extension`)
- `-B`: Uses GNU behavior (`--ignore-glob=*~`)
- `-G`: Uses GNU behavior (no group, eza default)

### 11. Never Delete Entries from ls_options.json
Entries should never be removed from ls_options.json without user confirmation. Instead, mark unsupported options with `supported: "unsupported"` and document why in the `notes` field.

## Flag Mappings

### Display Flags
- `-1` → `--oneline`
- `-l` → sets `needs_long`
- `-C` → `--grid`
- `-x` → `--across`
- `-R` → `--recurse`
- `-a` → `--all --all`
- `-A` → `--almost-all`
- `-@` → `--extended`
- `-L` → `--dereference`

### Sort Flags
- `-r` → `--reverse`
- `-S` → `--sort=size` (+ `--reverse` for largest-first)
- `-t` → `--sort=modified`
- `-X` → `--sort=extension`
- `-f` → `--all --all --sort=none`

### Info Flags
- `-i` → `--inode`
- `-s` → `--blocksize`
- `-n` → `--numeric`
- `-o` → sets `needs_long`, no group
- `-Z` → `--context`
- `-g` → sets `needs_long`, `--no-user --group`
- `-H` → `--links`

### Time Flags
- `-u` → `--accessed`
- `-U` → `--created`
- `-c` → `--time=changed`
- `-m` → `--modified`

### Filter Flags
- `-d` → `--treat-dirs-as-files`
- `-f` → `--all --all --sort=none`
- `-I` → `--ignore-glob`
- `-B` → `--ignore-glob=*~`

### Classification
- `-F` → `--classify`
- `-p` → `--classify`

### Binary/Bytes
- `-B` → `--bytes`
- `-k` → `--binary`

### Long Options
- `--color[=auto|always|never]` → `--colour=...`
- `--classify[=auto|always|never]` → `--classify=...`
- `--hyperlink[=auto|always|never]` → `--hyperlink`
- `--group-directories-first`
- `--sort=name|time|size|extension|version`
- `--time=accessed|created|modified|changed`
- `--time-style=iso|long-iso|full-iso|+FORMAT`
- `--indicator-style=none|file-type|classify|slash`
- `--hide=PATTERN` → `--ignore-glob=PATTERN`
- `-N` → `--no-quotes`
- `--file-type` → `--classify=never`
- `--full-time` → sets `needs_long` + `--time-style=full-iso`

### Debug Flags
- `--eza` - Print the resulting eza command instead of executing

## Unsupported Options

### BSD-specific (macOS)
- `-e` → Print ACL (use -Z for security context)
- `-O` → File flags
- `-P` → Don't follow symlinks
- `-W` → Display whiteouts

### GNU-specific
- `--author` → Print author
- `-b`, `--escape` → Escape non-printable (eza uses unicode)
- `-Q`, `--quote-name` → Quote names
- `--quoting-style=WORD` → Quoting style
- `--si` → SI units (powers of 1000)
- `-T`, `--tabsize=COLS` → Tab size
- `-U` → Do not sort (eza always sorts)
- `--zero` → End lines with NUL

## Known Issues Fixed
1. **Size sort reversal**: `-S` now sorts largest first (like ls)
2. **Argument-consuming flags**: `-b K`, `-I "*.log"`, `-w 80` no longer read from stdin
3. **--time mapping**: `--time=accessed` and `--time=created` now map correctly
4. **Two-pass flag ordering**: `-al -S` equals `-alS`
5. **-- separator**: Properly passes through arguments after `--`
6. **Unsupported warnings**: Warns when using unsupported flags
7. **-g/-o with -l**: Only adds `--long` once using `needs_long` flag
8. **-D**: Uses BSD behavior (`--time-style=+FORMAT`)
9. **Value validation**: Invalid values for --color, --classify, --hyperlink, --indicator-style show warnings

## Running Tests
```bash
./test_eza_ls.sh
```

## Eza Repository
This project is a wrapper for eza: https://github.com/eza-community/eza
