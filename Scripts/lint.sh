#!/bin/zsh

arch=`{uname -m}`

if [ $arch = "arm64" ]
then
    alias swiftlint="/opt/homebrew/bin/swiftlint"
else
    alias swiftlint="/usr/local/bin/swiftlint"
fi

echo $PWD

if which swiftlint >/dev/null; 
then 
swiftlint --path ./Sources/* && swiftlint --path ./Modules/*
else 
echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
