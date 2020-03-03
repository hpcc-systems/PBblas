/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2020 HPCC Systems.  All rights reserved.
############################################################################## */
IMPORT $ as PBBlas;
/**
  *  This module handles different vector (column matrix) operation
  */
EXPORT vec := MODULE
 
 
 /**
  *  Creation of a vector with given length and constant value.
  *
  *  @param N      Length of the vector in UNSIGNED.
  *  @param def    Constant value of the vector in REAL.
  *  @return       Matrix (vector) in DATASET(Layout_Cell) form.
  *  @see          PBblas/Types.Layout_Cell
  */
 EXPORT From(UNSIGNED N,REAL8 def = 1.0) := FUNCTION
  seed := DATASET([{1,0,0,0}], PBblas.Types.Layout_cell);
  PerCluster := ROUNDUP(N/CLUSTERSIZE);
  PBblas.Types.Layout_cell addNodeNum(PBblas.Types.Layout_cell L, UNSIGNED4 c) := TRANSFORM
   SELF.wi_id := L.wi_id;
   SELF.x := (c-1)*PerCluster;
   SELF.y := 1;
   SELF.v := def;
 END;
 // Create eventual vector across all nodes (in case it is huge)
 one_per_node := DISTRIBUTE(NORMALIZE(seed, CLUSTERSIZE, addNodeNum(LEFT, COUNTER)), x DIV PerCluster);
 PBblas.Types.Layout_cell fillRow(PBblas.Types.Layout_cell L, UNSIGNED4 c) := TRANSFORM
  SELF.wi_id := L.wi_id;
  SELF.x := L.x + c;
  SELF.y := 1;
  SELF.v := def;
 END;
 // Now generate on each node; filter 'clips' of the possible extra '1' generated on some nodes
 m := NORMALIZE(one_per_node, PerCluster, fillRow(LEFT,COUNTER))(x <= N);
 RETURN m;
 END;
 
 
  /**
  *  Creation of a diagonal matrix from a given vector.
  *
  *  @param v      Given vector in DATASET(Layout_cell).
  *  @param N      Dimension of the diagonal matrix in UNSIGNED 
  *  @return       Matrix in DATASET(Layout_Cell) form.
  *  @see          PBblas/Types.Layout_Cell
  */
  
  
 EXPORT ToDiag(DATASET(PBblas.Types.Layout_cell) v, UNSIGNED N=1) := 
  PROJECT(v(x>=N), TRANSFORM(PBblas.Types.Layout_Cell, 
                             SELF.x:=LEFT.x-N+1, 
                             SELF.y:=LEFT.x-N+1, 
                             SELF := LEFT));
 
 
  /**
  *  Extraction of a vector of the diagonal elements of a matrix.
  *
  *  @param M      Given matrix in DATASET(Layout_cell).
  *  @param k      kth diagonal of the matrix in INTEGER 
  *  @return       Matrix (vector) in DATASET(Layout_Cell) form.
  *  @see          PBblas/Types.Layout_Cell
  */
  
  
 EXPORT FromDiag(DATASET(PBblas.Types.Layout_Cell) M, INTEGER4 K=0) := 
  PROJECT(M(x=y-k), TRANSFORM(PBblas.Types.Layout_Cell,
                              SELF.x:=IF(K<0,LEFT.y,LEFT.x),
                              SELF.y:=1,
                              SELF := LEFT));
  
  /**
  *  Extract the vector from a given column of a matrix.
  *
  *  @param M      Given matrix in DATASET(Layout_cell).
  *  @param N      Nth column of the matrix in UNSIGNED 
  *  @return       Matrix (vector) in DATASET(Layout_Cell) form.
  *  @see          PBblas/Types.Layout_Cell
  */
 EXPORT FromCol(DATASET(PBblas.Types.Layout_Cell) M, UNSIGNED N) := 
  PROJECT(M(y=N), TRANSFORM(PBblas.Types.Layout_Cell,
                            SELF.x:=LEFT.x,
                            SELF.y:=1,
                            SELF := LEFT));
 
 
  /**
  *  Extract the vector from a given row of a matrix.
  *
  *  @param M      Given matrix in DATASET(Layout_cell).
  *  @param N      Nth row of the matrix in UNSIGNED 
  *  @return       Matrix (vector) in DATASET(Layout_Cell) form.
  *  @see          PBblas/Types.Layout_Cell
  */
 EXPORT FromRow(DATASET(PBblas.Types.Layout_Cell) M, UNSIGNED N) := 
  PROJECT( M(x=N), TRANSFORM(PBblas.Types.Layout_Cell,
                             SELF.x:=LEFT.y,
                             SELF.y:=1,
                             SELF := LEFT));
  /**
  *  Given a vector, transform it to a column of a matrix (replace the existing values).
  *
  *  @param M      Given vector in DATASET(Layout_cell).
  *  @param N      Nth column of the matrix in UNSIGNED. 
  *  @return       Matrix (vector) in DATASET(Layout_Cell) form.
  *  @see          PBblas/Types.Layout_Cell
  */
  EXPORT ToCol(DATASET(PBblas.Types.Layout_Cell) v,UNSIGNED N) := 
  PROJECT(v, TRANSFORM(PBblas.Types.Layout_Cell,
                       SELF.x:=LEFT.x,
                       SELF.y:=N,
                       SELF := LEFT));
  /**
  *  Calculate dot product (inner product or cosine similarity) of two vectors.
  *
  *  @param X      Given vector 1 in DATASET(Layout_cell).
  *  @param Y      Given vector 2 in DATASET(Layout_cell). 
  *  @return       dot product value in REAL.
  *  @see          PBblas/Types.Layout_Cell
  */
 EXPORT Dot(DATASET(PBblas.Types.Layout_Cell) X,DATASET(PBblas.Types.Layout_Cell) Y) := 
  SUM(PBblas.HadamardProduct(X, Y), v);
 
  /**
  *  Calculate L-2 norm of a vector.
  *
  *  @param X      Given vector in DATASET(Layout_cell). 
  *  @return       L-2 norm of the vector in REAL.
  *  @see          PBblas/Types.Layout_Cell
  */
 EXPORT Norm(DATASET(PBblas.Types.Layout_Cell) X) := 
  SQRT(SUM(PBblas.HadamardProduct(X, X),v));
  
END;