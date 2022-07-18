/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2020 HPCC Systems.  All rights reserved.
############################################################################## */
IMPORT $ as PBBlas;
/**
  *  Returns identity matrix of given size
  *
  *  @param dimension    Size in UNSIGNED4.
  *  @return eye         Identity matrix
  *  @see                PBblas/Types.Layout_Cell
  */

  EXPORT eye(UNSIGNED4 dimension) := PBblas.vec.ToDiag(PBblas.vec.From(dimension,1.0));