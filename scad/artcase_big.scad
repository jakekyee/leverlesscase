// ArtCase at A4 size: 297 x 210 mm outside. Everything except the size comes
// from artcase.scad. The extra size goes to the left and right equally and to
// the front; the PCB area, buttons and pegs don't move.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_big.scad -D part=\"case\"

include <artcase.scad>

case_size = [297, 210];
