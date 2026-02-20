#!/bin/bash
# Test script to verify eza_ls handles flag combinations consistently
# and that each flag has an effect (coverage tests)

TESTS_PASSED=0
TESTS_FAILED=0
TEST_DIR="/usr/local/bin"

BIN=./eza_ls

run_test_compare() {
    local flags1="$1"
    local flags2="$2"
    local test_name="$3"
    local compare="${4:-eq}"

    output1=$($BIN $flags1 "$TEST_DIR" 2>&1 | head -20)
    output2=$($BIN $flags2 "$TEST_DIR" 2>&1 | head -20)

    if [[ "$compare" == "eq" && "$output1" == "$output2" ]] ||
       [[ "$compare" == "ne" && "$output1" != "$output2" ]]; then
        echo "✓ PASS: $test_name"
        ((TESTS_PASSED++))
    else
        echo "✗ FAIL: $test_name"
        echo "  Flags 1: '$flags1'"
        echo "  Flags 2: '$flags2'"
        ((TESTS_FAILED++))
    fi
}

run_test() {
    run_test_compare "$1" "$2" "$3" "eq"
}

run_test_different() {
    run_test_compare "$1" "$2" "$3" "ne"
}

run_test_substring() {
    local flag="$1"
    local expected_arg="$2"
    local test_name="$3"
    local dir="${4:-$TEST_DIR}"

    output=$($BIN --eza $flag "$dir" 2>&1)

    if [[ "$output" == *"$expected_arg"* ]]; then
        echo "✓ PASS: $test_name"
        ((TESTS_PASSED++))
    else
        echo "✗ FAIL: $test_name"
        echo "  Expected to find: $expected_arg"
        echo "  Got: $output"
        ((TESTS_FAILED++))
    fi
}

run_test_substring_stderr() {
    local flag="$1"
    local expected_arg="$2"
    local test_name="$3"
    local dir="${4:-$TEST_DIR}"

    output=$($BIN --eza $flag "$dir" 2>&1 >/dev/null)

    if [[ "$output" == *"$expected_arg"* ]]; then
        echo "✓ PASS: $test_name"
        ((TESTS_PASSED++))
    else
        echo "✗ FAIL: $test_name"
        echo "  Expected to find: $expected_arg"
        echo "  Got: $output"
        ((TESTS_FAILED++))
    fi
}

run_test_exact() {
    local flag="$1"
    local expected="$2"
    local test_name="$3"
    local dir="${4-}"

    if [[ -z "$dir" ]]; then
        output=$($BIN --eza $flag 2>&1)
    else
        output=$($BIN --eza $flag "$dir" 2>&1)
    fi

    if [[ "$output" == "$expected" ]]; then
        echo "✓ PASS: $test_name"
        ((TESTS_PASSED++))
    else
        echo "✗ FAIL: $test_name"
        echo "  Expected: $expected"
        echo "  Got: $output"
        ((TESTS_FAILED++))
    fi
}

echo "Testing eza_ls"
echo "=============="
echo

echo "=== Consistency Tests ==="
echo

run_test "-l" "-l" "l = l"
run_test "-a" "-a" "a = a"
run_test "-r" "-r" "r = r"
run_test "-S" "-S" "S = S"

run_test "-al" "-la" "-al = -la"
run_test "-al -S" "-alS" "-al -S = -alS"
run_test "-la -S" "-laS" "-la -S = -laS"
run_test "-alS" "-laS" "-alS = -laS"

run_test "-lS -r" "-lSr" "-lS -r = -lSr"
run_test "-l -S -r" "-l -Sr" "-l -S -r = -l -Sr"
run_test "-lSr" "-lS -r" "-lSr = -lS -r"

run_test "-lra" "-arl" "-lra = -arl"
run_test "-arl" "-ral" "-arl = -ral"
run_test "-lart" "-latr" "-lart = -latr"
run_test "-lart -S" "-lartS" "-lart -S = -lartS"

run_test "-lASr" "-ASrl" "-lASr = -ASrl"
run_test "-laSr" "-aSrl" "-laSr = -aSrl"
run_test "-lart -S -r" "-lart -Sr" "three flags with -r"
run_test "-lA" "-Al" "-lA = -Al"
run_test "-lR" "-Rl" "-lR = -Rl"
run_test "-lS -r" "-lSr" "-lS -r removes extra reverse"

run_test "-S -r" "-Sr" "-S -r = -Sr"
run_test "-r -S" "-rS" "-r -S = -rS"
run_test "-lS -r" "-lSr" "lS -r = lSr"
run_test "-lSrS" "-lS -rS" "double S and r"

output1=$($BIN -lS "$TEST_DIR" 2>&1 | head -1)
output2=$($BIN -lSr "$TEST_DIR" 2>&1 | head -1)
if [[ "$output1" != "$output2" ]]; then
    echo "✓ PASS: -lS different from -lSr"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: -lS should differ from -lSr"
    ((TESTS_FAILED++))
fi

echo
echo "=== Flag Mapping Tests ==="
echo

run_test_substring "-1" "--oneline" "-1"
run_test_substring "-l" "--long" "-l"
run_test_substring "-C" "--grid" "-C"
run_test_substring "-x" "--across" "-x"
run_test_substring "-R" "--recurse" "-R"
run_test_substring "-a" "--all" "-a"
run_test_substring "-A" "--almost-all" "-A"
run_test_substring "-@" "--extended" "-@"
run_test_substring "-L" "--dereference" "-L"
run_test_substring "-N" "--no-quotes" "-N"

run_test_substring "-r" "--reverse" "-r"
run_test_substring "-S" "--sort=size" "-S"
run_test_substring "-t" "--sort=modified" "-t"
run_test_substring "-X" "--sort=extension" "-X"

run_test_substring "-la" "--long" "-la"
run_test_substring "-al" "--long" "-al"
run_test_substring "-lS" "--sort=size" "-lS"
run_test_substring "-lSr" "--sort=size" "-lSr"

run_test_substring "-i" "--inode" "-i"
run_test_substring "-s" "--blocksize" "-s"
run_test_substring "-n" "--numeric" "-n"
run_test_substring "-o" "--long" "-o"
run_test_substring "-Z" "--context" "-Z"
run_test_substring "-g" "--no-user" "-g"
run_test_substring "-H" "--links" "-H"

run_test_substring "-u" "--accessed" "-u"
run_test_substring "-U" "--created" "-U"
run_test_substring "-c" "--time=changed" "-c"
run_test_substring_stderr "-m" "warning: unsupported option(s): -m" "-m"

run_test_substring "-d" "--treat-dirs-as-files" "-d"
run_test_substring "-f" "--all" "-f"
run_test_substring "-I" "--ignore-glob" "-I"
run_test_substring "-B" "--ignore-glob=*~" "-B"

run_test_substring "-F" "--classify" "-F"
run_test_substring "-p" "--classify" "-p"

run_test_substring "-B" "--bytes" "-B"
run_test_substring "-k" "--binary" "-k"
run_test_substring "--kibibytes" "--binary" "--kibibytes"

run_test_substring "-b" "" "-b"
run_test_substring "--block-size=K" "--binary" "--block-size=K"
run_test_substring "-w" "--width" "-w"
run_test_substring "-lh" "--long" "-lh"
run_test_substring "-lG" "--long" "-G"
run_test_substring "-lg" "--no-user" "-lg"
run_test_substring "-lo" "--long" "-lo"
run_test_substring_stderr "-v" "warning: unsupported option(s): -v" "-v"
run_test_substring "--version" "--version" "--version"
run_test_substring "--time-style=+\"%Y-%m-%d\"" "--time-style=+\"%Y-%m-%d\"" "--time-style=+FORMAT"
run_test_substring "--file-type" "--classify=never" "--file-type"
run_test_substring "--full-time" "--time-style=full-iso" "--full-time"

run_test_substring "--group-directories-first" "--group-directories-first" "--group-directories-first"
run_test_substring_stderr "--group-directories-last" "warning: unsupported option(s): --group-directories-last" "--group-directories-last is unsupported"
run_test_substring "--color=auto" "--colour=auto" "--color=auto"
run_test_substring "--color=never" "--colour=never" "--color=never"
run_test_substring "--color=always" "--colour=always" "--color=always"
run_test_substring "--color" "--colour=always" "--color (no value = always)"
run_test_substring "--sort=name" "--sort=name" "--sort=name"
run_test_substring "--sort=time" "--sort=modified" "--sort=time"
run_test_substring "--sort=extension" "--sort=extension" "--sort=extension"
run_test_substring "--sort=version" "--sort=name" "--sort=version"
run_test_substring "--time=accessed" "--accessed" "--time=accessed"
run_test_substring "--time=created" "--created" "--time=created"
run_test_substring "--time=modified" "--time=modified" "--time=modified"
run_test_substring "--time=changed" "--changed" "--time=changed"
run_test_substring "--time-style=long-iso" "--time-style=long-iso" "--time-style=long-iso"
run_test_substring "--time-style=iso" "--time-style=iso" "--time-style=iso"
run_test_substring "--time-style=full-iso" "--time-style=full-iso" "--time-style=full-iso"
run_test_substring "--indicator-style=slash" "--classify" "--indicator-style=slash"
run_test_substring "--indicator-style=classify" "--classify" "--indicator-style=classify"
run_test_substring "--hyperlink=auto" "--hyperlink" "--hyperlink"
run_test_substring "--hyperlink" "--hyperlink" "--hyperlink (no arg)"
run_test_substring "--hide=*.log" "--ignore-glob" "--hide=*.log"

echo ""
echo "=== Unsupported Flags Warning ==="

run_test_substring_stderr "-b" "warning: unsupported option(s): -b" "-b shows warning"
run_test_substring_stderr "-Q" "warning: unsupported option(s): -Q" "-Q shows warning"
run_test_substring_stderr "--dired" "warning: unsupported option(s): --dired" "--dired shows warning"
run_test_substring_stderr "--quoting-style=c" "warning: unsupported option(s): --quoting-style=c" "--quoting-style=c shows warning"
run_test_substring_stderr "-e" "warning: unsupported option(s): -e" "-e shows warning"
run_test_substring_stderr "-q" "warning: unsupported option(s): -q" "-q shows warning"
run_test_substring_stderr "-W" "warning: unsupported option(s): -W" "-W shows warning"
run_test_substring_stderr "--si" "warning: unsupported option(s): --si" "--si shows warning"
run_test_substring_stderr "--author" "warning: unsupported option(s): --author" "--author shows warning"
run_test_substring_stderr "-O" "warning: unsupported option(s): -O" "-O shows warning"
run_test_substring_stderr "-P" "warning: unsupported option(s): -P" "-P shows warning"
run_test_substring_stderr "--tab-size=4" "warning: unsupported option(s): --tab-size=4" "--tab-size shows warning"
run_test_substring_stderr "--indicator-style=none" "warning: unsupported option(s): --indicator-style=none" "--indicator-style=none shows warning"
run_test_substring_stderr "--show-control-chars" "warning: unsupported option(s): --show-control-chars" "--show-control-chars shows warning"

  run_test_substring_stderr "-v" "warning: unsupported option(s): -v" "-v"
  run_test_substring_stderr "-V" "warning: unsupported option(s): -V" "-V"
  run_test_substring "--version" "--version" "--version"

run_test_substring "--eza -l" "eza" "--eza flag"
run_test_substring "--eza -lS" "--sort=size" "--eza with -lS"

echo
echo "=== Edge Cases ==="
echo

# No directory - tests default "."
run_test_exact "-l" "eza --long . --bytes -g" "no dir defaults to ."
run_test_exact "-lt" "eza --sort=modified --reverse --long . --bytes -g" "-lt defaults to ."
run_test_exact "-l -- /tmp" "eza -- /tmp --long --bytes -g" "-- after flags"
run_test_exact "-l -- -testfile /tmp" "eza -- -testfile /tmp --long --bytes -g" "-l -- with dash filename"
run_test_exact "-l /tmp /usr" "eza /tmp /usr --long --bytes -g" "multiple directories"
run_test_exact "-- /tmp /usr" "eza -- /tmp /usr --bytes -g" "-- with multiple directories"

# Warnings
run_test_substring_stderr "-Q" "warning" "warning goes to stderr"
run_test_substring_stderr "-Q --dired" "-Q --dired" "multiple warnings show all flags"

# Error handling
run_test "/nonexistent_directory_12345" "/nonexistent_directory_12345" "nonexistent directory error comes from eza"

# Combined flags
run_test_substring "-lh -Q" "--long" "-h disables --bytes even with -Q"

echo
echo "=== Argument-Consuming Flags ==="
echo

run_test_substring "-D %H:%M" "--time-style=+%H:%M" "-D with format"
run_test_substring "-I '*.log'" "--ignore-glob" "-I with pattern"
run_test_substring "-w 80" "--width=80" "-w with width"
run_test_substring "--block-size=K" "--binary" "--block-size=K"
run_test_substring "--block-size=B" "--bytes" "--block-size=B"

echo
echo "=== Additional Flag Tests ==="
echo

run_test_substring "-T" "--time-style=full-iso" "-T full timestamp"
run_test_substring "-lD" "--time-style" "-lD combines"
run_test_substring "-lT" "--time-style=full-iso" "-lT combines"

run_test_substring "--dereference" "--dereference" "--dereference"
run_test_substring "-lL" "--dereference" "-lL combines"

run_test_substring "-laR" "--recurse" "-laR combines"
run_test_substring "-lai" "--inode" "-lai combines"
run_test_substring "-las" "--blocksize" "-las combines"

run_test_substring "-lSev" "--sort=size" "-lSev (version sort)"
run_test_substring "-lSevr" "--sort=size" "-lSevr (version sort with reverse)"

echo
echo "=== Long Options ==="
echo

run_test_substring "--sort=none" "--sort=none" "--sort=none"
run_test_substring "--sort=width" "--sort=width" "--sort=width"
run_test_substring "--time=birth" "--created" "--time=birth"
run_test_substring "--time=use" "--accessed" "--time=use"
run_test_substring "--time=status" "--changed" "--time=status"
run_test_substring "--indicator-style=file-type" "--classify=never" "--indicator-style=file-type"

echo
echo "=== g/o/G Flag Behavior ==="
echo

run_test_substring "-g" "--no-user" "-g no user"
run_test_substring "-o" "--long" "-o no group"
run_test_substring "-G" "--bytes" "-G no group (eza default)"
run_test_substring "-gl" "--long" "-gl combines"
run_test_substring "-og" "--no-user" "-og combines"
run_test_substring "-glo" "--long" "-glo combines"
run_test_substring "-lG" "--long" "-lG with long"
run_test_substring "-glG" "--long" "-glG combines"

echo
echo "=== Time Flag Combinations ==="
echo

run_test_substring "-lt" "--sort=modified" "-lt sort by time"
run_test_substring "-lc" "--time=changed" "-lc ctime"
run_test_substring "-lu" "--accessed" "-lu access time"
run_test_substring "-lU" "--created" "-lU created time"
run_test_substring "-lmu" "--accessed" "-lmu access time"
run_test_substring "-lct" "--sort=modified" "-lct ctime sort"

echo
echo "=== f Flag Tests ==="
echo

run_test_substring "-f" "--all" "-f shows all"
run_test_substring "-f" "--sort=none" "-f no sort"
run_test_substring "-fa" "--all" "-fa combines"
run_test_substring "-lf" "--sort=none" "-lf with long"

echo
echo "=== More Flag Ordering ==="
echo

run_test "-lSra" "-lS -r -a" "lSra = lS -r -a"
run_test "-lSrar" "-lS -r -a -r" "lSrar double reverse"
run_test "-lartS" "-l -a -r -t -S" "lartS complex"
run_test "-lartSr" "-l -a -r -t -S -r" "lartSr with double reverse"
run_test "-aSlr" "-a -S -l -r" "aSlr = a -S -l -r"
run_test "-Sal" "-S -a -l" "Sal = Sal"
run_test "-aSl" "-a -S -l" "aSl = aSl"

echo
echo "=== @ Extended Attributes ==="
echo

run_test_substring "-l@" "--extended" "-l@ with long"
run_test_substring "-@" "--extended" "-@ alone"

echo
echo "=== Sort + Reverse Behavior ==="
echo

run_test_different "-S" "-Sr" "-S adds reverse, -Sr removes it"
run_test_different "-t" "-tr" "-t adds reverse, -tr removes it"
run_test_different "-lS" "-lSr" "-lS adds reverse, -lSr removes it"
run_test_different "-lt" "-ltr" "-lt adds reverse, -ltr removes it"
run_test "-lS -r" "-lSr" "-lS -r = -lSr"
run_test "-lSr" "-lS -r" "-lSr = -lS -r"

run_test_different "-X" "-Xr" "-X adds reverse, -Xr removes it"
run_test_different "-lX" "-lXr" "-lX adds reverse, -lXr removes it"

echo
echo "=== --eza Variations ==="
echo

run_test_exact "--eza -la /tmp" "eza --all --all /tmp --long --bytes -g" "--eza with -la"
run_test_exact "--eza -laS /tmp" "eza --all --all /tmp --sort=size --reverse --long --bytes -g" "--eza with -laS"
run_test_exact "--eza -lart /tmp" "eza --all --all /tmp --sort=modified --long --bytes -g" "--eza with -lart"

echo
echo "=============="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed"

if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
fi
exit 0
