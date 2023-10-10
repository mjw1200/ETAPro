if (process.argv.length != 6) {
    console.error('Usage: node haversine.js [lat1] [lon1] [lat2] [lon2]')
    console.error('Lat & lon should be double precision degrees')
    process.exit(1)
}

const earthRadius = 6.371e6; // meters
const toRadians = 0.01745;
const lat1 = process.argv[2];
const lon1 = process.argv[3];
const lat2 = process.argv[4];
const lon2 = process.argv[5];

// console.log(`${process.argv[2]} / ${process.argv[3]} / ${process.argv[4]} / ${process.argv[5]}`)

var phi1 = lat1 * toRadians
var lambda1 = lon1 * toRadians
var phi2 = lat2 * toRadians
var lambda2 = lon2 * toRadians

var deltaLam = lambda2 - lambda1
var deltaPhi = phi2 - phi1

var sin2Phi = Math.sin(deltaPhi / 2)**2
var sin2Lam = Math.sin(deltaLam / 2)**2

var dist = 2 * earthRadius * Math.asin(Math.sqrt(sin2Phi + Math.cos(phi1) * Math.cos(phi2) * sin2Lam))
console.log(`${dist} meters`)
