/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2016 HPCC Systems®.  All rights reserved.
############################################################################## */
/**
  * Performance test for myriad multiplication.  Performs a myriad multiply
  * operation to observer performance.  MultiplyPerfMyrPrep.ecl should be run
  * previous to running this test to stage the data.  Test size is passed in
  * as a stored parameter using the eclcc -X to pass the test_size (see below)
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

// Read the a and b test files and multiply them together.

a_s := DATASET('MultiplyPerfMyr_A_s.dat', Layout_Cell, FLAT);
b_s := DATASET('MultiplyPerfMyr_B_s.dat', Layout_Cell, FLAT);
a_m := DATASET('MultiplyPerfMyr_A_m.dat', Layout_Cell, FLAT);
b_m := DATASET('MultiplyPerfMyr_B_m.dat', Layout_Cell, FLAT);
a_l := DATASET('MultiplyPerfMyr_A_l.dat', Layout_Cell, FLAT);
b_l := DATASET('MultiplyPerfMyr_B_l.dat', Layout_Cell, FLAT);
a_cells := MAP(test_size = 1 => a_s, test_size = 2 => a_m, a_l);
b_cells := MAP(test_size = 1 => b_s, test_size = 2 => b_m, b_l);

// Setup to make calls to gemm

// Make an empty C matrix
c_cells := DATASET([], Layout_Cell);

cell_results := PBblas.gemm(FALSE, FALSE, 1.0, a_cells, b_cells);

EXPORT MultiplyPerfMyr := COUNT(cell_results);
