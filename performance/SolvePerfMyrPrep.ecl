/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2016 HPCC Systems®.  All rights reserved.
############################################################################## */

// Test the performance of the triangular solver (Myriad). This module prepares
// the test (creates the data).  It should be run before SolvePerfMyr.ecl
IMPORT $.^ as PBblas;
IMPORT PBblas.internal as int;
IMPORT PBblas.MatUtils;
IMPORT PBblas.Types;
IMPORT int.Types as iTypes;
IMPORT PBblas.test as Tests;
IMPORT Tests.MakeTestMatrix as tm;

matrix_t := iTypes.matrix_t;
Triangle := Types.Triangle;
Diagonal := Types.Diagonal;
Upper  := Triangle.Upper;
Lower  := Triangle.Lower;
Layout_Cell := types.Layout_Cell;
Side := Types.Side;


// Performance test for a full (rectangular) matrix Solve

// Test size is 1 (small), 2 (medium) or 3 (large)
UNSIGNED1 test_size := 1 : STORED('test_size'); // default is "small"

N := 1000; // Rows and columns of A matrix, and rows of B and result
M := 1000;  // Columns of B matrix and Result.

// Small medium and large sizes (number of myriad work items to replicate)
Myriad_Count_s := 50;
Myriad_Count_m := 100;
Myriad_count_l := 500;

A := tm.RandomMatrix(N, N, 1.0, 1);

X := tm.RandomMatrix(N, M, 1.0, 1);

B0 := PBblas.gemm(FALSE, FALSE, 1.0, A, X);

B := DISTRIBUTE(B0);

Layout_Cell make_myriad(Layout_Cell d, UNSIGNED c) := TRANSFORM
  SELF.wi_id := c;
  SELF       := d;
END;

A_myr_s := NORMALIZE(A, Myriad_count_s, make_myriad(LEFT, COUNTER));
B_myr_s := NORMALIZE(B, Myriad_count_s, make_myriad(LEFT, COUNTER));
A_myr_m := NORMALIZE(A, Myriad_count_m, make_myriad(LEFT, COUNTER));
B_myr_m := NORMALIZE(B, Myriad_count_m, make_myriad(LEFT, COUNTER));
A_myr_l := NORMALIZE(A, Myriad_count_l, make_myriad(LEFT, COUNTER));
B_myr_l := NORMALIZE(B, Myriad_count_l, make_myriad(LEFT, COUNTER));

OUTPUT(A_myr_s,, 'SolvePerfMyr_A_s.dat', OVERWRITE);
OUTPUT(B_myr_s,, 'SolvePerfMyr_B_s.dat', OVERWRITE);
OUTPUT(A_myr_m,, 'SolvePerfMyr_A_m.dat', OVERWRITE);
OUTPUT(B_myr_m,, 'SolvePerfMyr_B_m.dat', OVERWRITE);
OUTPUT(A_myr_l,, 'SolvePerfMyr_A_l.dat', OVERWRITE);
OUTPUT(B_myr_l,, 'SolvePerfMyr_B_l.dat', OVERWRITE);
