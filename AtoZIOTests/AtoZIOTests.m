//
//  AtoZIOTests.m
//  AtoZIOTests
//
//  Created by Alex Gray on 2/20/15.
//  Copyright (c) 2015 Alex Gray. All rights reserved.
//

@import AtoZIO;
#import <XCTest/XCTest.h>

@interface AtoZIOTests : XCTestCase
{
 id x;
}
@end

@implementation AtoZIOTests

- (void) setUp      { [@"Well Hello!"[RED] echo]; [super setUp]; }

- (void) tearDown   { [super tearDown]; }

- (void) testExample {

  id z = IO.args;
  [z print];
  XCTAssertNotNil(z, @"We shall have arggs!, %@",z);
  XCTAssert(＃== [z count] + 1, @"Should find %lu args, got %lu", [z count] + 1, ＃);
}

- (void) testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testImageNamed {

//  XCTAssertNotNil(x = AZIMGNamed(AZIMG_checkmark));

}
@end
