#!/bin/sh
/bin/cat /Library/Application\ Support/ArqAgent/logs/backup/$(ls -1tr /Library/Application\ Support/ArqAgent/logs/backup/ | tail -n 1) > /tmp/bkRslt
/bin/cat /tmp/bkRslt | grep -E -B6 -- 'Uploaded|No changes'
