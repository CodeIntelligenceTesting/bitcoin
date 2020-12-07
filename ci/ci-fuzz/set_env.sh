#// Display name of the project.
PROJECT = 'bitcoin-new-docker'    
#// Display name of the campaign to be run.
CAMPAIGN = 'asmap_ci'
#// Address of the fuzzing service
FUZZING_SERVICE_URL = 'grpc-api.code-intelligence.com:443'
#// Address of the fuzzing web interface
WEB_APP_URL = 'app.code-intelligence.com'

#// Credentials for accessing the fuzzing service
CIFUZZ_CREDS = credentials('CIFUZZ_CREDS')
CICTL = 'cictl-2.14.1-linux';
CICTL_VERSION = '2.14.1';
CICTL_SHA256SUM = 'd1f3644e94b78e2cbf1a4317e4a0ad57f9cc62bb68be898ced77ec3db6cc2a83';
CICTL_URL = 'https://s3.eu-central-1.amazonaws.com/public.code-intelligence.com/cictl/cictl-2.14.1-linux';
FINDINGS_TYPE = 'CRASH';
TIMEOUT = '900'
# Email that will receive reports if any finding is encountered.
CI_FUZZING_REPORT_EMAIL_RECIPIENT: schrewe@code-intelligence.com