/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2016 HPCC Systems®.  All rights reserved.
############################################################################## */

// Restrict it to Thor in Regression Test Engine
//nohthor
//noroxie

// Confidence test for PBblas -- Fast running test that exercises:
// - Multiply
// - Solve
// - Factorization
//

IMPORT $.^ as PBblas;
IMPORT PBblas.internal as int;
IMPORT PBblas.MatUtils;
IMPORT PBblas.Types;
IMPORT int.Types as iTypes;
IMPORT Std.BLAS;
IMPORT ^.test as Tests;
IMPORT Tests.MakeTestMatrix as tm;

matrix_t := iTypes.matrix_t;
Triangle := Types.Triangle;
Diagonal := Types.Diagonal;
Upper  := Triangle.Upper;
Lower  := Triangle.Lower;
Layout_Part := iTypes.Layout_Part;
Side := Types.Side;

// Override BlockDimensions defaults to allow test with smaller matrixes
max_partition_size_or := 1000;
override := #STORED('BlockDimensions_max_partition_size', max_partition_size_or);

// TEST 1 -- Multiply two matrixes and then solve for an original

// Note:  For solve, only two dimensions are needed
// For solve AX, A is N x N and B/X is N x M
// For solve XA, B/X is M x N and A is N x N
N1 := 59;  // 9 x 9  should give a single partition
M1 := 67;

PreA1 := tm.Random(N1, N1, 1.0, 1);
A1 := PBblas.gemm(TRUE, FALSE, 1.0,
             PreA1, PreA1);    // Make a positive definite symmetric matrix of full rank
X1 := tm.Random(N1, M1, 1.0, 1);
// Calculate the transpose of X to use for XA testing
X1_T := MatUtils.Transpose(X1);
// E computes the B value for AX (i.e. AX).  Solving for AX = E should return X
E1 := PBblas.gemm(FALSE, FALSE, 1.0,
             A1, X1);
// F computes the B value for XA (i.e. X**TA).  Solving for XA = F should return X**T
F1 := PBblas.gemm(FALSE, FALSE, 1.0,
             X1_T, A1);


// Solve AX using Cholesky factorization
C_L1 := PBblas.potrf(Lower, A1);
C_S1 := PBblas.trsm(Side.Ax, Lower, FALSE, Diagonal.NotUnitTri,
                      1.0, C_L1, E1);
C_T1 := PBblas.trsm(Side.Ax, Upper, TRUE, Diagonal.NotUnitTri,
                      1.0, C_L1, C_S1);
test_11 := Tests.DiffReport.Compare_Cells('TEST1 -- Multiply, Factor, Solve', X1, C_T1);


result  := test_11;

EXPORT ConfTest := WHEN(OUTPUT(result,{testname, errors}), override);
