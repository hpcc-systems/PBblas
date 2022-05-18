/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2022 HPCC Systems®.  All rights reserved.
############################################################################## */

// Restrict it to Thor in Regression Test Engine
//nohthor
//noroxie

// Confidence test for PBblas -- Fast running test that exercises:
// - Addition
// - Multiply
// - Solve
// - Factorization

IMPORT $.^ as PBblas;
IMPORT PBblas.MatUtils;
IMPORT PBblas.Types;
IMPORT PBblas.Converted as conv;
IMPORT $.^.test as Tests;
IMPORT Tests.MakeTestMatrix as tm;

Triangle := Types.Triangle;
Diagonal := Types.Diagonal;
Upper  := Triangle.Upper;
Lower  := Triangle.Lower;
Side := Types.Side;

// Override BlockDimensions defaults to allow test with smaller matrixes
max_partition_size_or := 1000;
override := #STORED('BlockDimensions_max_partition_size', max_partition_size_or);

// TEST -- Multiply two matrixes and then solve for an original

// Note:  For solve, only two dimensions are needed
// For solve AX, A is N x N and B/X is N x M
// For solve XA, B/X is M x N and A is N x N
DimensionN := 59;  
DimensionM := 67;

//Generate two random matrices
preMatrixA1 := tm.RandomMatrix(DimensionN, DimensionN, 1.0, 1);
preMatrixA2 := tm.RandomMatrix(DimensionN, DimensionN, 1.0, 1);

// Adds two randomly generated matrices
preMatrixAFinal := PBblas.axpy(1.0, preMatrixA1, preMatrixA2);

//Result of multiplying two of the same matrices
Matrix_A := PBblas.gemm(TRUE, FALSE, 1.0, preMatrixAFinal, preMatrixAFinal);   
		
// The below two lines of code test converting from discrete to matrix form

// Converts the A1 matrix to discrete form
DFA1 := conv.MatrixToDF(Matrix_A);

// Converts the discrete form back to a matrix
NFA1 := conv.DFToMatrix(DFA1);

// Generate another matrix
Matrix_X := tm.RandomMatrix(DimensionN, DimensionM, 1.0, 1);				 

// E computes the B value for AX (i.e. AX).  Solving for AX = E should return X
Matrix_E := PBblas.gemm(FALSE, FALSE, 1.0, NFA1, Matrix_X);

// Solve AX using Cholesky factorization 
Cholesky_L1 := PBblas.potrf(Lower, NFA1);

LowerPartition := PBblas.trsm(Side.Ax, Lower, FALSE, Diagonal.NotUnitTri, 1.0, Cholesky_L1, Matrix_E);
UpperPartition := PBblas.trsm(Side.Ax, Upper, TRUE, Diagonal.NotUnitTri, 1.0, Cholesky_L1, LowerPartition);

// Compares the values between the matrices, correct result should have 0 errors
result := Tests.DiffReport.Compare_Cells('TEST -- Add, Multiply, Factor, Solve', Matrix_X, UpperPartition);

WHEN(OUTPUT(result,{testname, passed := IF(errors = 0, 'Pass', 'Fail. Errors:' + errors)}, NAMED('Result')), override);
