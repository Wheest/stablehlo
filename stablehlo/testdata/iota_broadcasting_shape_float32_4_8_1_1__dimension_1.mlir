// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @expected() : () -> tensor<4x8x1x1xf32>
    %1 = stablehlo.iota dim = 1 : tensor<4x8x1x1xf32>
    %2 = stablehlo.custom_call @check.eq(%1, %0) : (tensor<4x8x1x1xf32>, tensor<4x8x1x1xf32>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @expected() -> tensor<4x8x1x1xf32> {
    %0 = stablehlo.constant dense<[[[[0.000000e+00]], [[1.000000e+00]], [[2.000000e+00]], [[3.000000e+00]], [[4.000000e+00]], [[5.000000e+00]], [[6.000000e+00]], [[7.000000e+00]]], [[[0.000000e+00]], [[1.000000e+00]], [[2.000000e+00]], [[3.000000e+00]], [[4.000000e+00]], [[5.000000e+00]], [[6.000000e+00]], [[7.000000e+00]]], [[[0.000000e+00]], [[1.000000e+00]], [[2.000000e+00]], [[3.000000e+00]], [[4.000000e+00]], [[5.000000e+00]], [[6.000000e+00]], [[7.000000e+00]]], [[[0.000000e+00]], [[1.000000e+00]], [[2.000000e+00]], [[3.000000e+00]], [[4.000000e+00]], [[5.000000e+00]], [[6.000000e+00]], [[7.000000e+00]]]]> : tensor<4x8x1x1xf32>
    return %0 : tensor<4x8x1x1xf32>
  }
}