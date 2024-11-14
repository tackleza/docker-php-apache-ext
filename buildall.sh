#!/bin/bash

bash -c "cd 5.6; sh build.sh; sh push.sh"

bash -c "cd 7.0; sh build.sh; sh push.sh"
bash -c "cd 7.1; sh build.sh; sh push.sh"
bash -c "cd 7.2; sh build.sh; sh push.sh"
bash -c "cd 7.3; sh build.sh; sh push.sh"
bash -c "cd 7.4; sh build.sh; sh push.sh"

bash -c "cd 8.0; sh build.sh; sh push.sh"
bash -c "cd 8.1; sh build.sh; sh push.sh"
bash -c "cd 8.2; sh build.sh; sh push.sh"
bash -c "cd 8.3; sh build.sh; sh push.sh"
