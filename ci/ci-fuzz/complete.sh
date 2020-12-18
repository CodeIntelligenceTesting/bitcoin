#!/bin/sh
export LC_ALL=C
# Display name of the project.
PROJECT='bitcoin'
# Display name of the campaign to be run.
CAMPAIGN='asmap_ci'
# Address of the fuzzing service
FUZZING_SERVICE_URL='grpc-api.demo.code-intelligence.com:443'
# Address of the fuzzing web interface
WEB_APP_URL='app.demo.code-intelligence.com'

# Credentials for accessing the fuzzing service
#CIFUZZ_CREDS=credentials('CIFUZZ_CREDS')
CICTL='cictl-2.16.3-389-gf8e52f113-linux';
CICTL_VERSION='2.16.3-389-gf8e52f113';
CICTL_SHA256SUM='e89234fe8a5c7c7b336815f975de7faf76a3420a40c51a7b8f396372f89ab9c1';
CICTL_URL='https://s3.eu-central-1.amazonaws.com/public.code-intelligence.com/cictl/cictl-2.16.3-389-gf8e52f113-linux';
FINDINGS_TYPE='CRASH';
TIMEOUT='900'
#Email that will receive reports if any finding is encountered.
#CI_FUZZING_REPORT_EMAIL_RECIPIENT='schrewe@code-intelligence.com'
GIT_BRANCH='master'

export PROJECT
export CAMPAIGN
export FUZZING_SERVICE_URL
export ICTL
export CICTL_VERSION
export CICTL_SHA256SUM
export CICTL_URL
export FINDINGS_TYPE
export TIMEOUT
export GIT_BRANCH

date

set -eu
# Download cictl if it doesn't exist already
if [ ! -f "${CICTL}" ]; then
 wget "${CICTL_URL}" -O "${CICTL}"
fi
# Verify the checksum
echo "${CICTL_SHA256SUM} ${CICTL}" | sha256sum --check

# Make it executable
chmod +x "${CICTL}"

date

set -eu
# Log in
#./${CICTL} login -u "${CIFUZZ_CREDS_USR}" -p "${CIFUZZ_CREDS_PSW}"
./${CICTL} login -t "${CIFUZZ_TOKEN}"
# Start Fuzzing
LOG_FILE="start-$(basename "asmap_ci").logs"

date
./${CICTL} start_fuzzing --daemon_listen_address="${FUZZING_SERVICE_URL}" --project_name="${PROJECT}" --campaign_name="${CAMPAIGN}" --git_branch="${GIT_BRANCH#*/}" | tee "${LOG_FILE}"

set -eu
# Get the name of the started campaign run from the logs
LOG_FILE="start-$(basename "asmap_ci").logs"
LINE=$(grep "display_name:" "${LOG_FILE}")
CAMPAIGN_RUN=${LINE#*"display_name: "}

date
sleep 30

# Monitor Fuzzing
./${CICTL} monitor_campaign_run \
--daemon_listen_address="${FUZZING_SERVICE_URL}" \
--dashboard_address="${WEB_APP_URL}" \
--project_name="${PROJECT}" \
--campaign_run_name="${CAMPAIGN_RUN}" \
--duration="${TIMEOUT}" \
--findings_type="${FINDINGS_TYPE}"
