// ArtCase at A4 size (297 x 210 mm) with every part printed on a Bambu P1S, as
// in artcase_big_allprinted.scad, but with the case printed in one piece:
// standing on its front edge and turned 45 degrees on the bed, it takes about
// 220 x 220 mm of bed and 210 mm of height. The plate and top still print flat,
// narrowed to plate_w, and the case fills the strips beside them up to the rim.
// They and the screws are the same as in artcase_big_allprinted.scad, so the
// same plate and top prints fit either case. Everything else comes from
// artcase.scad.
// The case STL comes out on edge, ready to slice. Give it a brim, and paint
// support under its rounded front-top edge, which starts as a shallow overhang
// right at the bed.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted_onepiece.scad -D part=\"case\"
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted_onepiece.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted_onepiece.scad -D part=\"assembly\" --preview

include <artcase.scad>

case_size = [297, 210];
bed_size = [256, 256];              // Bambu P1S
bed_h = 256;                        // Bambu P1S build height
case_on_edge = true;                // one piece, on its front edge, turned 45 degrees on the bed
plate_w = 250;                      // plate and panel as wide as the bed allows, 3 mm to spare each side
fastener = "screw";
// The same seven screws as artcase_big_allprinted.scad. The two at the back are
// there to put inserts in its middle piece; with the case in one piece they
// could go.
screws = [[-11.5, -72], [222.5, -72], [-11.5, 116], [222.5, 116],  // corners
          [105.5, -40],                                             // front centre
          [83, 118], [128, 118]];                                   // back, through the PCB's mounting holes
