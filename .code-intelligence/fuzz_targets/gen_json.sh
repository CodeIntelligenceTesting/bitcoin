#!/bin/sh

#this script generates a .json config file for each *.cpp file in the directory. 
#It copies the buildFlags from template.cpp.json. So to update build flags just change them in the template and (re-)run this script

DIRECTORY=.

for file in $DIRECTORY/*.cpp; do
    filename=${file##*/}
    test_name=${filename%.*}
    parent_path=".code-intelligence/fuzz_targets/"
    api="${parent_path}${filename}"
    json_file_name=${file}.json
    echo "Generating $json_file_name"
    jq --arg t_name $test_name --arg api $api  '{name: $t_name,displayName: $t_name,buildFlags: .buildFlags,cApi: {api: {relativePath: $api}}}' template.cpp.json > $json_file_name
done
