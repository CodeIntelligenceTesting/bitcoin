sh '''
              set -eu

              # Download cictl if it doesn't exist already
              if [ ! -f "${CICTL}" ]; then
                wget "${CICTL_URL}" -O "${CICTL}"
              fi

              # Verify the checksum
              echo "${CICTL_SHA256SUM} "${CICTL}"" | sha256sum --check

              # Make it executable
              chmod +x "${CICTL}"
            '''