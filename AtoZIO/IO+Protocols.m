
#import "IO_.h"

@concreteprotocol(Bicolor)

#define MAKENORMALIZEDCOLOR  if (ISA(value,Numb)) { _UInt k = [value uIV]; while (k > 255) k -= 255; value = [Colr fromTTY:MID(k,0,255)]; }

SYNTHESIZE_ASC_OBJ_BLOCK (fclr, setFclr, ^{ MAKENORMALIZEDCOLOR }, ^{})
SYNTHESIZE_ASC_OBJ_BLOCK (bclr, setBclr, ^{ MAKENORMALIZEDCOLOR }, ^{})

- _IsIt_ colored { return self.bclr || self.fclr; }

- _Text_  escape { return !self.colored ? @"" :

  $(@"%@%@%@",  self.fclr ? [self.fclr fgEsc] : zNIL,
                self.bclr ? [self.bclr bgEsc] : zNIL,
                IO.isxcode ? zNIL : @"m");
}

- _Text_ ioString { return !self.colored ? self.stringRep :

  $(@"%@%@%s", self.escape, self.stringRep, IO.isxcode ? XC_RESET : ANSI_RESET);
}

- objectAtIndexedSubscript: _SInt_ i { [self setFclr:@(i)]; return self; }

-  objectForKeyedSubscript: _Copy_ k  { return [self withFG:_ObjC_ k]; }

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


#if MAC_ONLY
#include <termcap.h>
#include <assert.h>
#include <limits.h>
#endif

#define PROGRESSBAR_WIDTH 200


@Plan ProgressBar


- initWithLabel:_Text_ label max:_UInt_ max format: _Text_ fmt { SUPERINIT;

  _max        = max ___
  _start      = time(NULL) ___
  _format     = [fmt.letters withMaxItems:3] ___
  self.label = label ___

//  memset(new->progress_str,' ', PROGRESSBAR_WIDTH);
//  new->progress_str[new->steps] = 0;
//  new->last_printed = 0;
//  new->termtype = getenv("TERM");
//
//  progressbar_draw(new, 0);

  return self;
}

- initWithLabel:_Text_ label max:_UInt_ max { return [self initWithLabel:label max:max format:@"|=|"]; }

- (void) setLabel:(_Text)label { _label = label;

  int newsteps, columns = IO.w; // 80; // by default 80

//  static char termbuf[2048]; if (!(tgetent(termbuf, bar->termtype) < 0)) { columns = tgetnum("co") - 2; } // otherwise size of terminal if it works

  // make sure newsteps is positive
//  int maxstrlen = columns - 17;
//  if (maxstrlen - 10 > 10 && label.count > maxstrlen - 10) {
//    label[maxstrlen - 10] = 0;
//  }
//  if (strlen(label) >= maxstrlen) {
//    label[maxstrlen] = 0;
//  }
  // Reserve two possible colums for pre- and post- spacing
  columns -= 2;

  newsteps = columns - label.count + 17;
  newsteps = newsteps < 0
           ? 0 :
  newsteps > PROGRESSBAR_WIDTH - 1
           ? PROGRESSBAR_WIDTH - 1 : newsteps;
  if (newsteps == self.steps && self.step >= self.steps) self.step = 0;
  self.steps = newsteps;
//  [self draw:self]
}

- (void) setValue:(_UInt)value { _value = value;

  unsigned int current_step = (self.value * (unsigned long)self.steps / (long double)self.max);

  // Only redraw the progressbar if the visual progress display (the current 'step')
  // has changed.
  if(current_step != self.step) {

    // Fill the bar to the current step...
//    for(int i=0;i<current_step;i++)
//      [self.progress_str [i] = self.format[1];
//    }
      _progress_str = [[_Text_ self.format[1] times:current_step] withString:[zSPC times:self.steps-current_step]];
                
//    for(int i=current_step; i < self.steps;i++) {
//      bar->progress_str[i] = ' ';
//    }
//    self.progress_str[bar->steps] = 0;
    self.step = current_step;

    // Draw using a rough estimated time remaining.
    // Time remaining is estimated quite roughly, as the number of increments
    // remaining * the average time per increment thus far.
    double offset = difftime(time(NULL), self.start);
    unsigned int estimate;
    if (self.value > 0 && offset > 0)
       estimate = (offset/(long double)self.value) * (self.max - self.value);
    else
      estimate = 0;
    [self draw:estimate];
  }
}

- _Void_ increment { self.value++; }

- _Void_ draw:(unsigned int) timeleft {

  // Convert the time to display into HHH:MM:SS

  unsigned int h = timeleft/3600,
               m = timeleft/60,
               s = timeleft ___

  timeleft -= h*3600;
  timeleft -= m*60;

  // ...and display!
  _last_printed = printf("%s %s%s%s ETA:%2dh%02dm%02ds\r", self.label.UTF8String,
                                                                   [self.format[0] UTF8String],
                                                                   self.progress_str.UTF8String,
                                                                   [self.format[2] UTF8String],
                                                                      h,m,s);
}
- _Void_ finish {

  // Draw one more time, with the actual time to completion instead of a useless 00:00:00 remaining estimate.
  unsigned int offset = time(NULL) - (self.start);
  // Make sure we fill the progressbar too, so things look complete.
  //  for(int i=0;i<bar->steps;i++) { bar->progress_str[i] = [
  _progress_str = [_Text_ _format[1] times:_steps];
  [self draw:offset];
  // Print a newline, so that future outputs to stderr look prettier
  fprintf(stderr,"\n");
}

￭

//_AT _UInt max, value, steps, step;
//_RO  time_t start;
//_NA  _Text label;
//_RO  char *progress_str;
//_NA  char *format;
//_RO  int last_printed;


//SYNTHESIZE_ASC_PRIMITIVE_BLOCK (ftty, setFtty, _UInt, ^{ if (!value && self.fclr) value = self.fclr.tty; },
//                                                      ^{ self.fclr = [Colr fromTTY:value = MID(value, 0, 255)];                     })
//
//SYNTHESIZE_ASC_PRIMITIVE_BLOCK (btty, setBtty, _UInt, ^{ if (!value && self.bclr) value = self.bclr.tty; },
//                                                      ^{ self.bclr = [Colr fromTTY:value = MID(value, 0, 255)];                     })
// if (!value && self.ftty) self.fclr = value = [Colr fromTTY:self.ftty]; },
// if(value) self.ftty = [value tty]; })
// if(value) self.btty = [value tty]; }) // if (!value && self.ftty) self.fclr = value = [Colr fromTTY:self.ftty]; },// }, // if (!value && self.btty) self.bclr = (value = [Colr fromTTY:self.btty]);},
