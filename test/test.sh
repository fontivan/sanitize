#!/usr/bin/env bash

set -eou pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SANITIZE_BIN_PATH="${SCRIPT_DIR}/../src/bin/sanitize"
INPUT="input.txt"
OUTPUT="output.txt"
SEPARATOR="----------------------------------------------------------"

function check_test_result {
    local test_name
    local actual_result
    local expected_result

    test_name=$1
    actual_result=$2
    expected_result=$3

    if ! [[ "${actual_result}" == "${expected_result}" ]]; then
        echo "${SEPARATOR}"
        echo "Test '${test_name}' failed!"
        echo "${SEPARATOR}"
        echo "Actual result"
        echo "${SEPARATOR}"
        echo "${actual_result}"
        echo "${SEPARATOR}"
        echo "Expected result"
        echo "${SEPARATOR}"
        echo "${expected_result}"
        echo "${SEPARATOR}"
        echo ""
        return 1
    else
        echo "${SEPARATOR}"
        echo "Test '${test_name}' passed!"
        echo "${SEPARATOR}"
        echo ""
    fi
    return 0
}

function test_with_config {
    local test_name
    test_name="test-with-config"

    export SANITIZE_CONFIG_DIR="${SCRIPT_DIR}/../src/etc"

    local actual_result
    local expected_result
    actual_result=$("${SANITIZE_BIN_PATH}" < \
        "${SCRIPT_DIR}/${test_name}-${INPUT}" )
    expected_result=$(cat "${SCRIPT_DIR}/${test_name}-${OUTPUT}")

    if ! check_test_result \
        "${test_name}" \
        "${actual_result}" \
        "${expected_result}"; then
        return 1
    fi

    return 0
}

function test_without_config {
    local test_name
    test_name="test-without-config"

    export SANITIZE_CONFIG_DIR="${SCRIPT_DIR}"

    local actual_result
    local expected_result
    actual_result=$("${SANITIZE_BIN_PATH}" < \
        "${SCRIPT_DIR}/${test_name}-${INPUT}" )
    expected_result=$(cat "${SCRIPT_DIR}/${test_name}-${OUTPUT}")

    if ! check_test_result \
        "${test_name}" \
        "${actual_result}" \
        "${expected_result}"; then
        return 1
    fi

    return 0
}

function main {
    echo ""
    echo "${SEPARATOR}"
    echo "Starting sanitize tests"
    echo "${SEPARATOR}"
    echo ""

    local result
    result=0
    if ! test_with_config; then
        result=1
    fi
    if ! test_without_config; then
        result=1
    fi

    if [[ "${result}" -eq 0 ]]; then
        return 0
    fi
    return ${result}
}

main
