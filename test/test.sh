#!/usr/bin/env bash

set -eou pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SANITIZE_BIN_PATH="${SCRIPT_DIR}/../src/bin/sanitize"
SEPARATOR="----------------------------------------------------------"

function run_test {
    local test_name
    local config_path

    test_name=$1
    config_path=$2

    export SANITIZE_CONFIG_DIR="${config_path}"

    local actual_result
    local expected_result
    actual_result=$("${SANITIZE_BIN_PATH}" < \
        "${SCRIPT_DIR}/${test_name}/input.txt" )
    expected_result=$(cat "${SCRIPT_DIR}/${test_name}/output.txt")

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

function test_01_with_config {
    local test_name
    local config_path

    test_name="01-with-config"
    config_path="${SCRIPT_DIR}/../src/etc"

    if ! run_test "${test_name}" "${config_path}"; then
        return 1
    fi

    return 0
}

function test_02_without_config {
    local test_name
    local config_path

    test_name="02-without-config"
    config_path="${SCRIPT_DIR}"

    if ! run_test "${test_name}" "${config_path}"; then
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
    if ! test_01_with_config; then
        result=1
    fi
    if ! test_02_without_config; then
        result=1
    fi

    if [[ "${result}" -eq 0 ]]; then
        return 0
    fi
    return ${result}
}

main
exit $?
