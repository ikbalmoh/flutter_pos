#!/bin/bash 
VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //') 
echo $VERSION