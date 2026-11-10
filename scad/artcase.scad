// ArtCase: case, switch plate, top panel and fasteners for a leverless controller.
//
// Rebuilt from ArtCase-case.step, ArtCase-plate.step and ArtCase-peg.step.
// X and Y follow the STEP files: the origin is the PCB's front-left corner and
// +Y runs toward the open back edge. Z = 0 is the bottom of the case.
// The STEP parts have 0.4 mm cosmetic fillets on most edges. Those are left
// out; every other dimension follows the STEP files.
// The top panel isn't in the STEP files. It follows the top of the rect case
// (granolasummitcase_rect.blend): round wells at the buttons and one opening
// for the function row. It fills the space above the plate, so the fasteners
// clamp it down.
// The defaults are the case as designed: printed parts, four push-pin pegs,
// one piece. Other settings, all off by default:
//   fastener = "screw"   M3 countersunk screws into heat-set inserts, at `screws`
//   laser_plate/_top     the plate or top is laser cut from plate_2d / top_2d
//   plate_t, rim_h       plate and top thickness, to match bought sheet; the
//                        plate's top face stays put, so the switches still fit
//   case_size, plate_w   a bigger footprint, and a plate and top narrower than it
//   case_cuts            the case in pieces joined by bowtie keys underneath
//   bed_size             fail if a printed part doesn't fit the printer
// The variant files (artcase_art.scad, artcase_big_*.scad) set these.
//
// Check from the repo root (see ../openscad-stuff/README.md):
//   python ../openscad-stuff/scadloop.py scad/artcase.scad -D part=\"case\"
//   python ../openscad-stuff/scadloop.py scad/artcase.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase.scad -D part=\"assembly\" --preview
// The parts fit line-to-line, as in the STEP files (every *_fit is 0 unless a
// variant sets it). The parts touch, so the merged assembly mesh has seams
// where they meet and fails the watertight check; that is expected. The
// interference check is the real fit test.

/* [Selection] */
// A split case (see case_cuts) also has one part per piece, "case1", "case2"
// and so on from the left; "case" is still the whole case. plate_2d and
// top_2d are the flat outlines for laser cutting; export them as DXF or SVG.
part = "case";  // [case, plate, top, plate_2d, top_2d, peg, bowtie, assembly, interference]

/* [PCB] */
pcb_size = [211, 125];  // footprint; the case and plate are flush with its back edge
pcb_corner_r = 4.5;     // corner radius at the front
pcb_clear = 0.5;        // gap around the PCB in its pocket
pcb_pocket_d = 1.8;     // pocket depth under the STEP's 2 mm plate, from the floor up to its ledge

/* [Plate] */
// Plate thickness. Its top face stays where the STEP plate's is, since that
// sets the switch height above the PCB, so a thinner plate rests on a higher ledge.
plate_t = 2;
switch_hole = 14;       // square switch cutout
plate_slot_w = 3;       // width of the two slots above the ends of the floor notch
plate_fit = 0;          // gap per side between plate and case (0 = as designed)
// Width of the plate and top panel, centred on the PCB. 0 fills the space
// between the walls, as designed; anything narrower leaves a strip of case on
// each side, solid up to the rim.
plate_w = 0;
laser_plate = false;    // cut the plate (aluminium or acrylic) from plate_2d instead of printing it

/* [Top panel] */
well_clear = 0;         // added per side to the wells and the function-row opening
key_pitch = 18;         // function-row key spacing; the opening spans one cell per key
min_web = 1.2;          // thinnest wall allowed between round holes in the panel
top_fit = plate_fit;    // gap per side between top panel and case
laser_top = false;      // cut the top (acrylic over an art print) from top_2d instead of printing it

/* [Case] */
// Outer footprint [x, y]. The PCB stays centred left to right and flush with
// the open back, so extra size goes to the left and right equally and to the front.
case_size = [251.8, 145.4];
wall = 4;               // wall thickness around the plate
floor_t = 6;            // floor thickness under the PCB
rim_h = 4.6;            // wall height above the plate: the top panel's thickness (acrylic + art print when cut)
outer_r = 3.6;          // radius of the outer corners and top edges
pocket_d = 2.4;         // depth of the clearance pockets under the PCB
peg_boss_d = 10;        // floor pockets, cuts and bowties stay out of this circle around each fastener
min_floor = 1;          // thinnest floor allowed under a pocket or hole

/* [Case split] */
case_cuts = [];         // x of each cut through the case, left to right; [] keeps it whole
bowtie_y = [20, 95];    // y of the bowtie keys set into the case bottom across each cut
bowtie_len = 30;        // bowtie length, across the cut
bowtie_w = 16;          // bowtie width at its ends
bowtie_waist = 8;       // bowtie width at the cut
bowtie_d = 2;           // depth of the bowtie pockets, and thickness of the bowties
bowtie_fit = 0;         // gap per side around each bowtie, which is also this much thinner (0 = line-to-line)

/* [Fasteners] */
// Push-pin pegs (as designed) through the PCB's mounting holes and extra_pegs,
// or M3 countersunk screws from the top into heat-set inserts at `screws`.
fastener = "peg";       // [peg, screw]
screws = [];            // screw positions [x, y] for fastener = "screw"
screw_clear_d = 3.4;    // M3 clearance hole in the top panel and plate
screw_head_d = 6;       // M3 countersunk head; a printed top gets its 90 degree countersink
insert_hole_d = 4.0;    // hole for the heat-set insert: M3 x 3 mm long x 4.2 mm across
insert_len = 3;         // insert length
// Insert hole depth, cut shorter where it would leave less than min_floor under
// it. Deeper than the insert, so the screw can run on past it.
insert_hole_depth = 6;
screw_lengths = [6, 8, 10, 12, 14, 16, 20];  // stock lengths; each screw gets the longest that fits
laser_hole_clear = 0.15;  // added per side to peg holes in a laser-cut part (8 mm pegs get 8.3)

/* [Pegs] */
peg_d = 8;              // shaft diameter
peg_fit = 0;            // hole clearance per side in printed parts (0 = as designed)
peg_flange_d = 10;
peg_flange_t = 0.6;
peg_flat_w = 6.4;       // width across the flats
peg_barb_d = 10.4;      // barb diameter; both barb flanks are 45 degrees
peg_barb_land = 0.2;    // straight band at the barb's widest point
peg_split_z = 3;        // height where the flats and the slit reach full depth
peg_slit_w = 3;         // slit width at the tip
peg_slit_angle = 7;     // angle of each slit wall from vertical, degrees

/* [Printing] */
bed_size = [0, 0];      // printer bed [x, y]; every printed part must fit on it. [0, 0] skips the check

/* [Hidden] */
$fn = $preview ? 32 : 96;
over = 1;               // cutters run this far past the faces they open
open_back = pcb_size.y + over;  // y for cuts that run out through the open back

// Switch positions [x, y, d], where d is the button size: the diameter of the
// round floor pocket under the switch and of its well in the top panel.
buttons = [
    [ 12,  81,      24], [ 39,  89,      24], [ 66,  85,      24], [ 90,  68,      24],
    [104,  15,      30], [133,  32,      24],
    [118,  58,      24], [145,  67.9626, 24], [172,  67.9626, 24], [199,  59.9626, 24],
    [118,  85,      24], [145,  94.9626, 24], [172,  94.9626, 24], [199,  86.9626, 24]
];
// Function-row switches. One floor pocket and one top-panel opening serve all four.
function_keys = [[12, 116], [30, 116], [48, 116], [66, 116]];
// The PCB's mounting holes, where the pegs go through it, and any more pegs
// outside it, for example in the area a bigger case_size adds. Screws can use
// the mounting holes too; anywhere else over the PCB is refused.
peg_holes = [[9, 7], [202, 7], [83, 118], [128, 118]];
extra_pegs = [];

// Rectangular floor pockets [[x0, y0], [x1, y1], depth].
pockets = [
    [[  3,   109], [ 75,   open_back], pocket_d],  // under the function row
    [[ 83,    88], [103,   118      ], pocket_d],  // component clearance (these two
    [[103,   100], [115,   118      ], pocket_d],  //   rectangles make one L shape)
    [[138,   115], [151,   open_back], pocket_d],  // component clearance
    [[101,   116], [110,   open_back], 3.4],       // connector channel
    [[157.5, 109], [164.5, open_back], 5],         // channels out the back
    [[170.5, 109], [177.5, open_back], 5],
    [[183.5, 109], [190.5, open_back], 5]
];
// Cut through the floor. The plate's two slots sit above its ends.
notch = [[195, 114.6], [211, open_back]];

// ---- Derived dimensions
switches = concat(buttons, function_keys);  // every switch cutout in the plate
fasteners = fastener == "screw" ? screws : concat(peg_holes, extra_pegs);
case_min = [(pcb_size.x - case_size.x) / 2, pcb_size.y - case_size.y];
case_max = [(pcb_size.x + case_size.x) / 2, pcb_size.y];
// Recess in the case that the plate and top sit in: between the walls, or
// plate_w wide and centred on the PCB. The back is open, so neither the wall
// nor the fit applies there.
seat_min = [plate_w > 0 ? (pcb_size.x - plate_w) / 2 : case_min.x + wall, case_min.y + wall];
seat_max = [plate_w > 0 ? (pcb_size.x + plate_w) / 2 : case_max.x - wall, case_max.y];
plate_min = seat_min + [plate_fit, plate_fit];
plate_max = seat_max - [plate_fit, 0];
top_min = seat_min + [top_fit, top_fit];
top_max = seat_max - [top_fit, 0];
plate_top_z = floor_t + pcb_pocket_d + 2;  // the STEP plate's top face: the switches need it here
plate_z = plate_top_z - plate_t;           // the plate rests on the ledge here
case_h = plate_top_z + rim_h;

// An installed peg has its tip flush with the case bottom and its flange on
// the rim plane. Its barb seats in a 45 degree countersink as deep as the barb.
peg_hole_d = peg_d + 2 * peg_fit;
peg_len = case_h + peg_flange_t;
barb_flank = (peg_barb_d - peg_d) / 2;  // 45 degree flank: height equals radial step
barb_len = 2 * barb_flank + peg_barb_land;
csink_h = barb_len;
csink_d = peg_hole_d + 2 * csink_h;     // countersink diameter at the bottom face

// Slit width at height z: peg_slit_w at the tip, narrowing by peg_slit_angle per side.
function slit_w(z) = peg_slit_w - 2 * (peg_len - z) * tan(peg_slit_angle);
slit_w0 = slit_w(peg_split_z);                               // at the slit's root
slit_w_barb = slit_w(peg_len - barb_flank - peg_barb_land);  // where the barb is widest

// Fastener hole through the plate or top panel, printed or laser cut.
function fastener_hole_d(laser) = fastener == "screw" ? screw_clear_d
                                : laser ? peg_d + 2 * laser_hole_clear : peg_hole_d;
fastener_head_d = fastener == "screw" ? screw_head_d : peg_flange_d;  // widest at the top face
// Keep-out radius in the case: the peg countersink, or the boss around an insert.
fastener_keepout = fastener == "screw" ? peg_boss_d / 2 : csink_d / 2;

// A screw's insert sits in the case just under the plate: in the floor where
// the screw passes through the PCB, in the solid ledge elsewhere.
function over_pcb(p) = p.x > -pcb_clear && p.x < pcb_size.x + pcb_clear && p.y > -pcb_clear;
function insert_top(p) = over_pcb(p) ? floor_t : plate_z;
function insert_depth(p) = min(insert_hole_depth, insert_top(p) - min_floor);
// Longest stock screw that stops 0.5 mm short of the bottom of its hole.
function screw_len(p) = max(concat([0], [for (l = screw_lengths)
    if (l <= case_h - (insert_top(p) - insert_depth(p)) - 0.5) l]));
screw_lens = [for (s = screws) screw_len(s)];

// Round holes in the top panel [x, y, d] at its top face: a well per button and
// one per fastener (a screw's countersink is as wide as its head).
panel_holes = concat([for (b = buttons) [b.x, b.y, b[2] + 2 * well_clear]],
                     [for (h = fasteners) [h.x, h.y, fastener == "screw" ? screw_head_d
                                                                         : fastener_hole_d(laser_top)]]);
// Edge-to-edge distance between two round holes [x, y, d].
function web(a, b) = norm([a.x - b.x, a.y - b.y]) - (a[2] + b[2]) / 2;
panel_web = min([for (i = [0 : len(panel_holes) - 2]) for (j = [i + 1 : len(panel_holes) - 1])
                 web(panel_holes[i], panel_holes[j])]);

// Case pieces: piece i (from 1) spans x = piece_x[i - 1] to piece_x[i]. Every
// cut gets a bowtie at each bowtie_y.
piece_x = concat([case_min.x], case_cuts, [case_max.x]);
n_pieces = len(case_cuts) + 1;
bowties = [for (c = case_cuts, y = bowtie_y) [c, y]];

// Parts to make and how many of each; *_2d parts are laser cut. Hardware is
// what to buy. scad/export_stls.py reads both echoes.
printable = concat(
    n_pieces == 1 ? [["case", 1]] : [for (i = [1 : n_pieces]) [str("case", i), 1]],
    [[laser_plate ? "plate_2d" : "plate", 1], [laser_top ? "top_2d" : "top", 1]],
    fastener == "peg" ? [["peg", len(fasteners)]] : [],
    len(bowties) > 0 ? [["bowtie", len(bowties)]] : []);
hardware = fastener == "screw"
    ? concat([for (l = screw_lengths) let(n = len([for (x = screw_lens) if (x == l) 1])) if (n > 0)
                  [str("M3x", l, " countersunk screw"), n]],
             [["M3 heat-set insert", len(screws)]])
    : [];

// ---- Design rules
function inside(p, lo, hi) = p.x >= lo.x && p.y >= lo.y && p.x <= hi.x && p.y <= hi.y;
function overlaps(lo, hi, lo2, hi2) = lo.x < hi2.x && lo2.x < hi.x && lo.y < hi2.y && lo2.y < hi.y;
// Distance from point p to the box lo..hi; 0 inside it.
function box_dist(p, lo, hi) = norm([max(lo.x - p.x, 0, p.x - hi.x), max(lo.y - p.y, 0, p.y - hi.y)]);
// Depth of the deepest floor pocket that overlaps the box lo..hi. Button
// pockets count as their bounding squares, which errs on the safe side.
function pocket_over(lo, hi) = max(concat([0],
    [for (b = buttons) if (overlaps(lo, hi, [b.x, b.y] - [1, 1] * b[2] / 2,
                                    [b.x, b.y] + [1, 1] * b[2] / 2)) pocket_d],
    [for (p = pockets) if (overlaps(lo, hi, p[0], p[1])) p[2]]));
function bowtie_lo(k) = k - [bowtie_len, bowtie_w] / 2;
function bowtie_hi(k) = k + [bowtie_len, bowtie_w] / 2;
function fits_bed(size) = bed_size == [0, 0] || (max(size) <= max(bed_size) && min(size) <= min(bed_size));
function is_pcb_hole(p) = len([for (h = peg_holes) if (h == p) 1]) > 0;

assert(outer_r > 0 && outer_r <= wall, "outer_r must fit within the wall");
assert(plate_w == 0 || plate_w <= case_size.x - 2 * wall, "plate_w is wider than the space between the walls");
assert(plate_min.x < -pcb_clear && plate_min.y < -pcb_clear,
       "case_size or plate_w too small: the plate must overhang the PCB pocket to rest on the ledge");
assert(plate_t > 0 && plate_z >= floor_t + pcb_pocket_d,
       "plate_t over 2 mm would push the plate down onto the PCB");
assert(plate_fit >= 0 && top_fit >= 0 && peg_fit >= 0 && bowtie_fit >= 0 && laser_hole_clear >= 0,
       "fits are clearances and can't be negative");
assert(floor_t - max([pocket_d, for (p = pockets) p[2]]) >= min_floor,
       "a floor pocket leaves less than min_floor");
assert(panel_web >= min_web, str("top panel holes leave a web of only ", panel_web, " mm"));
for (k = switches)
    assert(inside(k, plate_min + [1, 1] * switch_hole / 2, plate_max - [1, 1] * switch_hole / 2),
           str("switch at ", k, " is off the plate"));
for (b = buttons)
    assert(inside(b, [-pcb_clear, -pcb_clear] + [1, 1] * b[2] / 2,
                  pcb_size + [pcb_clear, pcb_clear] - [1, 1] * b[2] / 2),
           str("floor pocket at ", b, " is outside the PCB pocket"));

assert(fastener == "peg" || fastener == "screw", str("unknown fastener \"", fastener, "\""));
assert(fastener == "peg" || len(screws) > 0, "fastener = \"screw\" needs positions in screws");
if (fastener == "peg") {
    assert(csink_h < floor_t, "peg countersink is deeper than the floor");
    assert(slit_w0 >= 0, "peg slit closes up before reaching peg_split_z");
    assert(peg_split_z - (peg_d - peg_flat_w) / 2 >= peg_flange_t, "peg flats run into the flange");
    assert(slit_w_barb >= peg_barb_d - peg_hole_d, "peg barb can't squeeze through its hole");
}
for (p = fasteners) {
    assert(is_pcb_hole(p) ||
           box_dist(p, [-pcb_clear, -pcb_clear], pcb_size + [pcb_clear, pcb_clear]) >= peg_boss_d / 2,
           str("fastener at ", p, " is over the PCB but not at one of its mounting holes"));
    assert(inside(p, top_min + [1, 1] * fastener_head_d / 2, top_max - [1, 1] * fastener_head_d / 2) &&
           inside(p, plate_min + [1, 1] * fastener_head_d / 2, plate_max - [1, 1] * fastener_head_d / 2),
           str("fastener at ", p, " is too close to the edge of the plate or top panel"));
}
for (p = fastener == "screw" ? screws : []) {
    assert(insert_depth(p) >= insert_len, str("no room for the insert under the screw at ", p));
    assert(screw_len(p) - (case_h - insert_top(p)) >= insert_len / 2,
           str("no stock screw length reaches far enough into the insert at ", p));
}
for (c = case_cuts) {
    assert(c - bowtie_len / 2 > case_min.x + wall && c + bowtie_len / 2 < case_max.x - wall,
           str("cut at x=", c, " is too close to the side of the case"));
    for (p = fasteners)
        assert(abs(c - p.x) > fastener_keepout, str("cut at x=", c, " runs too close to the fastener at ", p));
}
if (n_pieces > 2) for (i = [1 : n_pieces - 2])
    assert(case_cuts[i] - case_cuts[i - 1] > bowtie_len,
           "case_cuts must increase, with room for the bowties between them");
if (len(bowtie_y) > 1) for (i = [1 : len(bowtie_y) - 1])
    assert(bowtie_y[i] - bowtie_y[i - 1] > bowtie_w, "bowtie_y must increase, with room between the bowties");
assert(n_pieces == 1 || len(bowtie_y) > 0, "a split case needs bowties: set bowtie_y");
assert(bowtie_waist > 0 && bowtie_waist < bowtie_w, "bowtie_waist must be narrower than bowtie_w");
for (k = bowties) {
    lo = bowtie_lo(k);
    hi = bowtie_hi(k);
    assert(inside(lo, case_min + [wall, wall], case_max - [wall, 0]) &&
           inside(hi, case_min + [wall, wall], case_max - [wall, 0]),
           str("bowtie at ", k, " is off the bottom of the case"));
    assert(floor_t - pocket_over(lo, hi) - bowtie_d >= min_floor,
           str("bowtie at ", k, " leaves less than min_floor under a floor pocket"));
    assert(!overlaps(lo, hi, notch[0], notch[1]), str("bowtie at ", k, " runs into the floor notch"));
    for (p = fasteners)
        assert(box_dist(p, lo, hi) > fastener_keepout, str("bowtie at ", k, " runs into the fastener at ", p));
}
for (i = [1 : n_pieces])
    assert(fits_bed([piece_x[i] - piece_x[i - 1], case_size.y]), str("case piece ", i, " doesn't fit bed_size"));
assert(laser_plate || fits_bed(plate_max - plate_min), "the plate doesn't fit bed_size: narrow it or cut it");
assert(laser_top || fits_bed(top_max - top_min), "the top panel doesn't fit bed_size: narrow it or cut it");

echo(str("case ", case_max - case_min, " x ", case_h, " mm; plate ", plate_max - plate_min, " x ", plate_t,
         " mm at z=", plate_z, "; top ", top_max - top_min, " x ", rim_h, " mm; ", len(switches), " switches"));
echo(str("plate overhangs the PCB by ", -plate_min.x, " mm at each side and ",
         -plate_min.y, " mm at the front"));
if (fastener == "peg")
    echo(str(len(fasteners), " pegs, ", peg_len, " mm long; countersink ", csink_d, " mm x ", csink_h,
             " deep; slit ", slit_w0, " to ", peg_slit_w, " mm"));
else
    echo(str(len(screws), " M3 screws ", screw_lens, " mm long, into inserts in holes ",
             [for (s = screws) insert_depth(s)], " mm deep"));
echo(str("thinnest web between the top panel's holes ", panel_web, " mm"));
if (n_pieces > 1)
    echo(str("case cut at x=", case_cuts, " into pieces ",
             [for (i = [1 : n_pieces]) piece_x[i] - piece_x[i - 1]], " mm wide, with ",
             len(bowties), " bowties"));
echo(printable = printable);
echo(hardware = hardware);

// ---- Case

module case() {
    difference() {
        case_shell();
        // plate seat, open at the top and back
        translate([seat_min.x, seat_min.y, plate_z])
            cube([seat_max.x - seat_min.x, open_back - seat_min.y, plate_t + rim_h + over]);
        // PCB pocket, from the floor up to the plate's ledge
        translate([0, 0, floor_t]) linear_extrude(plate_z - floor_t + over) pcb_pocket_2d();
        floor_pockets();
        translate([notch[0].x, notch[0].y, -over])
            cube([notch[1].x - notch[0].x, notch[1].y - notch[0].y, floor_t + 2 * over]);
        for (h = fasteners) translate(h) {
            if (fastener == "screw") insert_hole(h);
            else peg_hole();
        }
        // bowtie pockets across each cut
        for (k = bowties) translate([k.x, k.y, -over]) linear_extrude(bowtie_d + over) bowtie_2d();
    }
}

// Piece i of a split case, counted from the left.
module case_piece(i) {
    x0 = i == 1 ? case_min.x - over : piece_x[i - 1];
    x1 = i == n_pieces ? case_max.x + over : piece_x[i];
    intersection() {
        case();
        translate([x0, case_min.y - over, -over])
            cube([x1 - x0, case_size.y + 2 * over, case_h + 2 * over]);
    }
}

// Outer shell: the hull of two domed front-corner posts and two side rails.
// A rail is the wall's edge profile run from the front corner to the back,
// trimmed in plan so its back corner is rounded. The result has rounded top
// edges on the front and sides, spherical front corners, and a square back
// edge where the side rounding meets the rounded back corner in a mitre.
module case_shell() {
    r = outer_r;
    run = (case_max.y - r) - (case_min.y + r);  // front corner centre to back corner centre
    hull() for (x = [case_min.x + r, case_max.x - r])
        translate([x, case_min.y + r, 0]) {
            rotate_extrude() edge_profile();
            intersection() {
                // profile stood upright and run toward +Y, past the back
                mirror([0, 1, 0]) rotate([90, 0, 0]) linear_extrude(run + r + over) {
                    edge_profile();
                    mirror([1, 0]) edge_profile();
                }
                // plan trim that rounds the back corner
                linear_extrude(case_h) hull() {
                    translate([-r, 0]) square([2 * r, run]);
                    translate([0, run]) circle(r = r);
                }
            }
        }
}

// Outer wall profile: [0, outer_r] x [0, case_h] with the top outer corner rounded.
module edge_profile() {
    square([outer_r, case_h - outer_r]);
    translate([0, case_h - outer_r]) intersection() {
        circle(r = outer_r);
        square(outer_r);
    }
}

// PCB outline plus clearance: rounded at the front, running out through the back.
module pcb_pocket_2d() {
    hull() {
        for (x = [pcb_corner_r, pcb_size.x - pcb_corner_r])
            translate([x, pcb_corner_r]) circle(r = pcb_corner_r + pcb_clear);
        translate([-pcb_clear, pcb_corner_r])
            square([pcb_size.x + 2 * pcb_clear, open_back - pcb_corner_r]);
    }
}

// Clearance pockets in the floor under the PCB, kept clear of the fasteners.
module floor_pockets() {
    difference() {
        union() {
            for (b = buttons)
                translate([b.x, b.y, floor_t - pocket_d]) cylinder(d = b[2], h = pocket_d + over);
            for (p = pockets)
                translate([p[0].x, p[0].y, floor_t - p[2]])
                    cube([p[1].x - p[0].x, p[1].y - p[0].y, p[2] + over]);
        }
        for (h = fasteners) translate(h) cylinder(d = peg_boss_d, h = floor_t + over);
    }
}

// Bore for a peg, with a 45 degree countersink in the bottom face for its barb.
// It runs up to the plate, so it also goes through the solid ledge outside the
// PCB pocket.
module peg_hole() {
    translate([0, 0, -over]) {
        cylinder(d = peg_hole_d, h = plate_z + 2 * over);
        cylinder(d1 = csink_d + 2 * over, d2 = peg_hole_d, h = csink_h + over);
    }
}

// Hole for the heat-set insert under the screw at p, down from the case
// surface under the plate.
module insert_hole(p) {
    translate([0, 0, insert_top(p) - insert_depth(p)])
        cylinder(d = insert_hole_d, h = insert_depth(p) + over);
}

// ---- Plate

// Plate outline with its holes, for printing or laser cutting.
module plate_2d() {
    difference() {
        translate(plate_min) square(plate_max - plate_min);
        for (k = switches) translate([k.x, k.y]) square(switch_hole, center = true);
        for (h = fasteners) translate(h) circle(d = fastener_hole_d(laser_plate));
        for (x = [notch[0].x, notch[1].x - plate_slot_w])
            translate([x, notch[0].y]) square([plate_slot_w, notch[1].y - notch[0].y]);
    }
}

module plate() linear_extrude(plate_t) plate_2d();

// ---- Top panel

// Top panel outline with its holes, for printing or laser cutting. The art
// print under a cut top is trimmed to the same outline.
module top_2d() {
    difference() {
        translate(top_min) square(top_max - top_min);
        for (b = buttons) translate([b.x, b.y]) circle(d = b[2] + 2 * well_clear);
        for (h = fasteners) translate(h) circle(d = fastener_hole_d(laser_top));
        // one opening over the function row: the key_pitch cell around each key, run out the back
        offset(delta = well_clear) hull()
            for (k = function_keys)
                translate([k.x - key_pitch / 2, k.y - key_pitch / 2])
                    square([key_pitch, open_back - (k.y - key_pitch / 2)]);
    }
}

// Sits on the plate inside the seat, flush with the rim. Screw holes get a
// countersink in the top face; a cut top needs it done by hand.
module top_panel() {
    difference() {
        linear_extrude(rim_h) top_2d();
        if (fastener == "screw") for (h = fasteners) translate([h.x, h.y, rim_h]) screw_countersink();
    }
}

// 90 degree countersink for an M3 countersunk head, its rim at z = 0. The cone
// starts inside the clearance hole and is turned half a facet, so its corners
// don't line up with the hole's where the two meet; lined up, they leave a ring
// of zero-area triangles and the mesh isn't watertight.
module screw_countersink() {
    cs = (screw_head_d - screw_clear_d) / 2;  // depth
    rotate([0, 0, 180 / $fn]) translate([0, 0, -cs - 0.5])
        cylinder(d1 = screw_clear_d - 1, d2 = screw_head_d + 2 * over, h = cs + 0.5 + over);
}

// ---- Peg

// Push-pin peg, flange down as printed. It goes in flange up: the tip passes
// through the top panel, plate and floor, then the slit halves spring open
// into the countersink.
module peg() {
    difference() {
        union() {
            cylinder(d = peg_flange_d, h = peg_flange_t);
            intersection() {
                peg_body();
                peg_flats();
            }
        }
        peg_slit();
    }
}

// Round shaft with the barb at the tip.
module peg_body() {
    z = peg_len - barb_len;
    rotate_extrude() polygon([
        [0, 0], [peg_d / 2, 0], [peg_d / 2, z],
        [peg_barb_d / 2, z + barb_flank], [peg_barb_d / 2, z + barb_flank + peg_barb_land],
        [peg_d / 2, peg_len], [0, peg_len]
    ]);
}

// What the two flats leave: a slab peg_flat_w wide, plus a 45 degree cone whose
// radius is peg_flat_w / 2 at peg_split_z, so the flats run out into the round
// shaft just below it.
module peg_flats() {
    translate([-peg_barb_d, -peg_flat_w / 2, -over])
        cube([2 * peg_barb_d, peg_flat_w, peg_len + 2 * over]);
    cylinder(r1 = peg_split_z + peg_flat_w / 2, r2 = 0, h = peg_split_z + peg_flat_w / 2);
}

// V slit that splits the tip into two halves: peg_slit_w wide at the tip,
// narrowing by peg_slit_angle on each side down to peg_split_z.
module peg_slit() {
    h = peg_len + over - peg_split_z;  // from the root to just past the tip
    w1 = slit_w(peg_len + over);
    translate([0, 0, peg_split_z]) rotate([90, 0, 0])
        linear_extrude(peg_barb_d + 2 * over, center = true)
            polygon([[-slit_w0 / 2, 0], [slit_w0 / 2, 0], [w1 / 2, h], [-w1 / 2, h]]);
}

// ---- Screw (bought; modelled for the assembly and the interference check)

// M3 countersunk screw l long overall, head up, the head's top at z = 0. The
// head is drawn 0.2 mm under screw_head_d so it clears the countersink's facets.
module screw(l) {
    head_d = screw_head_d - 0.2;
    cs = (head_d - 3) / 2;  // the head's cone, down to the 3 mm shank
    translate([0, 0, -cs]) cylinder(d1 = 3, d2 = head_d, h = cs);
    translate([0, 0, -l]) cylinder(d = 3, h = l - cs);
}

// ---- Bowtie

// Bowtie outline centred on a cut, its long axis across the cut.
module bowtie_2d() {
    polygon([[-bowtie_len / 2, -bowtie_w / 2], [0, -bowtie_waist / 2], [bowtie_len / 2, -bowtie_w / 2],
             [bowtie_len / 2, bowtie_w / 2], [0, bowtie_waist / 2], [-bowtie_len / 2, bowtie_w / 2]]);
}

// Bowtie key, flat as printed. It bridges a cut from below, seated in the half
// pockets of the pieces on either side. Glue it or press it in.
module bowtie() linear_extrude(bowtie_d - bowtie_fit) offset(delta = -bowtie_fit) bowtie_2d();

// ---- Assembly

module plate_in_place() translate([0, 0, plate_z]) plate();
module top_in_place() translate([0, 0, plate_top_z]) top_panel();

// Pegs as installed: flange up on the top panel, tip flush with the case bottom.
module pegs_in_place() {
    for (h = fasteners) translate([h.x, h.y, peg_len]) rotate([180, 0, 0]) peg();
}

// Screws as installed: heads flush with the top face.
module screws_in_place() {
    for (s = screws) translate([s.x, s.y, case_h]) screw(screw_len(s));
}

module fasteners_in_place() {
    if (fastener == "screw") screws_in_place();
    else pegs_in_place();
}

// Bowties as installed: against the top of their pockets, so they can't stand proud.
module bowties_in_place() {
    for (k = bowties) translate([k.x, k.y, bowtie_fit]) bowtie();
}

module assembly() {
    if (n_pieces == 1) color("#e8a33d") case();
    else for (i = [1 : n_pieces]) color(i % 2 == 1 ? "#e8a33d" : "#c98a2e") case_piece(i);
    color(laser_plate ? "#c0c4c8" : "#8a96a3") plate_in_place();
    color(laser_top ? [0.75, 0.88, 0.95, 0.6] : "#d9d2c3") top_in_place();
    color("#4a4a4a") fasteners_in_place();
    color("#4a4a4a") bowties_in_place();
}

// Overlap between parts. Must render empty; touching faces are fine.
module interference() {
    intersection() { case(); plate_in_place(); }
    intersection() { case(); top_in_place(); }
    intersection() { plate_in_place(); top_in_place(); }
    intersection() { case(); fasteners_in_place(); }
    intersection() { plate_in_place(); fasteners_in_place(); }
    intersection() { top_in_place(); fasteners_in_place(); }
    if (len(bowties) > 0) intersection() { case(); bowties_in_place(); }
    if (n_pieces > 1) for (i = [1 : n_pieces - 1]) intersection() { case_piece(i); case_piece(i + 1); }
}

case_part = [for (i = [1 : n_pieces]) if (part == str("case", i)) i];  // [i] when part names a piece

if (part == "case") case();
else if (len(case_part) > 0) case_piece(case_part[0]);
else if (part == "plate") plate();
else if (part == "plate_2d") plate_2d();
else if (part == "top") top_panel();
else if (part == "top_2d") top_2d();
else if (part == "peg") peg();
else if (part == "bowtie") bowtie();
else if (part == "assembly") assembly();
else if (part == "interference") interference();
else assert(false, str("unknown part \"", part, "\""));
