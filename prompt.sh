#!/bin/bash
clear
set -x
set -e
ls my_contract/src
ls my_contract/tests
cat my_contract/src/lib.cairo
cat my_contract/src/min_nft.cairo
cat my_contract/tests/min_test.cairo
cat my_contract/Scarb.toml