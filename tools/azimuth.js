// https://www.omnicalculator.com/other/azimuth#azimuth-formula

// Standard Azimuths:
// ------------------
// N: 0°
// NNE: 22.5°
// NE: 45°
// ENE: 67.5°
// E: 90°
// ESE: 112.5°
// SE: 135°
// SSE: 157.5°
// S: 180°
// SSW: 202.5°
// SW: 225°
// WSW: 247.5°
// W: 270°
// WNW: 292.5°
// NW: 315°
// NNW: 337.5°

// φ: index 0 λ: index 1
const home = [45.6534670, -110.5644159];
const north = [45.6590000, -110.5644159];
const northeast = [45.6590000, -110.5570000];
const east = [45.6534670, -110.5570000];
const southeast = [45.6480000, -110.5570000];
const south = [45.6480000, -110.5644159];
const southwest = [45.6480000, -110.5720000];
const west = [45.6534670, -110.5720000];
const northwest = [45.6590000, -110.5720000];

const φ1deg = 45.6534534; // lat
const λ1deg = -110.5647570; // lon
const φ2deg = 45.6797106; // lat
const λ2deg = -111.0290149; // lon

const degToRad = Math.PI/180;
const radToDeg = 180/Math.PI;

console.log(`north: ${calculateAzimuth(home, north)}`);
console.log(`northeast: ${calculateAzimuth(home, northeast)}`);
console.log(`east: ${calculateAzimuth(home, east)}`);
console.log(`southeast: ${calculateAzimuth(home, southeast)}`);
console.log(`south: ${calculateAzimuth(home, south)}`);
console.log(`southwest: ${calculateAzimuth(home, southwest)}`);
console.log(`west: ${calculateAzimuth(home, west)}`);
console.log(`northwest: ${calculateAzimuth(home, northwest)}`);

function calculateAzimuth(point1, point2) {
    // Math.* takes radians
    const φ1 = point1[0] * degToRad;
    const λ1 = point1[1] * degToRad;
    const φ2 = point2[0] * degToRad;
    const λ2 = point2[1] * degToRad;
    const Δλ = λ2 - λ1;

    const rads = Math.atan2(Math.sin(Δλ)*Math.cos(φ2), 
        Math.cos(φ1)*Math.sin(φ2) - Math.sin(φ1)*Math.cos(φ2)*Math.cos(Δλ));    
    const degs = rads * radToDeg;

    return (degs + 360) % 360;
}
