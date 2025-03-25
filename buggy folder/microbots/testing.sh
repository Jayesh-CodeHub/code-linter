#!/bin/bash

# Mock backup and system monitoring tool
LOGFILE=/var/log/backup.log
BACKUP_SRC="/home/user/documents"
BACKUP_DEST="/mnt/backup"

echo "Starting backup process at $(date)" >> $LOGFILE

# Create backup directory (Bug: using mkdir incorrectly)
mkdir -p $BACKUP_DEST && cd $BACKUP_DEST || echo "Failed to create backup directory"

# Check disk space (Bug: unquoted variable, word splitting issue)
DISK_FREE=$( df -h | grep /dev/sda1 | awk '{ print $4 }' )
echo "Available disk space: $DISK_FREE" >> $LOGFILE

# Infinite loop issue
while true; do
    echo "Checking system health..."
    sleep 5  # Bug: No exit condition, runs forever
done

# Useless cat usage (Bug: unnecessary use of cat)
cat /etc/passwd | grep "root" >> $LOGFILE

# Bug: sudo used incorrectly inside a script
sudo cp -r $BACKUP_SRC $BACKUP_DEST

# Deprecated command (Bug: Using `expr` instead of `$(( ))`)
FILES_COUNT=$(expr `ls -1 $BACKUP_SRC | wc -l` + 1)
echo "Total files to backup: $FILES_COUNT" >> $LOGFILE

# Wrong shebang (Bug: Uses `sh` but has Bash-specific syntax)
#!/bin/sh

# Typo in command (Bug: using `echoo` instead of `echo`)
echoo "Backup process completed" >> $LOGFILE

# Incorrect function syntax (Bug: missing `function` keyword)
backup_check {
    if [[ -d "$BACKUP_DEST" ]]; then
        echo "Backup location exists."
    else
        echo "Backup failed, directory missing!"
    fi
}

# Bug: Hardcoded sleep instead of dynamic timeout
sleep 60

# Unused variable (Bug: Variable declared but never used)
UNUSED_VAR="This is unused"

# End of script
exit 0
