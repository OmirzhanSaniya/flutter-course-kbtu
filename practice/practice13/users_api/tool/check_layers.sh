#!/usr/bin/env bash
# Practice 13: the layer rule. Prints NOTHING when the rule holds.
# Run before every commit:  bash tool/check_layers.sh
# 1. http only in core/api and in *_repository.dart
grep -rl "package:http" lib/ | grep -v -e core/api -e _repository.dart
# 2. no Material in a model, a repository or the api layer
grep -rl "package:flutter/material" lib/ | grep -e _model.dart -e _repository.dart -e core/api
exit 0
