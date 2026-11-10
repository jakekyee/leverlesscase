// ArtCase at A4 size (297 x 210 mm) with two laser-cut acrylic layers: a 2 mm
// switch plate, and a 4.5 mm clear top over an art print. Each is one
// full-size piece (289 x 206 mm) that bridges both case cuts, and together they
// stack to the same height as the printed plate and top. Everything else comes
// from artcase.scad. The case prints in three pieces on a Bambu P1S, joined by
// bowtie keys set into its underside, and seven M3 countersunk screws go
// through the top and plate into heat-set inserts in every piece. Cut plate_2d
// and top_2d (DXF or SVG), trim the art print to top_2d, and countersink the
// top's screw holes by hand (90 degrees, 6 mm across), since a laser can't.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_big_acrylic.scad -D part=\"case\" --section z=1
//   python ../openscad-stuff/scadloop.py scad/artcase_big_acrylic.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_big_acrylic.scad -D part=\"assembly\" --preview

include <artcase.scad>

case_size = [297, 210];
bed_size = [256, 256];              // Bambu P1S
// Cuts near the thirds (56 and 155). The right one sits 1 mm left of its third
// to stay clear of the cable channels at the back. Pieces 99, 98 and 100 mm wide.
case_cuts = [56, 154];
bowtie_y = [-55, 20, 95];           // one in the solid front area, two under the PCB
laser_plate = true;
plate_t = 2;                        // 2 mm acrylic, as thick as the printed plate
plate_fit = 0.2;                    // gap per side around the cut plate in the printed seat
laser_top = true;
rim_h = 4.6;                        // 4.5 mm acrylic + 0.1 mm paper print; set it to what you buy
top_fit = 0.2;                      // gap per side around the acrylic in the printed seat
fastener = "screw";
screws = [[-30, -72], [241, -72], [-30, 116], [241, 116],  // corners, about 9 mm in from the edges
          [105.5, -40],                                     // front centre
          [83, 118], [128, 118]];                           // back, through the PCB's mounting holes
