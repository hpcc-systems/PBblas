/*##############################################################################
## HPCC SYSTEMS software Copyright (C) 2016 HPCC Systems®.  All rights reserved.
############################################################################## */

IMPORT $.^ as PBblas;
IMPORT PBblas.internal as int;
IMPORT PBblas.Types;
IMPORT int.Types as iTypes;

// Minimum and maximum block sizes
max_block := 1000000;
min_block := 100000;

test_rec := {UNSIGNED N, UNSIGNED M};
UNSIGNED nodes := 1;
node_counts := DATASET([
  {1},
  {3},
  {21},
  {101}
  ], {UNSIGNED node_count});

// Test cases consist of a series of N and M corresponding to the dimensions of matrixes:
//     A (N x N), B(N x M) for Ax = B or B(M x N) for xA = B,
//
test_cases := DATASET([
  // {N, M) Note that N is A's square dimension (N X N) and M is B's unique dimension:
  // For solve Ax, B is N x M while for solve xA, B is M x N
  {10000000, 4},
  {4, 10000000},
  {10000, 10000},
  {500000,15},
  {15, 500000},
  {10000, 100000},
  {100000, 10000},
  {3, 3},
  {3, 0},
  {0, 3},
  {0, 0}
  ],test_rec);

ext_test_rec := RECORD(test_rec)
  UNSIGNED nodes;
END;

DATASET(ext_test_rec) extend_test_cases(test_rec l, {UNSIGNED node_count} r) := TRANSFORM
  SELF.nodes := r.node_count;
  SELF := l;
END;

DATASET(ext_test_rec) test_cases_ext := JOIN(test_cases, node_counts, TRUE, extend_test_cases(LEFT, RIGHT), ALL);
result_rec := {
  String status,
  UNSIGNED berror,
  STRING error_text,
  UNSIGNED nodes,
  UNSIGNED N,
  UNSIGNED M,
  UNSIGNED PN,
  UNSIGNED PM,
  UNSIGNED a_block_dim,
  UNSIGNED b_block_dim,
  UNSIGNED a_block_size,
  UNSIGNED b_block_size,
  UNSIGNED a_parts,
  UNSIGNED b_parts,
  UNSIGNED partitions
  };

result_rec do_tests(ext_test_rec r) := TRANSFORM
  b := int.BlockDimensionsSolve(r.N, r.M, max_block, r.nodes);
  SELF.nodes := r.nodes;
  SELF.N := r.N;
  SELF.M := r.M;
  SELF.PN := b.PN;
  SELF.PM := b.PM;
  SELF.a_block_dim := b.ABlockDim;
  SELF.b_block_dim := b.BBlockDim;
  SELF.a_parts := SELF.PN * SELF.PN;
  SELF.b_parts := SELF.PN * SELF.PM;
  SELF.partitions := SELF.a_parts + SELF.b_parts;
  SELF.a_block_size := SELF.a_block_dim * SELF.a_block_dim;
  SELF.b_block_size := SELF.a_block_dim * SELF.b_block_dim;
  SELF.berror := IF(SELF.PN = 0 or SELF.PM = 0, 5,
    IF(SELF.a_block_size > max_block OR SELF.b_block_size > max_block, 4,
      IF(SELF.PN > SELF.N OR SELF.PM > SELF.M, 3,
        IF(SELF.a_parts % SELF.nodes != 0 OR SELF.b_parts % SELF.nodes != 0, 2,
          IF(SELF.a_block_size <  min_block OR SELF.b_block_size < min_block, 1, 0)))));
  SELF.error_text := CASE(SELF.berror, 0 => 'None', 5 => 'Partition has zero dimension', 4 => 'Partition size too large', 3 => 'Partition size > cells',
    2 => 'Couldn\'t balance across nodes', 1 => 'Partition size too small', 'Unknown');
  SELF.status := IF(self.berror > 3, 'FAIL', 'SUCCESS');
END;

DATASET(result_rec) result_data := PROJECT(test_cases_ext, do_tests(LEFT));

/**
  * Test driver for Std.PBblas.BlockDimensionsMultiply
  *
  * Also indirectly exercises all aspects of Std.PBblas.BlockDimensions.
  *
  * Test against many different values of N, M, and P.  Verify that
  * the hierarchical constraints are met.
  * @see Std/PBblas/BlockDimensionsMultiply
  * @see Std/PBblas/BlockDimensions
  */
EXPORT BlockDimensionsSolve := result_data;

// Note that BlockDimensions attempts to choose the best partition matrixes that meet four prioritized constraints
// (see Std.PBblas.BlockDimensions).
// For any given N, M, and P, it may not be possible to meet all four constraints.  Therefore 'error' may not always
// be zero.
// Error can take one of the following values:
// 5:  Zero block dimension -- one of the block dimensions is zero which is invalid
// 4:  Failed to meet constraint 1 -- maximum partition size.  This should be considered a failure and should never happen
// 3:  Failed to meet constraint 2 -- no empty partitions.  This should rarely happen and is not a failure.
// 2:  Failed to meet constraint 3 -- couldn't balance across nodes.  This will commonly occur with small matrixes or large node counts.
// 1:  Failed to meet constraint 4 -- minimum partition size.  This will occasionally occur.
// 0:  All constraints met -- the best case.
