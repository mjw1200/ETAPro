# Cut the lats and lons out of a log file
BEGIN { FS="," }
/lat1/{
    print "{" $2 "," $4 "},"
}
