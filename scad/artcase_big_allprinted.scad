// ArtCase at A4 size (297 x 210 mm) with every part printed on a Bambu P1S
// (256 x 256 bed). Everything else comes from artcase.scad. The extra size
// goes to the left and right equally and to the front; the PCB area and
// buttons don't move.
// The plate and top panel are narrowed to plate_w so each prints in one piece,
// and the case fills the strips beside them up to the rim. The case is cut
// near its thirds into three pieces, joined by bowtie keys set into its
// underside. Seven M3 countersunk screws go through the top and plate into
// heat-set inserts in every piece, so the panel also ties the pieces together.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"case\" --section z=1
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"case1\"
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"assembly\" --preview

include <artcase.scad>

case_size = [297, 210];
bed_size = [256, 256];              // Bambu P1S
plate_w = 250;                      // plate and panel as wide as the bed allows, 3 mm to spare each side
// Cuts near the thirds (56 and 155). The right one sits 1 mm left of its third
// to stay clear of the cable channels at the back. Pieces 99, 98 and 100 mm wide.
case_cuts = [56, 154];
bowtie_y = [-55, 20, 95];           // one in the solid front area, two under the PCB
fastener = "screw";
// The same seven screws as artcase_big_acrylic.scad, with the corner ones moved
// in to sit about 8 mm inside the 250 mm panel.
screws = [[-11.5, -72], [222.5, -72], [-11.5, 116], [222.5, 116],  // corners
          [105.5, -40],                                             // front centre
          [83, 118], [128, 118]];                                   // back, through the PCB's mounting holes
