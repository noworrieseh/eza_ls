# macOS ls Options vs eza_ls Support

Analysis of all options from `man ls` on macOS.

| ls Option | Description | eza_ls Support | Notes |
|-----------|-------------|-----------------|-------|
| **-@** | Display extended attribute keys and sizes in long output | ⚠️ Partial | `--extended` only works with `-l` |
| **-A** | Include entries starting with dot (except . and ..) | ✅ Full | `--almost-all` |
| **-B** | Ignore entries ending with ~ | ✅ Full | `--ignore-glob=*~` |
| **-C** | Force multi-column output | ✅ Full | `--grid` |
| **-D format** | Custom date format for long output | ✅ Full | `--time-style=+FORMAT` |
| **-F** | Display type indicator (*/=@\|) after each file | ✅ Full | `--classify` |
| **-G** | Enable colorized output | ✅ Full | `--colour=auto` |
| **-H** | Follow symlinks on command line | ✅ Full | `--dereference` |
| **-I** | Prevent -A for super-user | ❌ Not supported | macOS-specific |
| **-L** | Follow all symbolic links | ✅ Full | `--dereference` |
| **-O** | Include file flags in long output | ❌ Not supported | macOS-specific |
| **-P** | Don't follow symlinks (list link itself) | ❌ Not supported | eza doesn't have this mode |
| **-R** | Recursively list subdirectories | ✅ Full | `--recurse` |
| **-S** | Sort by size (largest first) | ✅ Full | `--sort=size --reverse` |
| **-T** | Display complete time (month, day, hour, min, sec, year) | ✅ Full | `--time-style=full-iso` |
| **-U** | Use time when file was created | ✅ Full | `--created` |
| **-W** | Display whiteouts | ❌ Not supported | macOS-specific |
| **-X** | Don't descend into different device directories | ❌ Not supported | eza doesn't support this |
| **-a** | Include entries starting with dot | ✅ Full | `--all --all` |
| **-b** | Escape non-printable as C codes | ⚠️ Warning | eza uses unicode, shows warning |
| **-c** | Use time when status changed | ✅ Full | `--time=changed` |
| **--color=when** | Output colored escape sequences (always/auto/never) | ✅ Full | `--colour=always/auto/never` |
| **-d** | List directories as plain files | ✅ Full | `--treat-dirs-as-files` |
| **-e** | Print ACL associated with file | ❌ Not supported | macOS-specific |
| **-f** | Output is not sorted | ✅ Full | `--all --all --sort=none` |
| **-g** | Long format without owner (shows group) | ✅ Full | `--long --no-user --group` |
| **-h** | Human readable sizes (K, M, G) | ⚠️ Partial | Default adds `--bytes`, `-h` disables it |
| **-i** | Print file's serial number (inode) | ✅ Full | `--inode` |
| **-k** | 1024 block size | ✅ Full | `--binary` |
| **-l** | Long format | ✅ Full | `--long` |
| **-m** | Stream output (comma-separated) | ❌ Not supported | eza doesn't have this format |
| **-n** | Display numeric UID/GID | ✅ Full | `--numeric` |
| **-o** | Long format but omit group id | ✅ Full | `--long` (no group) |
| **-p** | Write / after directories | ✅ Full | `--classify=auto` |
| **-q** | Force ? for non-graphic characters | ❌ Not supported | terminal default |
| **-r** | Reverse sort order | ✅ Full | `--reverse` |
| **-s** | Display number of blocks | ✅ Full | `--blocksize` |
| **-t** | Sort by time modified (newest first) | ✅ Full | `--sort=modified` |
| **-u** | Use time of last access | ✅ Full | `--accessed` |
| **-v** | Force unedited printing of non-graphic | ❌ Not supported | terminal default |
| **-w** | Force raw printing of non-printable | ❌ Not supported | terminal default |
| **-x** | Sort across columns | ✅ Full | `--across` |
| **-y** | Sort alphabetically same as time | ❌ Not supported | eza doesn't have this |
| **-%** | Distinguish dataless files with % | ❌ Not supported | macOS-specific |
| **-1** | One entry per line | ✅ Full | `--oneline` |
| **-,** | Print file sizes grouped with thousands separator | ❌ Not supported | macOS-specific |
| **--sort=WORD** | Sort by specified field (name/size/time/etc) | ✅ Full | `--sort=WORD` |
| **--time=WORD** | Time field to use (atime/ctime/mtime/etc) | ✅ Full | `--time=WORD` |
| **--time-style=STYLE** | Time format style | ✅ Full | `--time-style=STYLE` |
| **--indicator-style=STYLE** | Type indicators style | ✅ Full | `--classify` |
| **--group-directories-first** | List directories before files | ✅ Full | `--group-directories-first` |
| **--group-directories-last** | List directories after files | ✅ Full | `--group-directories-last` |
| **--hide=PATTERN** | Don't list files matching pattern | ✅ Full | `--ignore-glob` |

## Summary

| Status | Count |
|--------|-------|
| ✅ Full Support | 35 |
| ⚠️ Partial Support | 2 (-@, -h) |
| ❌ Not Supported | 26 |

## Partial Support Details

### -@ (Extended Attributes)
The `--extended` flag in eza only works when combined with `-l` (long format).

### -h (Human Readable)
eza_ls matches ls behavior:
- **Default**: Adds `--bytes` (numeric bytes, like `ls`)
- **-h**: Omits `--bytes` (human-readable, like `ls -h`)

Example:
```
$ eza_ls -l file     # shows: 9,356 bytes
$ eza_ls -lh file    # shows: 9.4K
```
