#! /bin/bash

set -e

erlc road.erl
erl -noshell -run road main road.txt
