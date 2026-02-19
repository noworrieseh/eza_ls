# eza_ls

A bash wrapper script that makes [eza](https://github.com/eza-community/eza) behave as a drop-in replacement for `ls` command.  alias ls='eza_ls'

## Why?

eza is a modern, Rust-based replacement for `ls` with many useful features. However, if you're used to `ls` flags, eza uses different flags. This wrapper translates `ls` flags to their eza equivalents so you can use familiar `ls` syntax.  In addition, if you add the "--eza" flag, it will display the generated eza command to get more familiar with the eza flags.

## Usage

```bash
# Use familiar ls flags
eza_ls -la
eza_ls -lS          # Size sort (largest first)
eza_ls -lSr         # Size sort reversed (smallest first)
eza_ls -lart        # Long, all, reverse, time sort

# Works with any directory
eza_ls -la /usr/local/bin

# See the generated eza command
eza_ls --eza -la /usr/local/bin
# Output: eza --long --all --all /usr/local/bin
```

## Supported Flags

| ls Flag | eza Equivalent | Description |
|---------|---------------|-------------|
| `-1` | `--oneline` | One entry per line |
| `-a` | `--all --all` | Show hidden files + . and .. |
| `-A` | `--almost-all` | Show hidden files (no . or ..) |
| `-b` | `--binary` / `--bytes` | Binary prefixes |
| `-B` | `--bytes` | Bytes |
| `-c` | `--time=changed` | Changed time |
| `-C` | `--grid` | Grid view |
| `-d` | `--treat-dirs-as-files` | List dirs as files |
| `-D` | `--dereference` | Dereference |
| `-f` | `--only-files` | Only files |
| `-F` | `--classify` | Type indicators |
| `-g` | `--group` | Show group |
| `-G` | (no group) | No group |
| `-h` | (human-readable) | Human readable |
| `-H` | `--links` | Show hard links |
| `-i` | `--inode` | Show inode |
| `-I` | `--ignore-glob` | Ignore pattern |
| `-k` | `--binary` | Binary (1K) |
| `-l` | `--long` | Long format |
| `-L` | `--dereference` | Dereference |
| `-m` | `--modified` | Modified time |
| `-n` | `--numeric` | Numeric IDs |
| `-o` | `--octal-permissions` | Octal permissions |
| `-p` | `--classify` | Classify |
| `-r` | `--reverse` | Reverse sort |
| `-R` | `--recurse` | Recursive |
| `-s` | `--blocksize` | Block size |
| `-S` | `--sort=size --reverse` | Size sort (largest first) |
| `-t` | `--sort=modified` | Time sort |
| `-T` | (ignore) | Tab size |
| `-u` | `--accessed` | Accessed time |
| `-U` | `--created` | Created time |
| `-v` | `--version` | Version |
| `-w` | `--width` | Width |
| `-x` | `--across` | Sort across |
| `-X` | `--sort=extension` | Extension sort |
| `-Z` | `--context` | Security context |

### Long Options
Also supports: `--color`, `--group-directories-first`, `--group-directories-last`, `--hide`, `--indicator-style`, `--show-all`, `--sort`, `--time`, `--time-style`
