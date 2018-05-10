IMPORT $ as PBblas;
IMPORT PBblas.Types;
IMPORT ML_core.Types as MlTypes;
NumericField := MlTypes.NumericField;
DiscreteField := MlTypes.DiscreteField;
Layout_Cell  := Types.Layout_Cell;

/**
  * Module to convert between ML_Core/Types Field layouts (i.e. NumericField and
  * DiscreteField) and PBblas matrix layout (i.e. Layout_Cell).
  *
  * <p>ML_Core and PBblas use different forms to represent numeric matrices.
  * <p>ML_Core utilizes two forms:<ul>
  *   <li>NumericField -- Real-valued matrix.</li>
  *   <li>DiscreteField -- Discrete-valued (Integer) matrix.</li></ul>
  * <p>PBblas uses the Layout_Cell format.
  * <p>While both the ML_Core form and the PBblas form represent matrices, there
  * are different semantics implied.  The ML_Core matrices are used to represent
  * a series of observations (rows), each with multiple features (columns).  The
  * PBblas Layout_Cell represents a matrix of rows and columns with no further
  * semantic meaning implied.
  */
EXPORT Converted := MODULE
  /**
    * Convert NumericField dataset to PBblas Layout_Cell dataset.
    *
    * @param  recs  Record Dataset in DATASET(NumericField) format.
    * @return       Matrix in DATASET(Layout_Cell) format.
    * @see          PBblas/Types.Layout_Cell
    * @see          ML_Core/Types.NumericField
    *
    */
  EXPORT DATASET(Layout_Cell) NFToMatrix(DATASET(NumericField) recs) := FUNCTION
    Layout_Cell cvt(NumericField nf) := TRANSFORM
      SELF.wi_id := nf.wi;
      SELF.x     := nf.id;
      SELF.y     := nf.number;
      SELF.v     := nf.value;
    END;
    outMat := PROJECT(recs, cvt(LEFT));
    return outMat;
  END;
  /**
    * Convert DiscreteField dataset to PBblas Matrix.
    *
    * @param  recs  Record Dataset in DATASET(DiscreteField) format.
    * @return       Matrix in DATASET(Layout_Cell) format.
    * @see          PBblas/Types.Layout_Cell
    * @see          ML_Core/Types.DiscreteField
    *
    */
  EXPORT DATASET(Layout_Cell) DFToMatrix(DATASET(DiscreteField) recs) := FUNCTION
    Layout_Cell cvt(DiscreteField df) := TRANSFORM
      SELF.wi_id := df.wi;
      SELF.x     := df.id;
      SELF.y     := df.number;
      SELF.v     := df.value;
    END;
    outMat := PROJECT(recs, cvt(LEFT));
    return outMat;
  END;
  /**
    * Convert PBblas Matrix to NumericField dataset.
    *
    * @param  mat  Matrix in DATASET(Layout_Cell) format.
    * @return      NumericField Dataset.
    * @see         PBblas/Types.Layout_Cell
    * @see         ML_Core/Types.NumericField
    */
  EXPORT DATASET(NumericField) MatrixToNF(DATASET(Layout_Cell) mat) := FUNCTION
    NumericField cvt(Layout_Cell cell) := TRANSFORM
      SELF.wi     := cell.wi_id;
      SELF.id     := cell.x;
      SELF.number := cell.y;
      SELF.value  := cell.v;
    END;
    outRec := PROJECT(mat, cvt(LEFT));
    return outRec;
  END;
  /**
    * Convert PBblas Matrix to DiscreteField dataset.
    *
    * @param  mat  Matrix in DATASET(Layout_Cell) format.
    * @return      DiscreteField Dataset.
    * @see         PBblas/Types.Layout_Cell
    * @see         ML_Core/Types.DiscreteField
    */
  EXPORT DATASET(DiscreteField) MatrixToDF(DATASET(Layout_Cell) mat) := FUNCTION
    DiscreteField cvt(Layout_Cell cell) := TRANSFORM
      SELF.wi     := cell.wi_id;
      SELF.id     := cell.x;
      SELF.number := cell.y;
      SELF.value  := ROUND(cell.v);
    END;
    outRec := PROJECT(mat, cvt(LEFT));
    return outRec;
  END;
END;
