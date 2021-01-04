#!/bin/sh
export LC_ALL=C

#this script generates a .json config file for each *.cpp file in the directory. 
#It copies the buildFlags from buildflags.json. So to update build flags just change them in the template and (re-)run this script

DIRECTORY=.

for file in "$DIRECTORY"/*.cpp; do
    filename=${file##*/} #this is the name of the C++ file without the starting "./", for example block.cpp
    test_name=${filename%.*} #this is the name of the test, the file extension is removed for this: block.cpp -> block
    parent_path=".code-intelligence/fuzz_targets/" #the path of the fuzz targets must be hardcoded in the JSON file, relative to project root
    api="${parent_path}${filename}"
    json_file_name=${file}.json #name of the newly generated json file. Append .json to the name of the C++ file.
    campaign_file_name=../campaigns/$test_name.json
    echo "Generating $json_file_name"
    jq -j --arg t_name $test_name --arg api $api  '{name: $t_name,displayName: $t_name,buildFlags: .buildFlags,cApi: {api: {relativePath: $api}}}' buildflags.json > $json_file_name
    
    #create config files for campaigns
    jq -j --arg t_name $test_name '{name: $t_name,displayName: $t_name,maxRunTime: .maxRunTime,fuzzTargets: [$t_name],fuzzerRunConfigurations: .fuzzerRunConfigurations}' ../campaigns/options.json > $campaign_file_name
done
