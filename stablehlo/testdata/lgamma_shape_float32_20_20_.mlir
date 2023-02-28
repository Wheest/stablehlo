// RUN: echo "skipping CHLO test (see #1233 for details)"

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<20x20xf32>
    %1 = call @expected() : () -> tensor<20x20xf32>
    %2 = chlo.lgamma %0 : tensor<20x20xf32> -> tensor<20x20xf32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xf32>, tensor<20x20xf32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x928172405408AF3E577576C0905D92C045E365C0D77E1A3F5AF512C0E7A60C40D1ED3ABFC74786400A17924093367540006A123FAB541540B8A421C072DE08BF2C4B1DC0EABD534078B41840A8DA98BF8FE7B6C0D8931E3F7E076240CAB1CCBF63BAE13F78699040C4CD5740AA3984C0FE4136BF67E0F1BECD4031C007C473BF173A9ABE1AF30FC06E7E6940793010C02022A73EFF263B3FB641B9C08F06763FCC47ACC05A46A93FA8E101C03C55BE3FD5660B404CE251C021FB254032A8323F3E62A73F9BEE713FB90DCF3F2A913C400881CDBFCD58FA3F8E9636BF5682633F0A6533BE64AC0EC0C8783ABFA9921AC0C902F63F9FA9FBBFAD7F99BFF6A10ABF698CA2C06E46713ECD083440E7B4253F5557773F2A9F2BBF54F263BFEC843AC020B54DC0A5577140F3DA2B409F22273FE8E4E040207D084003039BC05825DBC06FE09ABF7E3A15BF0449A03FF75639C0140B7ABF401F5FC072CC574074E54D40D2CC8CBF5E9294BF46319C4032859BBEC349B3BFA25C5B40CB54C5BFEF6D1C40C4A04AC0C70E40C02A6EBE3FD44CC6BFB4C7A3405B2586C02763C5C02805844072725F3F39A5A83F9717E4BF4049A13F27FCD2BECD1A8CC0D4CD613E25FDDFBF2D0424BF34168FC0164BD4BF9607EEBF2E6F973DD77A814078FF62408CAF65BD981F3840DC1B4C40C3FA34BE88506640AA8FA5C0A7629740D1BB75C0962FEB3F728B78C02A58333F3557B7BF521A94BFC41A83406E73473E64A2BFC0E46EA340BA21A6C0215223C0860B3740259646BFD8A8A73ED4498D4051BDF7BF01D7F8BFA1ECEF3F48214B407844503B96A6063E16F693C043D56BBF404FFBBDAFD207C0BA62E440B1F324BF0BD624C0F839E7C04A7240BE527409C1284A6AC0005B24400A815740935D4A3F4D70833FD44BCEBF4CCC0540586200C0477DB0C0EB78D9BF78098B4072905D401FDD1C401D7FBABF989E49C0D3D891C078F68740E9E029BF1D4A6CC0C701A83F772A2BC0E419AFBFF1E47B40DEDB824014DE173FB26420C0935A4240BDE0ACBEE4D0D4400E63913F42A31C40519FD53F4862903F75F0D9404FDFB7C064C00A40985C144060EB7BC025A21040FD909440FF3DD1BF41D524C022C922BF731844C0AC9A97C044E63FC079488F3E2A6A82C01F316FC0111C8DBFE0439F3F05FA7B40CD7C22403278B33DE7FE96C02D7257C0594883BEBD0E45401D132140B3DA7BBF24695840590F8C3E816C67403FE00EC0DF07A2BFC3C7883FEE4D8E3D6751D33EA07A81BFB6FC413FA01D1FC064BDA13F54641A403437EC3FB18A963EB4AC14400834B3C0BB9C72C05FFB9EBF49929540AD461CBF0AF3CFBFD6D3303F8051ACBF4B8F3B4083D24240C081CBBF4ABDABBF56F0B3401B6B4CC02BBEA040E161B5BF03892AC067CD84BF821E7C40D572B2C0220B173F1B8802C02B749CC0FE4C9A3F823AA3C03D760841148258BEDA9826C09DF14CBF5E0595C0C69D0D41CA51E0BF1EFCBAC0E30906C00347B7404BC217C052343FC09E250EC031C0C73EBD2EDEBFC68120BEE86894BF67AFC7BF1BCC0DC051F74BC0C356494042961640D7A1E13FF09F9E40458C80C0F354334098F33C402339833FD8B508C090542EC017E3E33EE5EE513FFD1877C093396CBEF535C1BF932A5D40E80BF73FF643384082CF28C0878DF83FD74301C02A30ED3FB73C85C06369A240D67FCDBF38DD5AC0A4F0C3BFC994EC3C84815AC078F4494063AD03BEF41E094121F0573F429840409C90BFBEC471C8BFFB032CBFCEA2963FEF9D10406EE94FC031A9B8BF40ADDABEE55D41BF50510840EB6094BE80956CC0BEB904405B93803F63D894C098CCC33EF3EBB93FC7EF814061B474C073AFA640CAA5913DD0AD2BC0CA42983C1B919B3F2E069D3F336ED53FE1841A40309D4E403290B83E325DF8BF960473C0D44631C06E1DF4BF76DD07C07A1D95C0747B49407123324022E240BF146B5AC0233D0441D87DCEBFC0C0D83EFF5ACB3F2B074140243561408B79C53F9D516EBC763CA9BFEE175D40A6CE7740588A503FE782A6C0EF051B40101A0F3F84B61C3F74DC73BF371F6340604DF83F46C761BF2744873F2130BBBF271B0240748748BFEE9591400A014A400A800840875656BFCEDB94C038B3243FC2200940022F2E400C2385BFA8AE9BBF80860B40E34E3DBFA2FF9BC069E3C6BF297B0DC067BC443F25469BC0D9E05A40548AB4407D3196C039FFCCBF6EA4113FAF6363406860C440"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
  func.func private @expected() -> tensor<20x20xf32> {
    %0 = stablehlo.constant dense<"0x1245C43FF685753F8C0A82BFDEF339C0829EB2BFE025C93EF8AEC33E00F9C33D23CFC23F3DCB0240E2E0224049C5CA3F40CAE23E00A7323EE0C0A6BD2183A23F007C88BA98F17E3F40C4543EDED3CD3FC81395C090E7BC3E10399E3F0458563F40DEA5BD542F1E4036FE873F76A4A9BF6F38BD3FB58CA23F606D3F3D221B4440662BBB3F340C0F3F0321AF3F8C140B3F7DEE803F60B0653EAAD091C000AAC23C5CC187C000BEE4BD17B33340002CF8BD007AAE3DF4253FBF907BB43E70E4863E0023E0BD00620C3D80C5E1BDC4EB243FF4D1563F00C593BCF197BD3F80A6993D0673EF3F3864253F503BC23F807D933D00EEFDBCC45E2E40F2A0CA3F44C8A23F1A8718C056E2AC3F3017073FD096A83E00C6A73CE8D2B23F2C7D11406CD4483F2433E6BEF17EC13FA8A1D83EB0ACA43E6B36D440804F7C3DF7FC27C03980C9C0A817C43F0C97A53FC04ACABDA4351E3F7C5B714096FFA4BF6AFB873FBC0E673F648311401DC1E53F0A074040597FBA3F2A167A3F809A8F3F8AC3563F40227C3EE8F226BE75FAA640C021F8BDD23B563F4AE156408D46E1BF9F2CA2C0EDD3F93FC067B33D0044E3BD48EC8C3F40D1CDBD00DEA63F66C822C0A2DBB53F9208823F741FAD3FA4D730C046415F3F32D5B63F733B2440BFD1EC3F9A62A03F14A13A408026153F5CE85F3F0081EE3F3ADCA73F9A5752C04BF83140738788BF006C75BD20ED54BF4036853EA0E26D3F5CB3E83F071DF53FCDA9C63FD47E05C060D155401FE059C080FDCDBD5866113F0513D43FC982803F879015401B3B0740B2C60F40001644BD10065C3F98FDB740BCAEFB3F7BEE3BC0D649254028A50B405CA9A83F96CBDA40C0C0AD3F0091E5BDCE21EDC063F7E73F83412BC1D277B3BF50D5AA3EAC5B873FC036253E007674BC0C64573F8087273DB6578D40656991C0509D6B3F7C720F40B061943F586B803E2823663F40AD51BDB2F338C0063A0740D465B13FEB68B1BF80B5E1BD8012C3BD03C0843F261BDB3F76DAF33FF046D13E00B580BDB8333A3F9D82B23F7CE5BD40006283BD30637E3EC0B1D0BD80997ABD5246C740532694C08079A33DB022293E0872A5BE00B3053E34E229406A735A3F6088E5BDC452AC3F820D623F2E1B39C08D539540BFA0953FD4E332BFE026ABBFE6F50F40C08BC6BD5A4FDB3F90F09F3E46F718408A6C3AC0A47284BF501FC93F206D443FA8D6973E642B84400E48893FB0B2983F8A62AA3F96B3213FE2A8A73F00D612BD3C5828400AC0433F2A978E40409B473EE03624BDC05DCFBD9060663E80096BBDE5F78E3FE0312C3E2BBB94C08F7B9DBF78C3B23FCCC02C40E6A0A83F5CEC583F706A8B3EDDB78A3F384D213F04F63B3F7AD6553FBC0C8C3F350B85400438ADBE09A34D407675733F7016D1BD20365140BBA9DB3FEA0A94C0E0DDD33EFC2A20402C4818C0400CB2BD429A29C0F5BF19418CC9DB3F0050F2BDF8EEDF3F52423CC08C97244121CF823FB2988CC0F2F5CB3F84898A4068322B3E70242740DC402F3F1082523FE4287C3F0C97FB3F7EC3E63FACB8553F6607363F98CF97BE34F9543F902D3F3E0043A6BD1D444740102C5D3F2CB8043F1C4F263F00B465BC08F2993FC04325BDB628303FC05C083EA85377BFB821D33F9C935A3FA883933F0025E5BC94A5153F50B5EABD0075C0BCA0A14D40000F61BD445AC9BF37B3524032D1563F4C4795BF3EC5573F0BD561408EB293BFDC63573FBDF30840F21F1B4100C5E53D48A5333F62DDAB3F6890553FF927B33FC06FA0BD208C053E9CF21DBFE8756A3F2663A53FF4B3CB3F00CA763D425ABE3F0FF6B0BF00F5063D000829BB57433CC0AEC5573FC0B8F8BD5824EF3F729290BF7AD65F4046CF264080BCB5BD48647E4040A3B7BD80C3BDBDC041D1BD40B8673EF4F2693FB469673FF9EA0B40314B9BBF2001433D8011E43F60EDA73F3A3F3CC0F888553FE0B8003FA2FBCA3FEC4D93BF3A051141508C573FDC213D3F4063E9BDE440353F7E659C3F406FF2BD12A68740ED2E923F0E5B933F7B10D13F00850D3EFA885EC0800F6D3EE0DEED3EB070C23E12984440A4A9A03F009BC6BCF11D0D400049F7BCB2A3643F009E693C727DD73F967621403C95573F80AE7C3D18B2F53F7A433CC0B060AB3EC08B883D5880E73E0ED94C403A73C03F4095B03D16EDC53F021F1EC01AFB553FB0513C3F80073C3E96AD25C0B08F8E3F54078640D2963BC05082563F6057E53EFA42A13F77B8A040"> : tensor<20x20xf32>
    return %0 : tensor<20x20xf32>
  }
}