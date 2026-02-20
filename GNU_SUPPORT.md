# GNU ls Options vs eza_ls Support

Analysis of all options from `gls --help` (GNU ls).

| ls Option | Description | eza_ls Support | Notes |
|-----------|-------------|-----------------|-------|
| **-a, --all** | Do not ignore entries starting with . | ✅ Full | `--all --all` |
| **-A, --almost-all** | Do not list implied . and .. | ✅ Full | `--almost-all` |
| **--author** | With -l, print the author of each file | ❌ Not supported | eza doesn't have author |
| **-b, --escape** | Print C-style escapes for nongraphic characters | ❌ Not supported | eza uses unicode |
| **--block-size=SIZE** | Scale sizes by SIZE | ⚠️ Partial | `--binary` for K, `--bytes` for B |
| **-B, --ignore-backups** | Do not list entries ending with ~ | ✅ Full | `--ignore-glob=*~` |
| **-c** | With -lt: sort by ctime; with -l: show ctime | ✅ Full | `--time=changed` |
| **-C** | List entries by columns | ✅ Full | `--grid` |
| **--color[=WHEN]** | Color output WHEN (always/auto/never) | ✅ Full | `--colour=WHEN` |
| **-d, --directory** | List directories themselves | ✅ Full | `--treat-dirs-as-files` |
| **-D, --dired** | Output designed for Emacs dired | ❌ Not supported | eza_ls uses BSD behavior: `--time-style=+FORMAT` |
| **-f** | Same as -a -U (no sort) | ✅ Full | `--all --all --sort=none` |
| **-F, --classify[=WHEN]** | Append indicator (*/=>@\|) | ✅ Full | `--classify` |
| **--file-type** | Like -F but don't append * | ✅ Full | `--classify=auto` |
| **--format=WORD** | across/horizontal/long/single-column/verbose/vertical | ⚠️ Partial | Some formats supported |
| **--full-time** | Like -l --time-style=full-iso | ✅ Full | `--time-style=full-iso` |
| **-g** | Like -l but don't list owner | ✅ Full | `--long --no-user --group` |
| **--group-directories-first** | Group directories before files | ✅ Full | `--group-directories-first` |
| **-G, --no-group** | Don't print group names | ✅ Full | (eza default) |
| **-h, --human-readable** | Human readable sizes (1K 234M 2G) | ⚠️ Partial | Default adds --bytes, -h disables |
| **--si** | Like -h but use powers of 1000 | ❌ Not supported | eza only supports 1024 |
| **-H, --dereference-command-line** | Follow symlinks on command line | ✅ Full | `--dereference` |
| **--dereference-command-line-symlink-to-dir** | Follow symlinks to dirs | ❌ Not supported | eza doesn't have this |
| **--hide=PATTERN** | Don't list entries matching pattern | ✅ Full | `--ignore-glob` |
| **--hyperlink[=WHEN]** | Hyperlink file names WHEN | ✅ Full | `--hyperlink=WHEN` |
| **--indicator-style=WORD** | Indicator style (none/slash/file-type/classify) | ✅ Full | `--classify` |
| **-i, --inode** | Print index number of each file | ✅ Full | `--inode` |
| **-I, --ignore=PATTERN** | Don't list entries matching pattern | ✅ Full | `--ignore-glob` |
| **-k, --kibibytes** | 1024-byte blocks | ✅ Full | `--binary` |
| **-l** | Long listing format | ✅ Full | `--long` |
| **-L, --dereference** | Show info for linked file, not link | ✅ Full | `--dereference` |
| **-m** | Comma separated list | ❌ Not supported | eza doesn't have stream format |
| **-n, --numeric-uid-gid** | Numeric user and group IDs | ✅ Full | `--numeric` |
| **-N, --literal** | Print entry names without quoting | ✅ Full | `--no-quotes` |
| **-o** | Like -l but don't list group | ✅ Full | `--long` (no group) |
| **-p, --indicator-style=slash** | Append / to directories | ✅ Full | `--classify=auto` |
| **-q, --hide-control-chars** | Print ? instead of nongraphic | ❌ Not supported | terminal default |
| **--show-control-chars** | Show nongraphic as-is | ❌ Not supported | terminal default |
| **-Q, --quote-name** | Enclose names in double quotes | ❌ Not supported | eza uses different quoting |
| **--quoting-style=WORD** | Quoting style for entry names | ❌ Not supported | eza has fixed style |
| **-r, --reverse** | Reverse order while sorting | ✅ Full | `--reverse` |
| **-R, --recursive** | List subdirectories recursively | ✅ Full | `--recurse` |
| **-s, --size** | Print allocated size in blocks | ✅ Full | `--blocksize` |
| **-S** | Sort by file size, largest first | ✅ Full | `--sort=size --reverse` |
| **--sort=WORD** | Sort by WORD (none/size/time/version/extension/width) | ✅ Full | `--sort=WORD` |
| **--time=WORD** | Which timestamp (atime/ctime/mtime/birth) | ✅ Full | `--time=WORD` |
| **--time-style=TIME_STYLE** | Time/date format | ✅ Full | `--time-style=TIME_STYLE` |
| **-t** | Sort by time, newest first | ✅ Full | `--sort=modified` |
| **-T, --tabsize=COLS** | Assume tab stops at COLS | ❌ Not supported | eza uses fixed 8 |
| **-u** | With -lt: sort by access time | ✅ Full | `--accessed` |
| **-U** | Do not sort (directory order) | ❌ Not supported | eza always sorts |
| **-v** | Natural sort of version numbers | ✅ Full | `--sort=version` |
| **-w, --width=COLS** | Set output width | ✅ Full | `--width=COLS` |
| **-x** | List entries by lines instead of columns | ✅ Full | `--across` |
| **-X** | Sort alphabetically by extension | ✅ Full | `--sort=extension` |
| **-Z, --context** | Print security context | ✅ Full | `--context` |
| **--zero** | End each line with NUL | ❌ Not supported | eza uses newlines |
| **-1** | One file per line | ✅ Full | `--oneline` |
| **--help** | Display help | ❌ Not supported | Not implemented |
| **--version** | Output version information | ✅ Full | `--version` |

## Summary

| Status | Count |
|--------|-------|
| ✅ Full Support | ~42 |
| ⚠️ Partial Support | 3 (--block-size, -h, --format) |
| ❌ Not Supported | ~16 |

## Partial Support Details

### --block-size=SIZE
Only supports K (→ --binary) and B (→ --bytes). Other sizes not supported.

### -h, --human-readable
eza_ls matches GNU ls behavior:
- **Default**: Adds `--bytes` (numeric bytes, like `ls`)
- **-h**: Omits `--bytes` (human-readable, like `ls -h`)

### --format=WORD
Only some formats supported: `long` (-l), `single-column` (-1), `vertical` (-C), `across` (-x)

## Not Supported Details

### --author
eza doesn't track file author.

### -b, --escape
eza uses unicode characters instead of C-style escapes.

### -D, --dired
Emacs-specific output format. Maps to `--time-style=+FORMAT` (BSD behavior).

### --si
eza only supports powers of 1024 (KiB, MiB, etc.), not 1000.

### -m
eza doesn't have stream/comma-separated format.

### -T, --tabsize
eza uses fixed tab size of 8.

### -U
eza always sorts directory entries.

### -Q, --quote-name / --quoting-style
eza has fixed quoting behavior.
