// ArtCase at the standard width and A4 depth (251.8 x 210 mm) with two
// laser-cut acrylic layers: a 2 mm switch plate, and a 4.5 mm clear top over an
// art print. It is artcase_big_acrylic.scad narrowed to the standard case's
// width, so the case prints in one piece on a Bambu P1S, with no cuts or
// bowties: the standard case made 64.6 mm deeper at the front, with the PCB and
// buttons where they were. The plate and top are one piece each (243 x 206 mm)
// and stack to the same height as the printed plate and top. Five M3
// countersunk screws go through both into heat-set inserts in the case.
// Everything else comes from artcase.scad. Cut plate_2d and top_2d (DXF or
// SVG), trim the art print to top_2d, and countersink the top's screw holes by
// hand (90 degrees, 6 mm across), since a laser can't.
//
// Check from the repo root:
//   python ../openscad-stuff/scadloop.py scad/artcase_deep_acrylic.scad -D part=\"case\"
//   python ../openscad-stuff/scadloop.py scad/artcase_deep_acrylic.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase_deep_acrylic.scad -D part=\"assembly\" --preview

include <artcase.scad>

case_size = [251.8, 210];           // standard width, A4 depth; 2.1 mm of bed to spare each side
bed_size = [256, 256];              // Bambu P1S
laser_plate = true;
plate_t = 2;                        // 2 mm acrylic, as thick as the printed plate
plate_fit = 0.2;                    // gap per side around the cut plate in the printed seat
laser_top = true;
rim_h = 4.6;                        // 4.5 mm acrylic + 0.1 mm paper print; set it to what you buy
top_fit = 0.2;                      // gap per side around the acrylic in the printed seat
fastener = "screw";
// Corners at the standard variants' x, about 8 mm in from the top's sides, and
// at artcase_big_acrylic.scad's y. The front-centre screw holds the middle of
// the 228 mm span between the front corners. artcase_big_acrylic.scad's two
// back screws, through the PCB's mounting holes, put inserts in its middle
// piece; with the case in one piece they aren't needed.
screws = [[-8.5, -72], [219.5, -72], [-8.5, 116], [219.5, 116],  // corners
          [105.5, -40]];                                          // front centre
