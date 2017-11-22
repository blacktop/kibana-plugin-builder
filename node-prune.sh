#!/bin/sh

find node_modules \( -name '__tests__' -o \
-name 'test' -o \
-name 'tests' -o \
-name 'powered-test' -o \
-name 'docs' -o \
-name 'doc' -o \
-name '.idea' -o \
-name '.vscode' -o \
-name 'website' -o \
-name 'images' -o \
-name 'assets' -o \
-name 'example' -o \
-name 'examples' -o \
-name 'coverage'-o \
-name '.nyc_output' -o \
-name "*.md" -o \
-name "*.ts" -o \
-name "*.jst" -o \
-name "*.coffee" -o \
-name "*.tgz" \) -exec rm -rf {} \;
