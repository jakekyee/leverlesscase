// ArtCase at the standard size with two laser-cut acrylic layers: a 2 mm
// switch plate, and a 4.5 mm clear top over an art print. They stack to the
// same height as the printed plate and top, so the buttons sit where the
// original design puts them. M3 countersunk screws go through both into
// heat-set inserts in the case. Everything else comes from artcase.scad.
// On a Bambu P1S the case prints in one piece. Cut the plate and top from
// plate_2d and top_2d (DXF or SVG), and trim the art print to top_2d. A laser
// can't countersink, so countersink the top's screw holes by hand (90 degrees,
// 6 mm across).
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_art.scad -D part=\"case\"
//   python ../openscad-stuff/scadloop.py scad/artcase_art.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_art.scad -D part=\"assembly\" --preview

include <artcase.scad>

bed_size = [256, 256];              // Bambu P1S
laser_plate = true;
plate_t = 2;                        // 2 mm acrylic, as thick as the printed plate
plate_fit = 0.2;                    // gap per side around the cut plate in the printed seat
laser_top = true;
rim_h = 4.6;                        // 4.5 mm acrylic + 0.1 mm paper print; set it to what you buy
top_fit = 0.2;                      // gap per side around the acrylic in the printed seat
fastener = "screw";
// One screw near each corner, about 8 mm in from the top's edges.
screws = [[-8.5, -8.5], [219.5, -8.5], [-8.5, 115], [219.5, 115]];
// Still deciding on a 5th at the front centre. To add it:
// screws = [[-8.5, -8.5], [219.5, -8.5], [-8.5, 115], [219.5, 115], [105.5, -8.5]];
