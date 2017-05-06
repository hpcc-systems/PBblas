/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2016 HPCC Systems®.  All rights reserved.
############################################################################## */
/**
  * Performance test for multiplication.  Performs a large multiply
  * operation to observer performance.  Data is staged by MultiplyPerfPrep.ecl
  * which should always be run before this test.  Test size is controlled by
  * passing test_size as a STORED parameter e.g. via eclcc -X<test_size>.  See
  * test_size below.
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

// Test size is 1 (small), 2 (medium) or 3 (large)
UNSIGNED test_size := 1 : STORED('test_size'); // default is "small"

A_s := DATASET('MultiplyPerf_A_s.dat', Layout_Cell, FLAT);
A_m := DATASET('MultiplyPerf_A_m.dat', Layout_Cell, FLAT);
A_l := DATASET('MultiplyPerf_A_l.dat', Layout_Cell, FLAT);

B_s := DATASET('MultiplyPerf_B_s.dat', Layout_Cell, FLAT);
B_m := DATASET('MultiplyPerf_B_m.dat', Layout_Cell, FLAT);
B_l := DATASET('MultiplyPerf_B_l.dat', Layout_Cell, FLAT);

A_cells := MAP(test_size = 1 => A_s, test_size = 2 => A_m, A_l);
B_cells := MAP(test_size = 1 => B_s, test_size = 2 => B_m, B_l);

// Setup to make calls to gemm

// Make an empty C matrix
c_cells := DATASET([], Layout_Cell);

cell_results := PBblas.gemm(FALSE, False, 1.0, A_cells, B_cells);

EXPORT MultiplyPerf := COUNT(cell_results);

