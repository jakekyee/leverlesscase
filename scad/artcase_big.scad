// ArtCase at A4 size: 297 x 210 mm outside, set up for a Bambu P1S (256 x 256
// bed). Everything else comes from artcase.scad. The extra size goes to the
// left and right equally and to the front; the PCB area, buttons and original
// pegs don't move.
// The plate and top panel are narrowed to plate_w so each prints in one piece,
// and the case fills the strips beside them up to the rim. The case is cut
// near its thirds into three pieces, joined by bowtie keys set into the
// underside. A row of extra pegs holds down the front of the panel and pins
// every case piece to it.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_big.scad -D part=\"case\" --section z=1
//   python ../openscad-stuff/scadloop.py scad/artcase_big.scad -D part=\"case1\"
//   python ../openscad-stuff/scadloop.py scad/artcase_big.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_big.scad -D part=\"assembly\" --preview

include <artcase.scad>

case_size = [297, 210];
bed_size = [256, 256];              // Bambu P1S
plate_w = 250;                      // plate and panel as wide as the bed allows, 3 mm to spare each side
// Cuts near the thirds (56 and 155). The right one sits 1 mm left of its third
// to stay clear of the cable channels at the back. Pieces 99, 98 and 100 mm wide.
case_cuts = [56, 154];
bowtie_y = [-55, 20, 95];           // one in the solid front area, two under the PCB
extra_pegs = [[9, -60], [83, -60], [128, -60], [202, -60]];  // the original pegs' x, near the front
