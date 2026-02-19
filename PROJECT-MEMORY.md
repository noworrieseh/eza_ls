# eza_ls Project

## Overview
`eza_ls` is a bash script that wraps the `eza` command to behave like `ls`. It translates ls flags to their eza equivalents.

## Files
- `eza_ls` - Main wrapper script
- `test_eza_ls.sh` - Test suite (74 tests)

## Usage
```bash
./eza_ls [flags] [directory]
./eza_ls --eza [flags] [directory]  # Print eza command instead of executing
```

## Key Design Decisions

### 1. Two-Pass Processing
The script uses two passes over arguments:
- **Pass 1 (scan_arg)**: Collects flags that affect other flags (e.g., `-r` and `-S`)
- **Pass 2 (process_arg)**: Builds the actual eza arguments

This ensures flag order independence:
- `-al -S` = `-alS` = `-la -S` = `-laS`

### 2. Size Sort Reversal
- `ls -S` sorts largest first
- `eza --sort=size` sorts smallest first
- Solution: When `-S` is seen without `-r`, add `--reverse` automatically

Logic:
```bash
if [[ $has_size_sort -eq 1 ]]; then
    eza_args+=("--sort=size")
fi
if [[ $has_reverse -eq 1 && $has_size_sort -eq 0 ]]; then
    eza_args+=("--reverse")  # -r without -S
fi
if [[ $has_size_sort -eq 1 && $has_reverse -eq 0 ]]; then
    eza_args+=("--reverse")  # -S without -r (largest first)
fi
```

### 3. Argument-Consuming Flags
Flags that require an additional argument (`-b`, `-I`, `-w`) use an index-based approach:
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

## Tested Flags

### Display Flags
- `-1` → `--oneline`
- `-l` → `--long`
- `-C` → `--grid`
- `-x` → `--across`
- `-R` → `--recurse`
- `-a` → `--all --all`
- `-A` → `--almost-all`

### Sort Flags
- `-r` → `--reverse`
- `-S` → `--sort=size` (+ `--reverse` for largest-first)
- `-t` → `--sort=modified`
- `-X` → `--sort=extension`

### Info Flags
- `-i` → `--inode`
- `-s` → `--blocksize`
- `-n` → `--numeric`
- `-o` → `--octal-permissions`
- `-Z` → `--context`
- `-g` → `--group`
- `-H` → `--links`

### Time Flags
- `-u` → `--accessed`
- `-U` → `--created`
- `-c` → `--time=changed`
- `-m` → `--modified`

### Filter Flags
- `-d` → `--treat-dirs-as-files`
- `-f` → `--only-files`
- `-I` → `--ignore-glob`

### Classification
- `-F` → `--classify`
- `-p` → `--classify`

### Binary/Bytes
- `-B` → `--bytes`
- `-k` → `--binary`

### Long Options
- `--group-directories-first`
- `--group-directories-last`
- `--show-all` → `--all`
- `--color=auto|never|always` → `--colour=...`
- `--sort=name|time|size|extension`
- `--time=accessed|created|modified`
- `--time-style=iso|long-iso|full-iso`
- `--indicator-style=slash|classify|none`

### Debug Flag
- `--eza` - Print the resulting eza command instead of executing

## Known Issues Fixed
1. **Size sort reversal**: `-S` now sorts largest first (like ls)
2. **Argument-consuming flags**: `-b K`, `-I "*.log"`, `-w 80` no longer read from stdin
3. **--time mapping**: `--time=accessed` and `--time=created` now map correctly
4. **Two-pass flag ordering**: `-al -S` equals `-alS`

## Running Tests
```bash
./test_eza_ls.sh
```

## Eza Repository
This project is a wrapper for eza: https://github.com/eza-community/eza
