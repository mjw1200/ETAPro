//------------------------------------------------------------------------------------------------
// reference_pins.js
//
// Illustrates the basic algorithm I have in mind for the "reference pins" approach, where a
// drive pin is coerced to a reference pin with a known good lat/lon value.

const fs = require('node:fs');

let reference_pins = [];
let drive_pins = [];

read_input('./reference_pins.txt', reference_pins);
read_input('./drive_pins.txt', drive_pins);
// lat: reference_pins[i][0]
// lon: reference_pins[i][1]

var drive_pin_index = 1;
var min_found = false;

for (var i = 0; i < drive_pins.length; i++) {
    var reference_pin_min_index = -1;
    var reference_pin_index = 1;
    var min_dist = Number.MAX_VALUE;

    for (var j = 0; j < reference_pins.length; j++) {
        const dist = haversine(drive_pins[i][0], drive_pins[i][1], reference_pins[j][0], reference_pins[j][1]);
        if (dist < min_dist) {
            reference_pin_min_index = reference_pin_index;
            min_dist = dist;
        }
        else {
            console.log(`Min dist ${min_dist}, ${reference_pin_index}/${reference_pins.length}`);
            min_found = true;
            break;
        }

        reference_pin_index++;
    }

    console.log(`Drive pin ${drive_pin_index} coerced to reference pin ${reference_pin_min_index} at ${min_dist}m`);
    drive_pin_index++;    
}

//------------------------------------------------------------------------------------------------
function haversine(lat1, lon1, lat2, lon2) {
    const earthRadius = 6.371e6; // meters
    const toRadians = 0.01745;
    
    var phi1 = lat1 * toRadians
    var lambda1 = lon1 * toRadians
    var phi2 = lat2 * toRadians
    var lambda2 = lon2 * toRadians
    
    var deltaLam = lambda2 - lambda1
    var deltaPhi = phi2 - phi1
    
    var sin2Phi = Math.sin(deltaPhi / 2)**2
    var sin2Lam = Math.sin(deltaLam / 2)**2
    
    return 2 * earthRadius * Math.asin(Math.sqrt(sin2Phi + Math.cos(phi1) * Math.cos(phi2) * sin2Lam));
}

//------------------------------------------------------------------------------------------------
function read_input(filename, array) {
    try {
        const data = fs.readFileSync(filename, 'utf8');
        const lines = data.split(/\r?\n/);
        for (var i = 0; i < lines.length; i++) {
            const latlon = lines[i].split(',');
            const lat = latlon[0];
            const lon = latlon[1];
            array.push([lat, lon]);
        }
    } catch (err) {
        console.error(err);
        usage();
    }     
}

//------------------------------------------------------------------------------------------------
function usage() {
    console.error("");
    console.error("Looks for two files in the current directory: ");
    console.error("  reference_pins.txt");
    console.error("  drive_pins.txt");
    console.error("");
    console.error("These files should consist of comma separated lat/lon pairs, like so:");
    console.error("  45.65857828062997,-110.5683610435311");
    console.error("  45.65824002530862,-110.5698175554298");
    console.error("  ... as many as you want");

    process.exit(-1);
}