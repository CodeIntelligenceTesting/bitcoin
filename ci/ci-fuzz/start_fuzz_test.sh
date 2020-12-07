#! /bin/sh
set -eu
# Get the name of the started campaign run from the logs
LOG_FILE="start-$(basename "asmap_ci").logs"
LINE=$(tail -1 "${LOG_FILE}")
CAMPAIGN_RUN=${LINE#*"ID: "}

# Monitor Fuzzing
./${CICTL} monitor_campaign_run \
--daemon_listen_address="${FUZZING_SERVICE_URL}" \
--dashboard_address="${WEB_APP_URL}" \
--project_name="${PROJECT}" \
--campaign_run_name="${CAMPAIGN_RUN}" \
--duration="${TIMEOUT}" \
--findings_type="${FINDINGS_TYPE}"
