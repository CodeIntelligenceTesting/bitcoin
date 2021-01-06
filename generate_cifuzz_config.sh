#!/bin/sh
export LC_ALL=C

#this script generates a fuzz target config file in FUZZ_TARGET_CONFIG_DIRECTORY and a campaign config file in CAMPAIGN_DIRECTORY
#for each *.cpp file in the FUZZ_TARGET_DIRECTORY. 
#. To update build flags just change them in the template and (re-)run this script

FUZZ_TARGET_DIRECTORY=src/test/fuzz #directory to be searched for fuzz target source files (input location)
FUZZ_TARGET_CONFIG_DIRECTORY=.code-intelligence/fuzz_targets #directory in which the fuzz target configurations will be created (output location)
CAMPAIGN_DIRECTORY=.code-intelligence/campaigns #directory in which the fuzz campaign configurations will be created (output location)

#copy the manually configured part of the travis config file to .travis.yml.
#Later an entry for every fuzz target will be appended at the file end.
cat .code-intelligence/bitcoin_travis.yml > .travis.yml

#iterate over all C++ files in the FUZZ_TARGET_DIRECTORY
for file in "$FUZZ_TARGET_DIRECTORY"/*.cpp; do

    file_name=${file##*/} #this is the name of the C++ file without the starting "./", for example block.cpp
    test_name=${file_name%.*} #this is the name of the test, the file extension is removed for this: block.cpp -> block
    
    api="./${FUZZ_TARGET_DIRECTORY}/${file_name}" #the path of the fuzz targets must be hardcoded in the JSON file, relative to project root

    path_to_target_config_file=${FUZZ_TARGET_CONFIG_DIRECTORY}/${test_name}.cpp.json #name of the newly generated json file. Append .json to the name of the C++ file.
    echo "Generating $path_to_target_config_file"
    jq -j --arg t_name $test_name --arg api $api  '{name: $t_name,displayName: $t_name,buildFlags: .buildFlags,cApi: {api: {relativePath: $api}}}' .code-intelligence/ci_config.json > $path_to_target_config_file
    
    #create config files for campaigns
    path_to_campaign_config_file=${CAMPAIGN_DIRECTORY}/${test_name}.json
    echo "Generating $path_to_campaign_config_file"
    jq -j --arg t_name $test_name '{name: $t_name,displayName: $t_name,maxRunTime: .maxRunTime,fuzzTargets: [$t_name],fuzzerRunConfigurations: .fuzzerRunConfigurations}' .code-intelligence/ci_config.json > $path_to_campaign_config_file

    #generate a travis CI/CD script for every fuzz target
    echo "Generating ci/ci-fuzz/${test_name}.sh"
    sed "s/TARGET_NAME/${test_name}/g" .code-intelligence/cicd_script_template.sh > ci/ci-fuzz/${test_name}.sh
    
    #Append a entry to the .travis.yml file
    echo "Append entry for ${test_name} to .travis.yml"
    sed "s/TARGET_NAME/${test_name}/g" .code-intelligence/travis_snippet >> .travis.yml
done
echo "All config files generated."
