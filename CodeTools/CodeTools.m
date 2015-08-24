
//@import IO

//One stop shop for option parsing, console color / display / control, extendable via plug-ins!

@import ToolKit;

@Xtra(NUrl,DateAdded) _RO _Date dateAdded ___ ￭

@XtraPlan(NUrl,DateAdded)

- _Date_ dateAdded {

  MDItemRef inspectedRef = MDItemCreateWithURL(kCFAllocatorDefault, (__bridge CFURLRef)self);

  if (!inspectedRef) return nil;

  CFTypeRef cfRslt = MDItemCopyAttribute(inspectedRef,(CFStringRef)@"kMDItemDateAdded");

  return cfRslt ? (__bridge NSDate*)cfRslt : nil;
}

￭

@KIND(LoadedBundle)
￭

@Plan LoadedBundle

_VD mergeContentsOf _ pathOrURL into _ destPathOrURL {

 _List toMoveFrom = [FM contentsOfDirectoryAtPath:
                             ISA(pathOrURL,NUrl) ? [pathOrURL absoluteString]
                                                 : [pathOrURL normalizedPath] error:nil],

         toMoveTo = [FM contentsOfDirectoryAtPath:
                        ISA(destPathOrURL, NUrl) ? [destPathOrURL absoluteString]
                                                 : [destPathOrURL normalizedPath] error:nil],

       unionArray = [toMoveTo arrayByAddingObjectsFromArray:toMoveFrom];

  [[toMoveFrom arrayWithoutObjects:unionArray] each:^(_ObjC x) {

    [FM moveItemAtPath:[pathOrURL withPath:x] toPath:destPathOrURL error:nil];

  }];
  [unionArray each:^(_ObjC x) {

    [FM setColor:GREY forFileAtPath:[pathOrURL withPath:x]];

  }];



}


- init { SUPERINIT;

  [[FM contentsOfDirectoryAtPath:@"/Applications".normalizedString error:nil] do:^(_ObjC x) {

    id z = [NSURL fileURLWithPath:[@"/Applications" withPath:x]].dateAdded;

    [IO fmt:@"%@ is %@", x, z];

  }];

  [self mergeContentsOf:@"/tmp/Folder A" into:@"/tmp/Folder B"];

  return self;

}
￭