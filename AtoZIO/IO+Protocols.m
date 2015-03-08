//
//  AtoZIO+Protocols.m
//  AtoZIO
//
//  Created by Alex Gray on 3/1/15.
//  Copyright (c) 2015 Alex Gray. All rights reserved.
//

#import "IO+Protocols.h"
#import "IO.h"

@concreteprotocol(Bicolor)

SYNTHESIZE_ASC_PRIMITIVE_BLOCK (ftty, setFtty, int, ^{ if (!value && self.fclr) value = [self.fclr tty]; },
                                                    ^{ value = MID(value, 0, 255);                         } )

SYNTHESIZE_ASC_PRIMITIVE_BLOCK (btty, setBtty, int, ^{ if (!value && self.bclr) value = [self.bclr tty]; },
                                                   ^{ value = MID(value, 0, 255);               } )

SYNTHESIZE_ASC_OBJ_BLOCK ( fclr, setFclr, ^{}, ^{ if(value) self.ftty = [value tty]; } )
SYNTHESIZE_ASC_OBJ_BLOCK ( bclr, setBclr, ^{}, ^{ if(value) self.btty = [value tty]; } )


- (BOOL) colored { return self.bclr || self.fclr; }

- (NSString*) x { NSString *colorize = [self isKindOfClass:NSString.class] ? (id)self : self.description;

  return !self.colored ? colorize : ({ NSMutableString *p = @"".mutableCopy;

        IO.isxcode ? ({

          !self.fclr ?: [p appendFormat:@"%sfg%@;",       CSI, [self.fclr xcTuple]];
          !self.bclr ?: [p appendFormat:@"%sbg%@;",       CSI, [self.bclr xcTuple]];
                        [p appendFormat:@"%@"     XCODE_RESET, colorize];

  }) :  IO.isatty ? ({  [p appendString:@""          ANSI_ESC];
          !self.fclr ?: [p appendFormat:@"%s%i",      ANSI_FG, [self.fclr tty]];
          !self.bclr ?: [p appendFormat:@"%s%i",      ANSI_BG, [self.fclr tty]];
                        [p appendFormat:@"m%@"     ANSI_RESET, colorize];   }) : nil; [p copy]; });
}

- objectAtIndexedSubscript:(NSUInteger)i { self.ftty = i; return self; }
-  objectForKeyedSubscript:(CopyObject)_   { [self setFclr:_]; return self; }


- (id<Bicolor>) withFG:(id)_ { [self setFclr:_]; return self; }
- (id<Bicolor>) withBG:(id)_ { self.bclr = _; return self; }

@end

//  id x = ((id(*)(id,SEL))objc_msgSend)((id)NSColor.class, NSSelectorFromString(@"yellowColor"));

//  if (x && [x isKindOfClass:NSColor.class]) self.fclr = _;
//  return self;
//}


@concreteprotocol(CLIDelegate)

- (NSArray*) _options {

    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(self.class, &methodCount);

    printf("Found %d methods on '%s'\n", methodCount, class_getName(self.class));

    NSMutableArray * opts = @[].mutableCopy;

  for (unsigned int i = 0; i < methodCount; i++) {

      Method method = methods[i];
      NSString *o = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
      [opts addObject:@{@"long" : o, @"short": [o substringWithRange:(NSRange){0,1}]}];

//      printf("\t'%s' has method named '%s' of encoding '%s'\n", class_getName(clz), method_getTypeEncoding(method));

  }

  free(methods);
  return opts;
}

@end

