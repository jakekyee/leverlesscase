// ArtCase at A4 size (297 x 210 mm) with two laser-cut acrylic layers, as in
// artcase_big_acrylic.scad, but with the case printed in one piece: standing on
// its front edge and turned 45 degrees on the bed, it takes about 220 x 220 mm
// of a Bambu P1S's bed and 210 mm of its height. The plate, top and screws are
// the same as in artcase_big_acrylic.scad, so the same laser-cut acrylic fits
// either case. Everything else comes from artcase.scad. Cut plate_2d and top_2d
// (DXF or SVG), trim the art print to top_2d, and countersink the top's screw
// holes by hand (90 degrees, 6 mm across), since a laser can't.
// The case STL comes out on edge, ready to slice. Give it a brim, and paint
// support under its rounded front-top edge, which starts as a shallow overhang
// right at the bed.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_big_acrylic_onepiece.scad -D part=\"case\"
//   python ../openscad-stuff/scadloop.py scad/artcase_big_acrylic_onepiece.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_big_acrylic_onepiece.scad -D part=\"assembly\" --preview

include <artcase.scad>

case_size = [297, 210];
bed_size = [256, 256];              // Bambu P1S
bed_h = 256;                        // Bambu P1S build height
case_on_edge = true;                // one piece, on its front edge, turned 45 degrees on the bed
laser_plate = true;
plate_t = 2;                        // 2 mm acrylic, as thick as the printed plate
plate_fit = 0.2;                    // gap per side around the cut plate in the printed seat
laser_top = true;
rim_h = 4.6;                        // 4.5 mm acrylic + 0.1 mm paper print; set it to what you buy
top_fit = 0.2;                      // gap per side around the acrylic in the printed seat
fastener = "screw";
// The same seven screws as artcase_big_acrylic.scad. The two at the back are
// there to put inserts in its middle piece; with the case in one piece they
// could go.
screws = [[-30, -72], [241, -72], [-30, 116], [241, 116],  // corners, about 9 mm in from the edges
          [105.5, -40],                                     // front centre
          [83, 118], [128, 118]];                           // back, through the PCB's mounting holes
