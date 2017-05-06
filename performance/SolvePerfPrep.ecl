/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2016 HPCC Systems®.  All rights reserved.
############################################################################## */

// Test the performance of the triangular solver
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
Layout_Part := iTypes.Layout_Part;
Side := Types.Side;
Layout_Cell := Types.Layout_Cell;

// Preparation Performance test for a full (rectangular) matrix Solve
// Creates the files for use by SolvePerf

// Test size is 1 (small), 2 (medium) or 3 (large)
UNSIGNED test_size := 1 : STORED('test_size'); // default is "small"


// Test sizes small: 1000 x 1000, medium: 10000 x 10000, large: 10000 x 100000
// Rows and columns of A matrix
N1 := 1000;
N2 := 10000;
N3 := 10000;
// Columns of B matrix and Result (side=Ax) or Rows of B matrix and result (side=xA)
M1 := 1000;
M2 := 10000;
M3 := 100000;

A_s := tm.RandomMatrix(N1, N1, 1.0, 1);
A_m := tm.RandomMatrix(N2, N2, 1.0, 1);
A_l := tm.RandomMatrix(N3, N3, 1.0, 1);

X_ax_s := tm.RandomMatrix(N1, M1, 1.0, 1);
X_xa_s := tm.RandomMatrix(M1, N1, 1.0, 1);
X_ax_m := tm.RandomMatrix(N2, M2, 1.0, 1);
X_xa_m := tm.RandomMatrix(M2, N2, 1.0, 1);
X_ax_l := tm.RandomMatrix(N3, M3, 1.0, 1);
X_xa_l := tm.RandomMatrix(M3, N3, 1.0, 1);


B_ax_s := PBblas.gemm(FALSE, FALSE, 1.0,
             A_s, X_ax_s);
B_xa_s := PBblas.gemm(FALSE, FALSE, 1.0,
             X_xa_s, A_s);
B_ax_m := PBblas.gemm(FALSE, FALSE, 1.0,
             A_m, X_ax_m);
B_xa_m := PBblas.gemm(FALSE, FALSE, 1.0,
             X_xa_m, A_m);
B_ax_l := PBblas.gemm(FALSE, FALSE, 1.0,
             A_l, X_ax_l);
B_xa_l := PBblas.gemm(FALSE, FALSE, 1.0,
             X_xa_l, A_l);

OUTPUT(A_s,, 'SolvePerf_A_s.dat', OVERWRITE);
OUTPUT(A_m,, 'SolvePerf_A_m.dat', OVERWRITE);
OUTPUT(A_l,, 'SolvePerf_A_l.dat', OVERWRITE);
OUTPUT(B_ax_s,, 'SolvePerf_B_ax_s.dat', OVERWRITE);
OUTPUT(B_xa_s,, 'SolvePerf_B_xa_s.dat', OVERWRITE);
OUTPUT(B_ax_m,, 'SolvePerf_B_ax_m.dat', OVERWRITE);
OUTPUT(B_xa_m,, 'SolvePerf_B_xa_m.dat', OVERWRITE);
OUTPUT(B_ax_l,, 'SolvePerf_B_ax_l.dat', OVERWRITE);
OUTPUT(B_xa_l,, 'SolvePerf_B_xa_l.dat', OVERWRITE);
