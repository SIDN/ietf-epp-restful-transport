#! /usr/bin/env bash

IN_FILE="draft-epp-restful-transport"
TMP_FILE="out.xml"
BUILD_DIR="docs"

mmark "$IN_FILE.md" > "$BUILD_DIR/$TMP_FILE" &&\
 xml2rfc --v3 --text --o "$BUILD_DIR/$IN_FILE.txt" "$BUILD_DIR/$TMP_FILE" &&\
 xml2rfc --v3 --html --o "$BUILD_DIR/$IN_FILE.html" "$BUILD_DIR/$TMP_FILE" &&\
 rm -f "$BUILD_DIR/$TMP_FILE"

 # xml2rfc --v3 --pdf --o "$BUILD_DIR/$IN_FILE.pdf" "$BUILD_DIR/$TMP_FILE" &&\
