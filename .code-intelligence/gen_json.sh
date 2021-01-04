#!/bin/sh
export LC_ALL=C

#this script generates a .json config file for each *.cpp file in the directory. 
#It copies the buildFlags from buildflags.json. So to update build flags just change them in the template and (re-)run this script

FUZZ_TARGET_DIRECTORY=./fuzz_targets
CAMPAIGN_DIRECTORY=./campaigns

#iterate over all C++ files in .code-intelligence/fuzz_targets
for file in "$FUZZ_TARGET_DIRECTORY"/*.cpp; do

    file_name=${file##*/} #this is the name of the C++ file without the starting "./", for example block.cpp
    test_name=${file_name%.*} #this is the name of the test, the file extension is removed for this: block.cpp -> block
    
    parent_path=".code-intelligence/fuzz_targets/" #the path of the fuzz targets must be hardcoded in the JSON file, relative to project root
    api="${parent_path}${file_name}"

    path_to_target_config_file=${FUZZ_TARGET_DIRECTORY}/${test_name}.cpp.json #name of the newly generated json file. Append .json to the name of the C++ file.
    echo "Generating $path_to_target_config_file"
    jq -j --arg t_name $test_name --arg api $api  '{name: $t_name,displayName: $t_name,buildFlags: .buildFlags,cApi: {api: {relativePath: $api}}}' conf.json > $path_to_target_config_file
    
    #create config files for campaigns
    path_to_campaign_config_file=${CAMPAIGN_DIRECTORY}/${test_name}.json
    echo "Generating $path_to_campaign_config_file"
    jq -j --arg t_name $test_name '{name: $t_name,displayName: $t_name,maxRunTime: .maxRunTime,fuzzTargets: [$t_name],fuzzerRunConfigurations: .fuzzerRunConfigurations}' conf.json > $path_to_campaign_config_file
done
echo "All config files generated."
