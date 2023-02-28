// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x4xi8>, tensor<3x2x4xi8>)
    %2 = call @expected() : () -> tensor<3x5x4xi8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i8>, %arg1: tensor<i8>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<i8>
      stablehlo.return %5 : tensor<i8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 2], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 1>} : (tensor<3x5x4xi8>, tensor<2x1xi32>, tensor<3x2x4xi8>) -> tensor<3x5x4xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x4xi8>, tensor<3x5x4xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x4xi8>, tensor<3x2x4xi8>) {
    %0 = stablehlo.constant dense<[[[4, 4, -3, -1], [-2, 4, 1, -3], [-1, 0, 0, 8], [-3, 3, 0, -1], [5, 5, 7, 0]], [[-3, -2, 0, 2], [-5, -7, 0, 1], [0, -4, -4, 1], [2, -2, 2, 1], [1, -1, -1, 0]], [[2, 1, -1, -1], [-2, 3, -3, -4], [-4, 0, 2, -5], [2, 4, -2, 5], [-1, 0, -3, 2]]]> : tensor<3x5x4xi8>
    %1 = stablehlo.constant dense<[[[0, -4, 0, -1], [0, -4, -3, -2]], [[0, 0, 1, -5], [3, -1, -1, 0]], [[-1, 6, 0, -1], [0, 3, -1, 0]]]> : tensor<3x2x4xi8>
    return %0, %1 : tensor<3x5x4xi8>, tensor<3x2x4xi8>
  }
  func.func private @expected() -> tensor<3x5x4xi8> {
    %0 = stablehlo.constant dense<[[[4, 4, -3, -1], [0, 4, 1, -1], [-1, 0, 0, 8], [-3, 3, 0, -1], [5, 5, 7, 0]], [[-3, -2, 0, 2], [3, 0, 1, 1], [0, -4, -4, 1], [2, -2, 2, 1], [1, -1, -1, 0]], [[2, 1, -1, -1], [0, 6, 0, 0], [-4, 0, 2, -5], [2, 4, -2, 5], [-1, 0, -3, 2]]]> : tensor<3x5x4xi8>
    return %0 : tensor<3x5x4xi8>
  }
}
