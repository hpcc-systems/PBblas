IMPORT $.^ as PBblas;
IMPORT PBblas.Types;
IMPORT Std.System.Thorlib;
Layout_Cell := Types.Layout_Cell;
// Generate test data

EXPORT MakeTestMatrix := MODULE
  // Generate test data
  SHARED UNSIGNED rmax := POWER(2, 32) - 1; // Max value for use with RANDOM()
  SHARED modulus := 137; // A large prime number to keep the value of cells within reason to avoid fp errors
  SHARED W_Rec := RECORD
    UNSIGNED x;
  END;
  SHARED W0 := DATASET([{1}], W_Rec);
  SHARED nodes := Thorlib.nodes();
  SHARED W1 := NORMALIZE(W0, nodes, TRANSFORM(W_Rec, SELF.x := COUNTER, SELF := LEFT));
  SHARED W2 := DISTRIBUTE(W1, x);
  SHARED node := Thorlib.node();

  SHARED Layout_Cell gen(UNSIGNED4 c, UNSIGNED4 NumRows, REAL8 v, REAL density, UNSIGNED wi_id=1):=TRANSFORM
    SELF.x := ((c-1)  %  NumRows) + 1;
    SELF.y := ((c-1) DIV NumRows) + 1;
    SELF.wi_id := wi_id;
    r := RANDOM();
    // Make sure we have at least one cell regardless of the density setting (i.e. don't skip 1,1),
    //  except if the density is 0.0, which is a way to force a zero matrix for specific test cases.
    SELF.v := IF((density > 0.0 AND SELF.x = 1 AND SELF.y = 1) OR r / rmax <= density, v, SKIP);
  END;
  offset := 250;
  SHARED REAL8 F_A(UNSIGNED4 c) := 3.0*POWER(c%modulus,1.1) -5.0*c%modulus - offset;

  EXPORT Matrix(UNSIGNED N, UNSIGNED M, REAL density=1.0, UNSIGNED wi_id=1) := FUNCTION
    // Use all nodes to generate cells
    matCells := N*M;
    cellsPerNode := matCells DIV nodes;
    remainderCells := matCells % nodes;
    // Let the last node handle the remainder
    thisNodeCells := IF(node = (nodes-1), cellsPerNode + remainderCells, cellsPerNode);
    thisNodeOffset := node * cellsPerNode;
    cells := NORMALIZE(W2, thisNodeCells , gen(COUNTER+thisNodeOffset, N, F_A(COUNTER+thisNodeOffset), density, wi_id));
    RETURN cells;
  END;

  EXPORT MatrixPersist(UNSIGNED N, UNSIGNED M, REAL density=1.0, UNSIGNED wi_id=1, STRING test_id='ANY') := FUNCTION
    cells := Matrix(N, M, density, wi_id) :
                PERSIST('M_' + test_id + '_' + wi_id + '_' +N+'_'+M+'_'+density);
    RETURN cells;
  END;

  random_max := 500.0;

  SHARED Layout_Cell genRandom(UNSIGNED c, UNSIGNED NumRows, REAL density, UNSIGNED wi_id=1) := TRANSFORM
    SELF.x := ((c-1) % NumRows) + 1;
    SELF.y := ((c-1) DIV NumRows) + 1;
    SELF.wi_id := wi_id;
    v := RANDOM() / rmax * random_max * 2 - random_max;
    r := RANDOM();
    SELF.v := IF((density > 0.0 AND SELF.x = 1 AND SELF.y = 1) OR r / rmax < density, v, SKIP);
  END;

  EXPORT RandomMatrix(UNSIGNED N, UNSIGNED M, REAL density=1.0, UNSIGNED wi_id=1) := FUNCTION
    // Use all nodes to generate cells
    matCells := N*M;
    cellsPerNode := matCells DIV nodes;
    remainderCells := matCells % nodes;
    // Let the last node handle the remainder
    thisNodeCells := IF(node = (nodes-1), cellsPerNode + remainderCells, cellsPerNode);
    thisNodeOffset := node * cellsPerNode;
    cells := NORMALIZE(W2, thisNodeCells , genRandom(COUNTER+thisNodeOffset, N, density, wi_id));
    RETURN cells;
  END;

  EXPORT RandomPersist(UNSIGNED N, UNSIGNED M, REAL density=1.0, UNSIGNED wi_id=1, STRING test_id='ANY') := FUNCTION
    cells := RandomMatrix(N, M, density, wi_id) :
                PERSIST('RM_' + test_id + '_' + wi_id + '_' +N+'_'+M+'_'+density);
    RETURN cells;
  END;
END;

