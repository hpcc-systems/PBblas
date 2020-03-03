/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2020 HPCC Systems�.  All rights reserved.
############################################################################## */
IMPORT $.^ as PBblas;

v1 := DATASET([
              {1, 1, 1, 5.3},
              {1, 2, 1, 5.3},
              {1, 3, 1, 5.3},
              {1, 4, 1, 5.3}], 
              PBblas.Types.Layout_Cell);
len := 4;
val := 5.3;
v1_test := PBblas.vec.From(len, val);
//OUTPUT(v1_test, NAMED('v1_test'));
test_from := PBblas.test.DiffReport.Compare_Cells('TEST -- From -- len 4 val 5', v1, v1_test);
//OUTPUT(test_from, NAMED('test_from'));


m1 := DATASET([
              {1, 1, 1, 5.3}, {1, 1, 2, 0}, {1, 1, 3, 0}, {1, 1, 4, 0},
              {1, 2, 1, 0}, {1, 2, 2, 5.3}, {1, 2, 3, 0}, {1, 2, 4, 0},
              {1, 3, 1, 0}, {1, 3, 2, 0}, {1, 3, 3, 5.3}, {1, 3, 4, 0},
              {1, 4, 1, 0}, {1, 4, 2, 0}, {1, 4, 3, 0}, {1, 4, 4, 5.3}], 
              PBblas.Types.Layout_Cell);
v2_test := PBblas.vec.Todiag(PBblas.vec.From(len, val));
//OUTPUT(v2_test, NAMED('v2_test'));
test_todiag := PBblas.test.DiffReport.Compare_Cells('TEST -- Todiag -- len 4', m1, v2_test);
//OUTPUT(test_todiag, NAMED('test_todiag'));


m2 := DATASET([
              {1, 1, 1, -1.0}, {1, 1, 2, -1.0}, {1, 1, 3, 1.0},
              {1, 2, 1, 1.0}, {1, 2, 2, 3.0}, {1, 2, 3, 3.0},
              {1, 3, 1, -1.0}, {1, 3, 2, -1.0}, {1, 3, 3, 5.0}],
              PBblas.Types.Layout_Cell);
v3 := DATASET([
              {1, 1, 1, -1.0},
              {1, 2, 1, 3.0}, 
              {1, 3, 1, 5.0}],
              PBblas.Types.Layout_Cell);
v3_test := PBblas.vec.FromDiag(m2); 
//OUTPUT(v3_test, NAMED('v3_test'));
test_fromdiag := PBblas.test.DiffReport.Compare_cells('TEST -- FromDiag ', v3, v3_test);
//OUTPUT(test_fromdiag, NAMED('test_fromDiag'));

//Making a vector from the third column of m2
v4 := DATASET([
              {1, 1, 1, 1.0},
              {1, 2, 1, 3.0}, 
              {1, 3, 1, 5.0}],
              PBblas.Types.Layout_Cell);
v4_test := PBblas.vec.FromCol(m2, 3);
//OUTPUT(v4_test, NAMED('v4_test'));
test_fromcol := PBblas.test.DiffReport.Compare_cells('TEST -- FromCol ', v4, v4_test);
//OUTPUT(test_fromcol, NAMED('test_fromcol'));

//Making a vector from the third column of m2
v5 := DATASET([
              {1, 1, 1, -1.0},
              {1, 2, 1, -1.0}, 
              {1, 3, 1, 5.0}],
              PBblas.Types.Layout_Cell);
v5_test := PBblas.vec.FromRow(m2, 3);
//OUTPUT(v5_test, NAMED('v5_test'));
test_fromrow := PBblas.test.DiffReport.Compare_cells('TEST -- FromRow ', v5, v5_test);
//OUTPUT(test_fromrow, NAMED('test_fromrow'));

//Replacing 2nd column of m2 with a new vector
v6 := DATASET([
              {1, 1, 1, 10},
              {1, 2, 1, 20}, 
              {1, 3, 1, 30}],
              PBblas.Types.Layout_Cell);
v6_col := DATASET([
              {1, 1, 3, 10},
              {1, 2, 3, 20}, 
              {1, 3, 3, 30}],
              PBblas.Types.Layout_Cell);
v6_test := PBblas.vec.ToCol(v6, 3);
//OUTPUT(v6_test, NAMED('v6_test'));
test_tocol := PBblas.test.DiffReport.Compare_cells('TEST -- ToCol ', v6_col, v6_test);
//OUTPUT(test_tocol, NAMED('test_tocol'));

dot_product := 120;
v7_test := PBblas.vec.dot(v5, v6);
//OUTPUT(v7_test, NAMED('v7_test'));
test_dot := IF(dot_product = v7_test, 1, 0);
//OUTPUT(test_dot, NAMED('test_dot'));

norm_val := SQRT(1+1+25);
v8_test := PBblas.vec.norm(v5);
//OUTPUT(v8_test, NAMED('v8_test'));
test_norm := IF(norm_val = v8_test, 1, 0);
//OUTPUT(test_norm, NAMED('test_norm'));

rslt := SORT(test_from + test_todiag + test_fromdiag + test_fromcol
      + test_fromrow + test_tocol, TestName);
//OUTPUT(rslt, NAMED('rslt'));
EXPORT vec := rslt;