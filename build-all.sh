#!/bin/bash
bash -c "cd 8.1; sh build.sh; sh push.sh"
bash -c "cd 8.2; sh build.sh; sh push.sh"
bash -c "cd 8.3; sh build.sh; sh push.sh"
bash -c "cd 8.4; sh build.sh; sh push.sh"
bash -c "cd latest; sh build.sh; sh push.sh"
