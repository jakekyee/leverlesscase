// ArtCase at the standard size with every part printed, and M3 countersunk
// screws into heat-set inserts in place of the push-pin pegs. Everything else
// comes from artcase.scad. On a Bambu P1S the case prints in one piece, and
// the printed top panel comes with its screw holes countersunk.
// The four screws are where artcase_art.scad has them, so the case is the same
// print for both: it takes the printed plate and top or the acrylic ones.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_screws.scad -D part=\"case\"
//   python ../openscad-stuff/scadloop.py scad/artcase_screws.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_screws.scad -D part=\"assembly\" --preview

include <artcase.scad>

bed_size = [256, 256];              // Bambu P1S
fastener = "screw";
// One screw near each corner, about 8 mm in from the top's edges.
screws = [[-8.5, -8.5], [219.5, -8.5], [-8.5, 115], [219.5, 115]];
