#!/bin/zsh

alias swiftlint="/opt/homebrew/bin/swiftlint"

echo $PWD

if which swiftlint >/dev/null; 
then 
swiftlint --path ./Sources/* && swiftlint --path ./Modules/*
else 
echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
