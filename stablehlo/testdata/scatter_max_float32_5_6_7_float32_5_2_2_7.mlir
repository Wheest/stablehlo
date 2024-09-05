// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xf32>, tensor<5x2x2x7xf32>)
    %1 = call @expected() : () -> tensor<5x6x7xf32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %3 = stablehlo.maximum %arg0, %arg1 : tensor<f32>
      stablehlo.return %3 : tensor<f32>
    }) : (tensor<5x6x7xf32>, tensor<2x2x1xi64>, tensor<5x2x2x7xf32>) -> tensor<5x6x7xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<5x6x7xf32>, tensor<5x6x7xf32>) -> ()
    return %2 : tensor<5x6x7xf32>
  }
  func.func private @inputs() -> (tensor<5x6x7xf32> {mhlo.layout_mode = "default"}, tensor<5x2x2x7xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xB396F53F2256BD3FD26A46BE82E9EFBF3BCF8A3FF3BB9F404E8F8EC0BA88CE3F2E22FB3EDABC92C0230C46C02ED8C140CC209140409B6BC05166B9C051E509C0E4A41EBF3B1AE93F8EF9F43F6B63FD3D71F9A73FFBA8623FD5BAD13F40110540ACC310C0223B9B40FDC4B0BF6EB43FC0038D6DBD4036263F4C15563F4084A4BFD6113BBF84797CBF7D9513BD6212AD3FE5D07CBF5B90A340ACF8AF407AD1BD3FD6D0BDC0AD496BBFD9CB9B3F6A0DA04040E710C080A09BBF03DD363E8FACCAC0ECC30EC0D18C933D9EF68A3F081DD83F38AC254016046CC00D3F45C053C53F3FD5FC0F406B5C5EBD79F4CC3F5B90DF3F7C0DCE3DD5E75DBE5D601CC0F2241C3FA2038B400C52BBC03699ECBEF355B7BF4DE6AD40679E1BC06745AEBFBABB4A40E6C34E3F17C66A4044032F40D356C33F876C6FBFF2D5743FCA1811C083DEA53F0A379FC0AFCA524024D60240CAC82F3FB431C23F0237A2405C8E723D133F414052C34AC0BB1184C02920BD40C0DFBE3F6F188B3E6F914C3FB3F6A63FF561F7BD5EC18ABF8B2C4A3D93DAB23F5EA162C041AE88C0960FC4BEBD081140635991400B416A3E2FD946C0968C39400F9317BF8C08D940E37BC540AC7EB740F54A56BE7A018C3F5CF9AABF434B01C095F991BF325E9240BD6AC83FFAA6BBBFB75116BF7C3A94404D72AC3F0829F1BF6DFF343F893219C0C0ACD43FF9739B3FF9BC0B3FF626ECBDDC04D0BFEA6F6B3EDB0CD2C0E67A07405D60F2BFE7D1943FF3A60741BF5A3CC0DB2B0EC0365C7EBF8B9EE23F81A6D03F415C0E410B8886C0C22C463EDBBD7DBE77512ABFE4E18DBF1DB1D7BF91AFA2BFEEFDDABEA40096409946823F6B39904038D3C3BF6992ABC024FE90C0B58E1B3F916427BE8EFB58C0B99CE040BE8344C03DEAE1BFF89D5E40CD1A4540431758BF8C815A409E0262C04808B0BEADCC0740F9439A40F19CEB40CCDC374091A8284027BE92C0460928C078BCEF40B1F4CDC0D37EE3C0243FDDC0C6B17C40060E64BCD744CDBEDD8B1EBFFCA435C0899673407D4C223E919704C03ADD1FBF06C516BEAF7A7EC0DA8458402A6B283FF9108DC0D9B8803E7CAEFBBF14B6164001BDB63FC9608340889D40C0B2C91CC023150EBFFCAF70BEEDA298BF1F11AFBF457D224000AD1140A9A967C0ECB5D6C037D01C3F63E10EBF"> : tensor<5x6x7xf32>
    %cst_0 = stablehlo.constant dense<"0x6EFA373F3C37BEC09C434ABF975991C0D99B843F6D6CCFC06F8E1DC0AF9CDCBFAB340B3FC762B1BFABD54B407CC1AB409567B93EC78C953EBA050B403E2A2EC0C94C52C080DC00C04F77BAC0221726C0A3E8864089D7FEBFC3C1A2BFDCCCABC06EE99B40CA2A27BFECD538BF0B7D9F3FD719ACBF8F1A93BFCF49A0401F6994C0740B993F2ACA923FE81A12401CEEA8C0345D9540343C1EBEC4B6D2BE3C8CF7BFD96EB6407470B13F0FDFB03F299F39BFE9F552C016D4C1C0F442DC3E24E134C01037104037B789BF818DA33DBC949EBF0301753F4D5F27C00E9B45404A231DC0B1AC164091A04AC013B77F3E781DAE407E0501407219BCC09A49DABF87B1FA3FE95E81BF1A3F613FCE4454BDAFC80C40153A8D3FDCE22EBF07AA4C3FC1A382C0D79350407C84A2BF8BC1884014D5FE3FDB6D44404D1E14C0AD5EA6C04ADBCDBFDF6609C0A8266F40E7597BC087868240A378D13FA6081AC036E4A440A122DC3EFA917040ED116BBE02B496BFEDAA3740D43656409C94E4BF7390BBBEA0BAEB3EE44280C0E7CF1AC0ED4D0C4001A723C0AF9F9FC0AFD6013EBE85C640869CAC3F09CF853F870E7A4032E279BD5E9932409CC63240305514C006F93F3EB81B20C04D2C06BFE5FD9340C6A2C1BE5644B4BF83B8024056F183406DB96240AD34963F23A71C3F8D9856C0A4EA243F159D98BF06D1D03E61A41A40A2C81FC08811A73E152C40BEA249193FF04DA23F68119440C70CBF3FACDAAABFEC284FBFE66753C0EB6979BF88C8543F82B51340574F3BC0"> : tensor<5x2x2x7xf32>
    return %cst, %cst_0 : tensor<5x6x7xf32>, tensor<5x2x2x7xf32>
  }
  func.func private @expected() -> (tensor<5x6x7xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xB396F53F2256BD3FD26A46BE82E9EFBF3BCF8A3FF3BB9F406F8E1DC0BA88CE3FAB340B3FC762B1BFABD54B402ED8C140CC209140C78C953EBA050B4051E509C0E4A41EBF3B1AE93F8EF9F43F6B63FD3DA3E88640FBA8623FD5BAD13F401105406EE99B40223B9B40ECD538BF0B7D9F3F038D6DBD4036263F4C15563F4084A4BFD6113BBF84797CBF7D9513BD6212AD3FE5D07CBF5B90A340ACF8AF407AD1BD3FD6D0BDC0AD496BBFD9CB9B3F6A0DA040CF49A04080A09BBF740B993F2ACA923FE81A1240D18C933D345D9540081DD83F38AC25403C8CF7BFD96EB6407470B13FD5FC0F406B5C5EBD79F4CC3F5B90DF3FF442DC3ED5E75DBE10371040F2241C3FA2038B40BC949EBF0301753FF355B7BF4DE6AD40679E1BC06745AEBFBABB4A40E6C34E3F17C66A4044032F40D356C33F876C6FBFF2D5743FCA1811C083DEA53F0A379FC0AFCA524024D60240CAC82F3FB1AC16400237A24013B77F3E781DAE407E050140BB1184C02920BD4087B1FA3F6F188B3E1A3F613FB3F6A63FAFC80C40153A8D3F8B2C4A3D93DAB23F5EA162C0D7935040960FC4BE8BC1884063599140DB6D44404D1E14C0968C39400F9317BF8C08D940E37BC540AC7EB740878682407A018C3F5CF9AABF434B01C095F991BF325E9240BD6AC83FFAA6BBBFB75116BF7C3A94404D72AC3F0829F1BF6DFF343F893219C0C0ACD43FA378D13FF9BC0B3F36E4A440A122DC3EFA917040ED116BBEE67A0740EDAA3740D4365640F3A607417390BBBEA0BAEB3E365C7EBF8B9EE23FED4D0C40415C0E410B8886C0C22C463EBE85C640869CAC3F09CF853F870E7A4032E279BD5E993240A40096409946823F6B39904038D3C3BF6992ABC024FE90C0B58E1B3F916427BE8EFB58C0B99CE040BE8344C03DEAE1BFF89D5E40CD1A4540431758BF8C815A409E0262C04808B0BEADCC0740F9439A40F19CEB40CCDC374091A8284056F183406DB9624078BCEF4023A71C3F8D9856C0A4EA243FC6B17C4006D1D03E61A41A40DD8B1EBF8811A73E89967340A249193FF04DA23F68119440C70CBF3FACDAAABFDA8458402A6B283FEB6979BF88C8543F82B5134014B6164001BDB63FC9608340889D40C0B2C91CC023150EBFFCAF70BEEDA298BF1F11AFBF457D224000AD1140A9A967C0ECB5D6C037D01C3F63E10EBF"> : tensor<5x6x7xf32>
    return %cst : tensor<5x6x7xf32>
  }
}