# eza_ls Support Matrix

This document provides a comprehensive overview of ls options and their support in eza_ls.

## Summary

| Status | Count |
|--------|-------|
| ✅ Supported | 48 |
| ❌ Unsupported | 25 |
| **Total** | **73** |

## Option Details

| Option | Description | BSD | GNU | Supported |
|--------|-------------|-----|-----|-----------|
| -% | Mark dataless files with '%' | Yes | No | ❌ |
| -, | Group file sizes with thousands separator | Yes | No | ❌ |
| --author | Print author of each file | No | Yes | ❌ |
| --block-size | Block size | No | Yes | ✅ |
| --color | Color output (auto/always/never) | Yes | Yes | ✅ |
| --dereference-command-line-symlink-to-dir | Follow symlinks to directories | No | Yes | ❌ |
| --dired | Emacs dired mode | No | Yes | ❌ |
| --file-type | File type indicator (no *) | No | Yes | ✅ |
| --format | Set output format | No | Yes | ❌ |
| --full-time | Full timestamp | No | Yes | ✅ |
| --group-directories-first | Directories first | No | Yes | ✅ |
| --hide | Hide pattern | No | Yes | ✅ |
| --hyperlink | Hyperlink files | No | Yes | ✅ |
| --indicator-style | Indicator style | No | Yes | ✅ |
| --quoting-style | Quoting style | No | Yes | ❌ |
| --show-control-chars | Show control characters | No | Yes | ❌ |
| --si | SI units | No | Yes | ❌ |
| --sort | Sort field | No | Yes | ✅ |
| --time | Time field | No | Yes | ✅ |
| --time-style | Time format | No | Yes | ✅ |
| --version | Output version information | No | Yes | ✅ |
| --zero | NUL output | No | Yes | ❌ |
| -1 | One entry per line | Yes | Yes | ✅ |
| -@ | Extended attributes | Yes | No | ✅ |
| -a, --all | Show hidden files | Yes | Yes | ✅ |
| -A, --almost-all | Show hidden files (no . or ..) | Yes | Yes | ✅ |
| -b, --escape | Escape non-printable | Yes | Yes | ❌ |
| -B, --ignore-backups | Ignore backup files (~) | No | Yes | ✅ |
| -c | Use ctime for sorting | Yes | Yes | ✅ |
| -C | List in columns | Yes | Yes | ✅ |
| -D | Custom date format | Yes | No | ✅ |
| -d, --directory | List directories as files | Yes | Yes | ✅ |
| -e | Print ACL (use -Z for security context) | Yes | No | ❌ |
| -f | No sort, show all | Yes | Yes | ✅ |
| -F, --classify | Type indicators (*/=>@|) | Yes | Yes | ✅ |
| -g | Long without owner | Yes | Yes | ✅ |
| -G | Colorized output | Yes | No | ❌ |
| -G, --no-group | No group column | No | Yes | ✅ |
| -H, --dereference-command-line | Follow symlinks on command line | Yes | Yes | ✅ |
| -h, --human-readable | Human readable sizes | Yes | Yes | ✅ |
| -I, --ignore | Ignore pattern | Yes | Yes | ✅ |
| -i, --inode | Show inode numbers | Yes | Yes | ✅ |
| -k, --kibibytes | 1024-byte blocks | Yes | Yes | ✅ |
| -l | Long format | Yes | Yes | ✅ |
| -L, --dereference | Follow symlinks | Yes | Yes | ✅ |
| -m | Comma-separated list | Yes | Yes | ❌ |
| -N, --literal | No quoting | No | Yes | ✅ |
| -n, --numeric-uid-gid | Numeric UID/GID | Yes | Yes | ✅ |
| -o | Long without group | Yes | Yes | ✅ |
| -O | File flags | Yes | No | ❌ |
| -P | Don't follow symlinks | Yes | No | ❌ |
| -p, --indicator-style | Indicator for directories | Yes | Yes | ✅ |
| -q, --hide-control-chars | Print ? for nongraphic chars | No | Yes | ❌ |
| -Q, --quote-name | Quote names | No | Yes | ❌ |
| -R, --recursive | Recursive | Yes | Yes | ✅ |
| -r, --reverse | Reverse sort | Yes | Yes | ✅ |
| -S | Sort by size (largest first) | Yes | Yes | ✅ |
| -s, --size | Show size | Yes | Yes | ✅ |
| -t | Sort by time | Yes | Yes | ✅ |
| -T | Full timestamp | Yes | No | ✅ |
| -T, --tabsize | Tab size | No | Yes | ❌ |
| -u | Use access time | Yes | Yes | ✅ |
| -U | Use created time | Yes | No | ✅ |
| -U | No sort, show all | No | Yes | ❌ |
| -v | Force unedited printing | Yes | No | ❌ |
| -v | Version sort | No | Yes | ❌ |
| -W | Show whiteouts | Yes | No | ❌ |
| -w, --width | Set output width | Yes | Yes | ✅ |
| -x | Sort across columns | Yes | Yes | ✅ |
| -X | Don't cross filesystem boundaries | Yes | No | ❌ |
| -X, --sort=extension | Sort by extension | No | Yes | ✅ |
| -y | Sort alphabetical same as time | Yes | No | ❌ |
| -Z, --context | Security context | No | Yes | ✅ |

## BSD vs GNU Differences

These options have different meanings between BSD (macOS) and GNU ls:

| Option | BSD (macOS) | GNU (gls) | eza_ls Behavior |
|--------|-------------|-----------|-----------------|
| `-g` | No effect (legacy) | Long without owner | GNU: `--long --no-user --group` |
| `-o` | No effect (legacy) | Long without group | GNU: `--long` (no group) |
| `-G` | Enable color | No group column | GNU: (eza default, no group) |
| `-U` | Use created time | Do not sort | BSD: `--created` |
| `-B` | Escape non-printable as `_xxx` | Ignore backup files (~) | GNU: `--ignore-glob=*~` |
| `-b` | Escape non-printable (C codes) | Escape non-printable | Unsupported: eza uses unicode |
| `-T` | Full timestamp | Tab size | BSD: `--time-style=full-iso` |
| `-X` | Don't cross device boundaries | Sort by extension | GNU: `--sort=extension` |
| `-D` | Custom date format | Emacs dired mode | BSD: `--time-style=+FORMAT` |
| `-I` | Prevent -A for superuser | Ignore pattern | GNU: `--ignore-glob` |

## Partial Support Details

### `-@` (Extended Attributes)
The `--extended` flag in eza only works when combined with `-l` (long format).

### `-h` (Human Readable)
eza_ls matches ls behavior:
- **Default**: Adds `--bytes` (numeric bytes, like `ls`)
- **-h**: Omits `--bytes` (human-readable, like `ls -h`)

Example:
```
$ eza_ls -l file     # shows: 9,356 bytes
$ eza_ls -lh file   # shows: 9.4K
```

### `--block-size=SIZE`
Only supports:
- `K` → `--binary`
- `B` → `--bytes`

Other sizes are unsupported.

## Notes

- eza_ls uses a two-pass processing approach to ensure flag order independence
- `-al -S` = `-alS` = `-la -S` = `-laS`
- Size sort (`-S`) defaults to largest first (like ls), unlike eza's default
- The `-a` flag uses `--all --all` to match ls behavior (showing . and ..)
- eza always adds default arguments if not specified: `.`, `--bytes`, `-g`
