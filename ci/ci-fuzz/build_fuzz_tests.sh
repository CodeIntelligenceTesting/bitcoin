sh '''
set -eu
# Log in
./${CICTL} login -u "${CIFUZZ_CREDS_USR}" -p "${CIFUZZ_CREDS_PSW}"

# Start Fuzzing
LOG_FILE="start-$(basename "asmap_ci").logs"
./${CICTL} start_fuzzing                 --daemon_listen_address="${FUZZING_SERVICE_URL}"                 --project_name="${PROJECT}"                 --campaign_name="${CAMPAIGN}"                 --git_branch="${GIT_BRANCH#*/}"                 | tee "${LOG_FILE}"
'''