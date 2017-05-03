/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2016 HPCC Systems®.  All rights reserved.
############################################################################## */
/**
  * Performance test for multiplication.  Performs a large myriad multiply
  * operation to observer performance.
  */

IMPORT $.^ as PBblas;
IMPORT PBblas.internal as int;
IMPORT int.Types as iTypes;
IMPORT PBblas.Types;
IMPORT int.MatDims;
IMPORT PBblas.test as Tests;
IMPORT Tests.MakeTestMatrix as tm;

Layout_Cell := Types.Layout_Cell;
Layout_Part := iTypes.Layout_Part;

// Test configuration Parameters -- modify these to vary the testing

N := 1000;   // Number of rows in A matrix and result
M := 1000;      // Number of columns in A matrix and rows in B matrix
P := 1000; // Number of columns in B matrix and result

// Small medium and large sizes
Myriad_Count_s := 100;
Myriad_Count_m := 500;
Myriad_count_l := 1000;


density := 1.0; // 1.0 is fully dense. 0.0 is empty.
// End of config parameters

// Generate test data for A and B matrixes in the cell form

// Setup to make calls to PB_dgemm
a_cells := tm.Matrix(N, M, density, 1);
b_cells := tm.Matrix(M, P, density, 1);

// Make an empty C matrix
c_cells := DATASET([], Layout_Cell);

Layout_Cell make_myriad(Layout_Cell d, UNSIGNED c) := TRANSFORM
  SELF.wi_id := c;
  SELF       := d;
END;

a_myr_s := NORMALIZE(a_cells, Myriad_Count_s, make_myriad(LEFT, COUNTER));
b_myr_s := NORMALIZE(b_cells, Myriad_Count_s, make_myriad(LEFT, COUNTER));
a_myr_m := NORMALIZE(a_cells, Myriad_Count_m, make_myriad(LEFT, COUNTER));
b_myr_m := NORMALIZE(b_cells, Myriad_Count_m, make_myriad(LEFT, COUNTER));
a_myr_l := NORMALIZE(a_cells, Myriad_Count_l, make_myriad(LEFT, COUNTER));
b_myr_l := NORMALIZE(b_cells, Myriad_Count_l, make_myriad(LEFT, COUNTER));

OUTPUT(a_myr_s,,'MultiplyPerfMyr_A_s.dat', OVERWRITE);
OUTPUT(b_myr_s,,'MultiplyPerfMyr_B_s.dat', OVERWRITE);
OUTPUT(a_myr_m,,'MultiplyPerfMyr_A_m.dat', OVERWRITE);
OUTPUT(b_myr_m,,'MultiplyPerfMyr_B_m.dat', OVERWRITE);
OUTPUT(a_myr_l,,'MultiplyPerfMyr_A_l.dat', OVERWRITE);
OUTPUT(b_myr_l,,'MultiplyPerfMyr_B_l.dat', OVERWRITE);
