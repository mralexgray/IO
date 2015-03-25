
#import "_IO.h"

@concreteprotocol(Bicolor)

//SYNTHESIZE_ASC_PRIMITIVE_BLOCK (ftty, setFtty, _UInt, ^{ if (!value && self.fclr) value = self.fclr.tty; },
//                                                      ^{ self.fclr = [Colr fromTTY:value = MID(value, 0, 255)];                     })
//
//SYNTHESIZE_ASC_PRIMITIVE_BLOCK (btty, setBtty, _UInt, ^{ if (!value && self.bclr) value = self.bclr.tty; },
//                                                      ^{ self.bclr = [Colr fromTTY:value = MID(value, 0, 255)];                     })
// if (!value && self.ftty) self.fclr = value = [Colr fromTTY:self.ftty]; },
// if(value) self.ftty = [value tty]; })
// if(value) self.btty = [value tty]; }) // if (!value && self.ftty) self.fclr = value = [Colr fromTTY:self.ftty]; },// }, // if (!value && self.btty) self.bclr = (value = [Colr fromTTY:self.btty]);},

#define MAKENORMALIZEDCOLOR  if (ISA(value,Numb)) { _UInt k = [value uIV]; while (k > 255) k -= 255; value = [Colr fromTTY:MID(k,0,255)]; }

SYNTHESIZE_ASC_OBJ_BLOCK (fclr, setFclr, ^{ MAKENORMALIZEDCOLOR }, ^{})


SYNTHESIZE_ASC_OBJ_BLOCK (bclr, setBclr, ^{ MAKENORMALIZEDCOLOR }, ^{})


- _IsIt_ colored { return self.bclr || self.fclr; }

- _Text_  escape { return !self.colored ? @"" :

  $(@"%@%@%@", !self.fclr ? @"" : [self.fclr fgEsc], !self.bclr ? @"" : [self.bclr bgEsc], !IO.isatty ? @"" : @"m");
}

- _Text_ x { return !self.colored ? self.stringRep :

  [self.escape stringByAppendingFormat:@"%@%s", self.stringRep, IO.isxcode ? XCODE_RESET : ANSI_RESET ];
}

- objectAtIndexedSubscript: _SInt_ i { [self setFclr:@(i)]; return self; }

-  objectForKeyedSubscript: _Copy_ k  { [self setFclr:_ObjC_ k]; return self; }

- _BICOLOR_ withFG:_ObjC_ fg { self.fclr = fg; return self ; }

- _BICOLOR_ withBG:_ObjC_ bg { self.bclr = bg; return self; }

@end

//  id x = ((id(*)(id,SEL))objc_msgSend)((id)NSColor.class, NSSelectorFromString(@"yellowColor")); \
  if (x && [x isKindOfClass:NSColor.class]) self.fclr = _; return self; }

@concreteprotocol(CLIDelegate)

- _List_ _options {

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

