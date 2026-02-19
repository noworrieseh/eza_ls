#!/bin/bash
# Test script to verify eza_ls handles flag combinations consistently
# and that each flag has an effect (coverage tests)

TESTS_PASSED=0
TESTS_FAILED=0
TEST_DIR="/usr/local/bin"

BIN=./eza_ls

run_test() {
    local flags1="$1"
    local flags2="$2"
    local test_name="$3"

    output1=$($BIN $flags1 "$TEST_DIR" 2>&1 | head -20)
    output2=$($BIN $flags2 "$TEST_DIR" 2>&1 | head -20)

    if [[ "$output1" == "$output2" ]]; then
        echo "✓ PASS: $test_name"
        ((TESTS_PASSED++))
    else
        echo "✗ FAIL: $test_name"
        echo "  Flags 1: '$flags1'"
        echo "  Flags 2: '$flags2'"
        ((TESTS_FAILED++))
    fi
}

run_coverage() {
    local flag="$1"
    local expected_arg="$2"
    local test_name="$3"

    output=$(bash -x $BIN $flag "$TEST_DIR" 2>&1 | grep "exec eza")

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

echo "Testing eza_ls flag consistency"
echo "==============================="
echo

echo "=== Consistency Tests ==="
echo

echo "--- Same flags (sanity check) ---"
run_test "-l" "-l" "l = l"
run_test "-a" "-a" "a = a"
run_test "-r" "-r" "r = r"
run_test "-S" "-S" "S = S"

echo
echo "--- Order independence: -al vs -la ---"
run_test "-al" "-la" "-al = -la"
run_test "-al -S" "-alS" "-al -S = -alS"
run_test "-la -S" "-laS" "-la -S = -laS"
run_test "-alS" "-laS" "-alS = -laS"

echo
echo "--- Order independence: -S and -r ---"
run_test "-lS -r" "-lSr" "-lS -r = -lSr"
run_test "-l -S -r" "-l -Sr" "-l -S -r = -l -Sr"
run_test "-lSr" "-lS -r" "-lSr = -lS -r"

echo
echo "--- Order independence: -r and -S with other flags ---"
run_test "-lra" "-arl" "-lra = -arl"
run_test "-arl" "-ral" "-arl = -ral"
run_test "-lart" "-latr" "-lart = -latr"
run_test "-lart -S" "-lartS" "-lart -S = -lartS"

echo
echo "--- Three+ flag combinations ---"
run_test "-lASr" "-ASrl" "-lASr = -ASrl"
run_test "-laSr" "-aSrl" "-laSr = -aSrl"
run_test "-lart -S -r" "-lart -Sr" "three flags with -r"

echo
echo "--- Size sort behavior ---"
run_test "-S -r" "-Sr" "-S -r = -Sr"
run_test "-r -S" "-rS" "-r -S = -rS"
run_test "-lS -r" "-lSr" "lS -r = lSr"
run_test "-lSrS" "-lS -rS" "double S and r"

echo
echo "--- Verify -S adds reverse (largest first) ---"
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
echo "=== Coverage Tests ==="
echo

echo "--- Display flags ---"
run_coverage "-1" "--oneline" "-1 adds --oneline"
run_coverage "-l" "--long" "-l adds --long"
run_coverage "-C" "--grid" "-C adds --grid"
run_coverage "-x" "--across" "-x adds --across"
run_coverage "-R" "--recurse" "-R adds --recurse"
run_coverage "-a" "--all" "-a adds --all"
run_coverage "-A" "--almost-all" "-A adds --almost-all"

echo
echo "--- Sort flags ---"
run_coverage "-r" "--reverse" "-r adds --reverse"
run_coverage "-S" "--sort=size" "-S adds --sort=size"
run_coverage "-t" "--sort=modified" "-t adds --sort=modified"
run_coverage "-X" "--sort=extension" "-X adds --sort=extension"

echo
echo "--- Combined flags ---"
run_coverage "-la" "--long" "-la adds --long"
run_coverage "-al" "--long" "-al adds --long"
run_coverage "-lS" "--sort=size" "-lS adds --sort=size"
run_coverage "-lSr" "--sort=size" "-lSr adds --sort=size"

echo
echo "--- Additional display/info flags ---"
run_coverage "-i" "--inode" "-i adds --inode"
run_coverage "-s" "--blocksize" "-s adds --blocksize"
run_coverage "-n" "--numeric" "-n adds --numeric"
run_coverage "-o" "--octal-permissions" "-o adds --octal-permissions"
run_coverage "-Z" "--context" "-Z adds --context"
run_coverage "-g" "--group" "-g adds --group"
run_coverage "-H" "--links" "-H adds --links"

echo
echo "--- Time-related flags ---"
run_coverage "-u" "--accessed" "-u adds --accessed"
run_coverage "-U" "--created" "-U adds --created"
run_coverage "-c" "--time=changed" "-c adds --time=changed"
run_coverage "-m" "--modified" "-m adds --modified"

echo
echo "--- Filter flags ---"
run_coverage "-d" "--treat-dirs-as-files" "-d adds --treat-dirs-as-files"
run_coverage "-f" "--only-files" "-f adds --only-files"
run_coverage "-I" "--ignore-glob" "-I adds --ignore-glob"

echo
echo "--- Classification flags ---"
run_coverage "-F" "--classify" "-F adds --classify"
run_coverage "-p" "--classify" "-p adds --classify"

echo
echo "--- Binary/bytes flags ---"
run_coverage "-B" "--bytes" "-B adds --bytes"
run_coverage "-k" "--binary" "-k adds --binary"

echo
echo "--- Long options ---"
run_coverage "--group-directories-first" "--group-directories-first" "--group-directories-first"
run_coverage "--group-directories-last" "--group-directories-last" "--group-directories-last"
run_coverage "--show-all" "--all" "--show-all adds --all"
run_coverage "--color=auto" "--colour=auto" "--color=auto adds --colour=auto"
run_coverage "--color=never" "--colour=never" "--color=never adds --colour=never"
run_coverage "--sort=name" "--sort=name" "--sort=name"
run_coverage "--sort=time" "--sort=modified" "--sort=time adds --sort=modified"
run_coverage "--time=accessed" "--accessed" "--time=accessed adds --accessed"
run_coverage "--time=created" "--created" "--time=created adds --created"
run_coverage "--time-style=long-iso" "--time-style=long-iso" "--time-style=long-iso"
run_coverage "--time-style=iso" "--time-style=iso" "--time-style=iso"
run_coverage "--indicator-style=slash" "--classify" "--indicator-style=slash adds --classify"
run_coverage "--indicator-style=classify" "--classify" "--indicator-style=classify adds --classify"

echo
echo "--- Debug --eza flag ---"
output=$($BIN --eza -l /usr/local/bin 2>&1)
if [[ "$output" == "eza --long /usr/local/bin --bytes" ]]; then
    echo "✓ PASS: --eza prints command"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: --eza prints command"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

output=$($BIN --eza -lS /usr/local/bin 2>&1)
if [[ "$output" == "eza --long /usr/local/bin --sort=size --reverse --bytes" ]]; then
    echo "✓ PASS: --eza with -lS"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: --eza with -lS"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

echo
echo "--- Argument-consuming flags (no stdin) ---"
output=$($BIN --eza -b /usr/local/bin 2>&1)
if [[ "$output" == "eza /usr/local/bin --bytes" ]]; then
    echo "✓ PASS: -b (escape) works - no stdin read"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: -b should not read from stdin"
    ((TESTS_FAILED++))
fi

output=$($BIN --eza --block-size=K /usr/local/bin 2>&1)
if [[ "$output" == "eza --binary /usr/local/bin --bytes" ]]; then
    echo "✓ PASS: --block-size=K adds --binary"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: --block-size=K should add --binary"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

output=$($BIN --eza -I "*.log" /usr/local/bin 2>&1)
if [[ "$output" == "eza --ignore-glob=*.log /usr/local/bin --bytes" ]]; then
    echo "✓ PASS: -I *.log works (no stdin)"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: -I *.log should not read from stdin"
    ((TESTS_FAILED++))
fi

output=$($BIN --eza -w 80 /usr/local/bin 2>&1)
if [[ "$output" == "eza --width=80 /usr/local/bin --bytes" ]]; then
    echo "✓ PASS: -w 80 works (no stdin)"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: -w 80 should not read from stdin"
    ((TESTS_FAILED++))
fi

output=$($BIN --eza -lh /usr/local/bin 2>&1)
if [[ "$output" == "eza --long /usr/local/bin" ]]; then
    echo "✓ PASS: -h disables --bytes"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: -h should disable --bytes"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

echo
echo "--- No directory argument (defaults to .) ---"
output=$($BIN --eza -l 2>&1)
if [[ "$output" == "eza --long . --bytes" ]]; then
    echo "✓ PASS: no dir defaults to ."
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: no dir should default to ."
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

output=$($BIN --eza -lt 2>&1)
if [[ "$output" == "eza --long --sort=modified . --bytes" ]]; then
    echo "✓ PASS: -lt no dir defaults to ."
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: -lt no dir should default to ."
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

echo
echo "--- Edge cases ---"

output=$($BIN --eza -- /tmp 2>&1)
if [[ "$output" == "eza -- /tmp --bytes" ]]; then
    echo "✓ PASS: -- separator passes through"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: -- separator should pass through"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

output=$($BIN --eza -l -- /tmp 2>&1)
if [[ "$output" == "eza --long -- /tmp --bytes" ]]; then
    echo "✓ PASS: -- after flags"
    ((TESTS_PASSED++))
else
    echo "✗ FAIL: -- after flags"
    echo "  Got: $output"
    ((TESTS_FAILED++))
fi

echo
echo "==============================="
echo "Results: $TESTS_PASSED passed, $TESTS_FAILED failed"

if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
fi
exit 0
