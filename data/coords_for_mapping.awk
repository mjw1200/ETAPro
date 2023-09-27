# Dump the lats/lons out of a log file, formatted as bare/CSV
BEGIN { 
    FS="[, ]" 
}
/^_updateSpeed: from /{
    print $3 "," $4
}
