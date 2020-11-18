/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2020 HPCC Systems�.  All rights reserved.
############################################################################## */
IMPORT $.^ as PBblas;

iden_4 := DATASET([
              {1, 1, 1, 1}, {1, 1, 2, 0}, {1, 1, 3, 0}, {1, 1, 4, 0},
              {1, 2, 1, 0}, {1, 2, 2, 1}, {1, 2, 3, 0}, {1, 2, 4, 0},
              {1, 3, 1, 0}, {1, 3, 2, 0}, {1, 3, 3, 1}, {1, 3, 4, 0},
              {1, 4, 1, 0}, {1, 4, 2, 0}, {1, 4, 3, 0}, {1, 4, 4, 1}], 
              PBblas.Types.Layout_Cell);
dim := 4;
iden_4_test := PBblas.eye(dim);
//OUTPUT(iden_4_test);
test_iden := PBblas.test.DiffReport.Compare_Cells('TEST -- Eye -- dim 4', iden_4, iden_4_test);
OUTPUT(test_iden, NAMED('test'));
