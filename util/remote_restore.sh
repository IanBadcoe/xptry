#!/bin/bash
ssh -i ../keys/aws.key ubuntu@$1 "bash -s" -- < files/restore_remote.txt "$2" "$3" "$4" "$5" "$6" "$7"
