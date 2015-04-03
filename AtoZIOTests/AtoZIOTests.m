
@import AtoZIO;

_Case(AtoZIOTests, [@"Well Hello!"[RED] echo]; )

_Test(Example,

  id z = IO.args; [z printC:RANDOMCOLOR];

  XCTAssertNotNil(z, @"We shall have arggs!, %@",z);
//  XCTAssert(＃== [z count] + 1, @"Should find %lu args, got %lu", [z count] + 1, ＃);

)

_Test(TTYCharacteristics,

  XCTAssert(IO.isatty, @"SHould be a tty")_
  XCTAssert(IO.isxcode, @"SHould be xcode!")_
  XCTAssertFalse( NSEqualRects(NSZeroRect, IO.frame), @"Need a frame!")_

)

_Test(PerformanceExample, {

    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
})

- (void) testImageNamed {

//  XCTAssertNotNil(x = AZIMGNamed(AZIMG_checkmark));

}
@end
