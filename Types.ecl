/*############################################################################
## HPCC SYSTEMS software Copyright (C) 2020 HPCC Systems.  All rights reserved.
############################################################################## */
IMPORT ML_Core;
IMPORT ML_Core.Types as MlTypes;
/**
  * Types for the Parallel Block Basic Linear Algebra Sub-programs support.
  * <p>WARNING: attributes marked with WARNING can not be changed without making
  * corresponding changes to the C++ attributes.
  */
EXPORT Types := MODULE
  /**
    * Type for matrix dimensions.  Uses UNSIGNED4 as matrixes
    * are not designed to support more than 4 B rows or columns.
    */
  EXPORT dimension_t  := UNSIGNED4;     // WARNING: type used in C++ attributes
  /**
    * Type for partition id -- only supports up to 64K partitions.
    */
  EXPORT partition_t  := UNSIGNED2;
   /**
    * Type for work-item id -- only supports up to 64K work items.
    */
  EXPORT work_item_t  := MlTypes.t_work_item;
  /**
    * Type for matrix cell values
    * 
    * WARNING: type used in C++ attribute
    */
  EXPORT value_t      := REAL8;
  /**
    * Type for matrix label.  Used for Matrix dimensions (see Layout_Dims)
    * and for partitions (see Layout_Part).
    */
  EXPORT m_label_t    := STRING3;
  /**
    * Enumeration for Triangle type
    * 
    * WARNING: type used in C++ attribute.
    *
    * @value Upper = 1
    * @value Lower = 2
    */
  EXPORT Triangle     := ENUM(UNSIGNED1, Upper=1, Lower=2);
  /**
    * Enumeration for Diagonal type
    *
    * WARNING: type used in C++ attribute.
    *
    * @value UnitTri = 1. Ignore the values of the diagonal and use all
    *        ones instead.
    * @value NotUnitTri = 2.  Use the diagonal values.
    * 
    */
  EXPORT Diagonal     := ENUM(UNSIGNED1, UnitTri=1, NotUnitTri=2);
  /**
    * Enumeration for Side type in trsm.
    *
    * WARNING: type used in C++ attribute
    *
    * @value Ax = 1.  Solve x for Ax = B.
    * @value xA = 2.  Solve x for xA = B.
    * @see trsm
    */
  EXPORT Side         := ENUM(UNSIGNED1, Ax=1, xA=2);
  /**
    * Type for matrix universe number
    *
    * Allow up to 64k matrices in one universe.
    * @internal
    */
  EXPORT t_mu_no      := UNSIGNED2; //Allow up to 64k matrices in one universe
  /**
    * Layout for a Matrix Cell.
    *
    * <p>Main representation of Matrix cell at interface to all PBBlas functions.
    * <p>Matrixes are represented as DATASET(Layout_Cell), where each cell describes
    * the row and column position of the cell as well as its value.
    * Only the non-zero cells need to be contained in the dataset in order
    * to describe the matrix since all unspecified cells are considered to
    * have a value of zero.
    * The cell also contains a work-item number that allows multiple separate
    * matrixes to be carried in the same dataset.  This supports the "myriad"
    * style interface that allows the same operations to be performed on many
    * different sets of data at once.
    * <p>Note that these matrixes do not have an explicit size.  They are sized
    * implicitly, based on the maximum row and column presented in the data.
    * <p>A matrix can be converted to an explicit dense form (see matrix_t) by
    * using the utility module MakeR8Set. That module should only be used for known
    * small matrixes (< 1M cells) or for partitions of a larger matrix.
    * <p>The 'internal/Converted' module provides utility
    * functions to convert to and from a set of partitions used internally (See Layout_parts).
    *
    * <p>WARNING: Used as C++ attribute.  Do not change without corresponding changes
    *  to MakeR8Set.
    *
    * @field wi_id  Work Item Number -- An identifier from 1 to 64K-1 that
    *                 separates and identifies individual matrixes.
    * @field x 1-based row position within the matrix.
    * @field y 1-based column position within the matrix.
    * @field v Real value for the cell.
    * @see matrix_t
    * @see MakeR8Set.ecl
    * @see internal/Converted.ecl
    *
    */
  EXPORT Layout_Cell  := RECORD
    work_item_t wi_id:=1;  // 1 based work-item number
    dimension_t x;         // 1 based index position for row
    dimension_t y;         // 1 based index position for column
    value_t     v;       // Value for cell
  END;

  /**
    * Layout for Norm results.
    *
    * @field wi_id  Work Item Number -- An identifier from 1 to 64K-1 that
    *                 separates and identifies individual matrixes
    * @field v      Real value for the norm
    */
  EXPORT Layout_Norm := RECORD
    work_item_t wi_id;     // 1 based work-item number
    value_t     v;         // Norm value for work item
  END;
  /**
    * Extended layout for handling multiple Layout_cell matrices
    *
    * @field mat_id  Matrix id -- An identifier from 1 to 64K-1 that
    *                 separates and identifies individual matrices even 
                      if the matrices have same wi_id
    */
  EXPORT Layout_Cell_ext := RECORD(Layout_Cell)
    t_mu_no mat_id; // The number of the matrix within the universe
  END;
END;