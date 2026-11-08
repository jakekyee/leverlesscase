// ArtCase: case, switch plate, top panel and push-pin pegs for a leverless controller.
//
// Rebuilt from ArtCase-case.step, ArtCase-plate.step and ArtCase-peg.step.
// X and Y follow the STEP files: the origin is the PCB's front-left corner and
// +Y runs toward the open back edge. Z = 0 is the bottom of the case.
// The STEP parts have 0.4 mm cosmetic fillets on most edges. Those are left
// out; every other dimension follows the STEP files.
// The top panel isn't in the STEP files. It follows the top of the rect case
// (granolasummitcase_rect.blend): round wells at the buttons and one opening
// for the function row. It fills the space above the plate, so the peg
// flanges clamp it down.
// case_size sets the outer footprint. Three settings, all off by default, make
// a case too big for the printer printable: plate_w narrows the plate and top
// panel (the case fills the strips beside them up to the rim), case_cuts splits
// the case into pieces joined by bowtie keys set into its underside, and
// extra_pegs adds pegs outside the PCB. artcase_big.scad uses all three for a
// 297 x 210 mm (A4) case.
//
// Check from the repo root (see ../openscad-stuff/README.md):
//   python ../openscad-stuff/scadloop.py scad/artcase.scad -D part=\"case\"
//   python ../openscad-stuff/scadloop.py scad/artcase.scad -D part=\"interference\" --expect-empty
//   python ../openscad-stuff/scadloop.py scad/artcase.scad -D part=\"assembly\" --preview
// The plate, top panel, pegs and bowties fit line-to-line, as in the STEP files
// (every *_fit is 0). The parts touch, so the merged assembly mesh has seams
// where they meet and fails the watertight check; that is expected. The
// interference check is the real fit test.

/* [Selection] */
// A split case (see case_cuts) also has one part per piece, "case1", "case2"
// and so on from the left; "case" is still the whole case.
part = "case";  // [case, plate, top, peg, bowtie, assembly, interference]

/* [PCB] */
pcb_size = [211, 125];  // footprint; the case and plate are flush with its back edge
pcb_corner_r = 4.5;     // corner radius at the front
pcb_clear = 0.5;        // gap around the PCB in its pocket
pcb_pocket_d = 1.8;     // pocket depth, from the floor up to the plate ledge

/* [Plate] */
plate_t = 2;
switch_hole = 14;       // square switch cutout
plate_slot_w = 3;       // width of the two slots above the ends of the floor notch
plate_fit = 0;          // gap per side between plate and case (0 = as designed)
// Width of the plate and top panel, centred on the PCB. 0 fills the space
// between the walls, as designed; anything narrower leaves a strip of case on
// each side, solid up to the rim.
plate_w = 0;

/* [Top panel] */
well_clear = 0;         // added per side to the wells and the function-row opening
key_pitch = 18;         // function-row key spacing; the opening spans one cell per key
min_web = 1.2;          // thinnest wall allowed between round holes in the panel

/* [Case] */
// Outer footprint [x, y]. The PCB stays centred left to right and flush with
// the open back, so extra size goes to the left and right equally and to the front.
case_size = [251.8, 145.4];
wall = 4;               // wall thickness around the plate
floor_t = 6;            // floor thickness under the PCB
rim_h = 4.6;            // wall height above the plate
outer_r = 3.6;          // radius of the outer corners and top edges
pocket_d = 2.4;         // depth of the clearance pockets under the PCB
peg_boss_d = 10;        // floor pockets stay out of this circle around each peg hole
min_floor = 1;          // thinnest floor allowed under a pocket

/* [Case split] */
case_cuts = [];         // x of each cut through the case, left to right; [] keeps it whole
bowtie_y = [20, 95];    // y of the bowtie keys set into the case bottom across each cut
bowtie_len = 30;        // bowtie length, across the cut
bowtie_w = 16;          // bowtie width at its ends
bowtie_waist = 8;       // bowtie width at the cut
bowtie_d = 2;           // depth of the bowtie pockets, and thickness of the bowties
bowtie_fit = 0;         // gap per side around each bowtie, which is also this much thinner (0 = line-to-line)

/* [Pegs] */
peg_d = 8;              // shaft diameter
peg_fit = 0;            // hole clearance per side (0 = as designed)
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
// Pegs inside the PCB outline, which pass through the PCB, and any more outside
// it, for example in the area a bigger case_size adds.
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
pegs = concat(peg_holes, extra_pegs);       // every peg
case_min = [(pcb_size.x - case_size.x) / 2, pcb_size.y - case_size.y];
case_max = [(pcb_size.x + case_size.x) / 2, pcb_size.y];
// Recess in the case that the plate sits in: between the walls, or plate_w wide
// and centred on the PCB. The back is open, so neither the wall nor the fit
// applies there.
seat_min = [plate_w > 0 ? (pcb_size.x - plate_w) / 2 : case_min.x + wall, case_min.y + wall];
seat_max = [plate_w > 0 ? (pcb_size.x + plate_w) / 2 : case_max.x - wall, case_max.y];
plate_min = seat_min + [plate_fit, plate_fit];
plate_max = seat_max - [plate_fit, 0];
plate_z = floor_t + pcb_pocket_d;  // the plate rests on the ledge here
case_h = plate_z + plate_t + rim_h;

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

// Round holes in the top panel [x, y, d]: a well per button and a hole per peg.
panel_holes = concat([for (b = buttons) [b.x, b.y, b[2] + 2 * well_clear]],
                     [for (h = pegs) [h.x, h.y, peg_hole_d]]);
// Edge-to-edge distance between two round holes [x, y, d].
function web(a, b) = norm([a.x - b.x, a.y - b.y]) - (a[2] + b[2]) / 2;
panel_web = min([for (i = [0 : len(panel_holes) - 2]) for (j = [i + 1 : len(panel_holes) - 1])
                 web(panel_holes[i], panel_holes[j])]);

// Case pieces: piece i (from 1) spans x = piece_x[i - 1] to piece_x[i]. Every
// cut gets a bowtie at each bowtie_y.
piece_x = concat([case_min.x], case_cuts, [case_max.x]);
n_pieces = len(case_cuts) + 1;
bowties = [for (c = case_cuts, y = bowtie_y) [c, y]];

// Parts to print and how many of each. scad/export_stls.py reads this echo.
printable = concat(
    n_pieces == 1 ? [["case", 1]] : [for (i = [1 : n_pieces]) [str("case", i), 1]],
    [["plate", 1], ["top", 1], ["peg", len(pegs)]],
    len(bowties) > 0 ? [["bowtie", len(bowties)]] : []);

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

assert(outer_r > 0 && outer_r <= wall, "outer_r must fit within the wall");
assert(plate_w == 0 || plate_w <= case_size.x - 2 * wall, "plate_w is wider than the space between the walls");
assert(plate_min.x < -pcb_clear && plate_min.y < -pcb_clear,
       "case_size or plate_w too small: the plate must overhang the PCB pocket to rest on the ledge");
assert(plate_fit >= 0 && peg_fit >= 0 && bowtie_fit >= 0, "fits are clearances and can't be negative");
assert(floor_t - max([pocket_d, for (p = pockets) p[2]]) >= min_floor,
       "a floor pocket leaves less than min_floor");
assert(csink_h < floor_t, "peg countersink is deeper than the floor");
assert(slit_w0 >= 0, "peg slit closes up before reaching peg_split_z");
assert(peg_split_z - (peg_d - peg_flat_w) / 2 >= peg_flange_t, "peg flats run into the flange");
assert(slit_w_barb >= peg_barb_d - peg_hole_d, "peg barb can't squeeze through its hole");
assert(panel_web >= min_web, str("top panel holes leave a web of only ", panel_web, " mm"));
for (k = switches)
    assert(inside(k, plate_min + [1, 1] * switch_hole / 2, plate_max - [1, 1] * switch_hole / 2),
           str("switch at ", k, " is off the plate"));
for (b = buttons)
    assert(inside(b, [-pcb_clear, -pcb_clear] + [1, 1] * b[2] / 2,
                  pcb_size + [pcb_clear, pcb_clear] - [1, 1] * b[2] / 2),
           str("floor pocket at ", b, " is outside the PCB pocket"));
for (p = extra_pegs) {
    assert(box_dist(p, [-pcb_clear, -pcb_clear], pcb_size + [pcb_clear, pcb_clear]) >= peg_boss_d / 2,
           str("extra peg at ", p, " is over the PCB"));
    assert(inside(p, plate_min + [1, 1] * peg_flange_d / 2, plate_max - [1, 1] * peg_flange_d / 2),
           str("extra peg at ", p, " is off the plate"));
}
for (c = case_cuts) {
    assert(c - bowtie_len / 2 > case_min.x + wall && c + bowtie_len / 2 < case_max.x - wall,
           str("cut at x=", c, " is too close to the side of the case"));
    for (p = pegs)
        assert(abs(c - p.x) > csink_d / 2, str("cut at x=", c, " runs through the peg countersink at ", p));
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
    for (p = pegs)
        assert(box_dist(p, lo, hi) > csink_d / 2, str("bowtie at ", k, " runs into the peg countersink at ", p));
}
for (i = [1 : n_pieces])
    assert(fits_bed([piece_x[i] - piece_x[i - 1], case_size.y]), str("case piece ", i, " doesn't fit bed_size"));
assert(fits_bed(plate_max - plate_min), "the plate and top panel don't fit bed_size");

echo(str("case ", case_max - case_min, " x ", case_h, " mm; plate ", plate_max - plate_min,
         " x ", plate_t, " mm at z=", plate_z, "; ", len(switches), " switches"));
echo(str("plate overhangs the PCB by ", -plate_min.x, " mm at each side and ",
         -plate_min.y, " mm at the front"));
echo(str("peg ", peg_len, " mm long; countersink ", csink_d, " mm x ", csink_h,
         " deep; slit ", slit_w0, " to ", peg_slit_w, " mm"));
echo(str("top panel ", rim_h, " mm thick; thinnest web between its holes ", panel_web, " mm"));
if (n_pieces > 1)
    echo(str("case cut at x=", case_cuts, " into pieces ",
             [for (i = [1 : n_pieces]) piece_x[i] - piece_x[i - 1]], " mm wide, with ",
             len(bowties), " bowties"));
echo(printable = printable);

// ---- Case

module case() {
    difference() {
        case_shell();
        // plate seat, open at the top and back
        translate([seat_min.x, seat_min.y, plate_z])
            cube([seat_max.x - seat_min.x, open_back - seat_min.y, plate_t + rim_h + over]);
        translate([0, 0, floor_t]) linear_extrude(pcb_pocket_d + over) pcb_pocket_2d();
        floor_pockets();
        translate([notch[0].x, notch[0].y, -over])
            cube([notch[1].x - notch[0].x, notch[1].y - notch[0].y, floor_t + 2 * over]);
        for (h = pegs) translate(h) peg_hole();
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

// Clearance pockets in the floor under the PCB, kept clear of the peg holes.
module floor_pockets() {
    difference() {
        union() {
            for (b = buttons)
                translate([b.x, b.y, floor_t - pocket_d]) cylinder(d = b[2], h = pocket_d + over);
            for (p = pockets)
                translate([p[0].x, p[0].y, floor_t - p[2]])
                    cube([p[1].x - p[0].x, p[1].y - p[0].y, p[2] + over]);
        }
        for (h = pegs) translate(h) cylinder(d = peg_boss_d, h = floor_t + over);
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

// ---- Plate

module plate() {
    linear_extrude(plate_t) difference() {
        translate(plate_min) square(plate_max - plate_min);
        for (k = switches) translate([k.x, k.y]) square(switch_hole, center = true);
        for (h = pegs) translate(h) circle(d = peg_hole_d);
        for (x = [notch[0].x, notch[1].x - plate_slot_w])
            translate([x, notch[0].y]) square([plate_slot_w, notch[1].y - notch[0].y]);
    }
}

// ---- Top panel

// Sits on the plate inside the seat, flush with the rim.
module top_panel() {
    linear_extrude(rim_h) difference() {
        translate(plate_min) square(plate_max - plate_min);
        for (h = panel_holes) translate([h.x, h.y]) circle(d = h[2]);
        // one opening over the function row: the key_pitch cell around each key, run out the back
        offset(delta = well_clear) hull()
            for (k = function_keys)
                translate([k.x - key_pitch / 2, k.y - key_pitch / 2])
                    square([key_pitch, open_back - (k.y - key_pitch / 2)]);
    }
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
module top_in_place() translate([0, 0, plate_z + plate_t]) top_panel();

// Pegs as installed: flange up on the top panel, tip flush with the case bottom.
module pegs_in_place() {
    for (h = pegs) translate([h.x, h.y, peg_len]) rotate([180, 0, 0]) peg();
}

// Bowties as installed: against the top of their pockets, so they can't stand proud.
module bowties_in_place() {
    for (k = bowties) translate([k.x, k.y, bowtie_fit]) bowtie();
}

module assembly() {
    if (n_pieces == 1) color("#e8a33d") case();
    else for (i = [1 : n_pieces]) color(i % 2 == 1 ? "#e8a33d" : "#c98a2e") case_piece(i);
    color("#8a96a3") plate_in_place();
    color("#d9d2c3") top_in_place();
    color("#4a4a4a") pegs_in_place();
    color("#4a4a4a") bowties_in_place();
}

// Overlap between parts. Must render empty; touching faces are fine.
module interference() {
    intersection() { case(); plate_in_place(); }
    intersection() { case(); top_in_place(); }
    intersection() { case(); pegs_in_place(); }
    intersection() { plate_in_place(); top_in_place(); }
    intersection() { plate_in_place(); pegs_in_place(); }
    intersection() { top_in_place(); pegs_in_place(); }
    if (len(bowties) > 0) intersection() { case(); bowties_in_place(); }
    if (n_pieces > 1) for (i = [1 : n_pieces - 1]) intersection() { case_piece(i); case_piece(i + 1); }
}

case_part = [for (i = [1 : n_pieces]) if (part == str("case", i)) i];  // [i] when part names a piece

if (part == "case") case();
else if (len(case_part) > 0) case_piece(case_part[0]);
else if (part == "plate") plate();
else if (part == "top") top_panel();
else if (part == "peg") peg();
else if (part == "bowtie") bowtie();
else if (part == "assembly") assembly();
else if (part == "interference") interference();
else assert(false, str("unknown part \"", part, "\""));
