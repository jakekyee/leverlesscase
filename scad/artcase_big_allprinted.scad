// ArtCase at A4 size (297 x 210 mm) with every part printed on a Bambu P1S
// (256 x 256 bed). Everything else comes from artcase.scad. The extra size
// goes to the left and right equally and to the front; the PCB area and
// buttons don't move.
// The plate and top panel fill the case out to its walls, as in
// artcase_big_acrylic.scad. At 289 mm wide neither lies flat on the bed, so each
// prints standing on its front edge, turned 45 degrees: within about 208 x 208
// mm of bed and 206 mm tall. The case is the same print as
// artcase_big_acrylic.scad's, so either the printed or the acrylic plate and
// top fit it. It is cut near its thirds into three pieces, joined by bowtie
// keys set into its underside. Ten M3 countersunk screws go through the top
// and plate into heat-set inserts in every piece, so the panel also ties the
// pieces together.
// The plate and top STLs come out on edge, ready to slice. Give them a wide
// brim; the only overhangs are the tops of their holes.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"case\" --section z=1
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"case1\"
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"top\"
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_big_allprinted.scad -D part=\"assembly\" --preview

include <artcase.scad>

case_size = [297, 210];
bed_size = [256, 256];              // Bambu P1S
bed_h = 256;                        // Bambu P1S build height
plate_on_edge = true;               // full width, so on its front edge, turned 45 degrees on the bed
top_on_edge = true;                 // the same
// Cuts near the thirds (56 and 155). The right one sits 1 mm left of its third
// to stay clear of the cable channels at the back. Pieces 99, 98 and 100 mm wide.
case_cuts = [56, 154];
bowtie_y = [-55, 20, 95];           // one in the solid front area, two under the PCB
fastener = "screw";
// The same ten screws as artcase_big_acrylic.scad.
screws = [[-30, -72], [241, -72], [-30, 116], [241, 116],  // corners, about 9 mm in from the edges
          [-30, 22], [241, 22],                            // sides, halfway between the corners
          [83, -72], [128, -72],                           // front, in line with the back pair
          [83, 118], [128, 118]];                           // back, through the PCB's mounting holes
