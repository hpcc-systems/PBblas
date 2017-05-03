/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2016 HPCC Systems®.  All rights reserved.
############################################################################## */
/**
  * Performance test for multiplication.  Performs a large  multiply
  * operation to observe performance.
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


setOptions := #OPTION('hthorDiskWriteSizeLimit', 45000000000);


// Test configuration Parameters -- modify these to vary the testing
N1 := 1000;   // Number of rows in A matrix and result
M1 := 1000;      // Number of columns in A matrix and rows in B matrix
P1 := 10000; // Number of columns in B matrix and resultN3 := 10000;
N2 := 5000;   // Number of rows in A matrix and result
M2 := 5000;      // Number of columns in A matrix and rows in B matrix
P2 := 50000; // Number of columns in B matrix and result
N3 := 10000;   // Number of rows in A matrix and result
M3 := 10000;      // Number of columns in A matrix and rows in B matrix
P3 := 100000; // Number of columns in B matrix and result

density := 1.0; // 1.0 is fully dense. 0.0 is empty.
// End of config parameters

// Generate test data for A and B matrixes in the cell form

// Setup to make calls to gemm
A_s := WHEN(tm.Matrix(N1, M1, density, 1), setOptions); // Set the hthorDiskWriteSizeLimit
B_s := tm.Matrix(M1, P1, density, 1);
A_m := tm.Matrix(N2, M2, density, 1);
B_m := tm.Matrix(M2, P2, density, 1);
A_l := tm.Matrix(N3, M3, density, 1);
B_l := tm.Matrix(M3, P3, density, 1);

OUTPUT(A_s,, 'MultiplyPerf_A_s.dat', OVERWRITE);
OUTPUT(B_s,, 'MultiplyPerf_B_s.dat', OVERWRITE);
OUTPUT(A_m,, 'MultiplyPerf_A_m.dat', OVERWRITE);
OUTPUT(B_m,, 'MultiplyPerf_B_m.dat', OVERWRITE);
OUTPUT(A_l,, 'MultiplyPerf_A_l.dat', OVERWRITE);
OUTPUT(B_l,, 'MultiplyPerf_B_l.dat', OVERWRITE);
