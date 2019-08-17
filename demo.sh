#!/bin/sh

swiftc \
  ./core/simple-redux.swift \
  ./middlewares/logger.swift \
  ./middlewares/thunk.swift \
  ./main.swift \
  -o out

./out
