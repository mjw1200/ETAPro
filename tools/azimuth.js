// https://www.omnicalculator.com/other/azimuth#azimuth-formula

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

// 414 S. 8th St. (Home): 45.6534534, -110.5647570
// Music Villa (~W): 45.6797106, -111.0290149
// Railyard (~NNE): 45.6673855, -110.5561042
// Climbin' Cliffs (~NE): 45.6658662, -110.5370806
// Wineglass (~SW): 45.6198655, -110.6343549
// Siebeck Island (~S): 45.6475314, -110.5605613
// Town & Country (~W): 45.6522341, -110.5708737

const φ1deg = 45.6534534; // lat
const λ1deg = -110.5647570; // lon
const φ2deg = 45.6797106; // lat
const λ2deg = -111.0290149; // lon

// Convert degrees to radians for Math.*
const φ1 = φ1deg * (Math.PI/180);
const λ1 = λ1deg * (Math.PI/180);
const φ2 = φ2deg * (Math.PI/180);
const λ2 = λ2deg * (Math.PI/180);
const Δλ = λ2 - λ1;

const rads = Math.atan2(Math.sin(Δλ)*Math.cos(φ2), 
    Math.cos(φ1)*Math.sin(φ2) - Math.sin(φ1)*Math.cos(φ2)*Math.cos(Δλ));    
var degs = rads * (180/Math.PI);
degs = (degs + 360) % 360;

console.log(`Rads: ${rads}; degs: ${degs}`);
