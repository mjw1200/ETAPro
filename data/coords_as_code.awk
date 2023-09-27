# Dump the lats/lons out of a log file, formatted as C++ code
BEGIN { 
    FS="[, ]" 
    print "// [meaningful description] (XX points)"
    print "double fakePoints[POINT_COUNT][2] {"
}
/^_updateSpeed: from /{
    print "  {" $3 "," $4 "},"
}
END {
    print "  { -1, -1 }, // Ok, stop"
    print "};"
}
