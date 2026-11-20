// ArtCase at A4 size (297 x 210 mm) with every part printed on a Bambu P1S, as
// in artcase_big_allprinted.scad, but with the case printed in one piece:
// standing on its front edge and turned 45 degrees on the bed, it takes about
// 220 x 220 mm of bed and 210 mm of height. The plate and top are the same as
// in artcase_big_allprinted.scad, full width and printed on edge the same way,
// with the same screws, so the same plate and top prints fit either case. The
// case is the same print as artcase_big_acrylic_onepiece.scad's. Everything
// else comes from artcase.scad.
// The case, plate and top STLs come out on edge, ready to slice. Give them a
// wide brim, and paint support under the case's rounded front-top edge, which
// starts as a shallow overhang right at the bed.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted_onepiece.scad -D part=\"case\"
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted_onepiece.scad -D part=\"top\"
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted_onepiece.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted_onepiece.scad -D part=\"assembly\" --preview

include <artcase.scad>

case_size = [297, 210];
bed_size = [256, 256];              // Bambu P1S
bed_h = 256;                        // Bambu P1S build height
case_on_edge = true;                // one piece, on its front edge, turned 45 degrees on the bed
plate_on_edge = true;               // full width, so on edge the same way
top_on_edge = true;                 // the same
fastener = "screw";
// The same ten screws as artcase_big_allprinted.scad, so the same plate and
// top fit both. The back pair hold the top's back edge beside the function-row
// opening and the plate beside the USB connector; the front pair mirror them.
screws = [[-30, -72], [241, -72], [-30, 116], [241, 116],  // corners, about 9 mm in from the edges
          [-30, 22], [241, 22],                            // sides, halfway between the corners
          [83, -72], [128, -72],                           // front, in line with the back pair
          [83, 118], [128, 118]];                           // back, through the PCB's mounting holes
