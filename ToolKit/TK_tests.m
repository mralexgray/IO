
@import ToolKit;

_Case(IOTests, [@"Well Hello!"[RED] echo]; )

_Test(Example,

  id z = IO.args; [z printC:RANDOMCOLOR];

  XCTAssertNotNil(z, @"We shall have arggs!, %@",z);
//  XCTAssert(＃== [z count] + 1, @"Should find %lu args, got %lu", [z count] + 1, ＃);

)

_Test(TTYCharacteristics,

  XCTAssert(IO.env & io_TTY, @"SHould be a tty")___
  XCTAssert(IO.env & io_XCODE, @"SHould be xcode!")___
  XCTAssertFalse( NSEqualRects(NSZeroRect, IO.frame), @"Need a frame!")___

)


_Test(IOArgParse,

  [IO test:@[@"--alex", @"santa", @"-u", @"suckcock"]];

  XCTAssert( IO.getOpts.count == 2,                       @"Should have 2 keys., got %lu", IO.getOpts.count);
  XCTAssert([IO.getOpts.allKeys containsObject:@"alex"], @"Should have alex, only had %@", IO.getOpts.allKeys);

  XCTAssert(      ISA(IO.getOpts[@"alex"], List), @"Values should all be arrays.. got %@",
   NSStringFromClass([IO.getOpts[@"alex"] class]));

  [IO test:@[@"--alex", @"santa", @"fe", @"new mexico"]];

  XCTAssert(IO.getOpts.count == 1, @"Should have 1 keys., got %lu", IO.getOpts.count);

  XCTAssert([IO.getOpts[@"alex"]count] == 3, @"SHould accomodate args with spaces, found %lu",
            [IO.getOpts[@"alex"]count]);
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
