# Dump the lats/lons out of a log file, formatted as bare/CSV
BEGIN { 
    FS="[,]" 
}
/Speed\._calculate: to /{
    print $2 "," $3
    # print $0
}
