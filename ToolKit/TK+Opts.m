
#import <ToolKit/ToolKit.h>
#import "TK_Private.h"

@Plan _IO_Opts { id specialArgs; } @synthesize getOpts = _getOpts, rules = _rules;

_TT opt  __Text_ k { return self.getOpts[k][0]; }
_LT opts __Text_   k { return self.getOpts[k]; }

_IT hasOpt __Text_ key { return [[self.getOpts.allKeys vFK:@"lowercaseString"] containsObject:key]; }

_VD finalize          { if (!self.wantsHelp) return; [self.help echo]; exit(0); }

_IT wantsHelp         { return !IO.args.count || [IO.args any:^BOOL(id o) { return [o containsString:@"help"]; }]; }

_VD test __List_ args { NSLog(@"inside the vageen :%@", specialArgs = args); }

_TT help              {

  return [[_rules reduce:^id(id memo, id key, id value) {

  _List otherKeys = value[@"keys"];

  return [memo stringByAppendingFormat:@"--%@%s%@		\"%@\"\n", key,
             otherKeys.count ? ",  -" : "",
             otherKeys.count ? [otherKeys joinedBy:@",  -"] : @"", value[@"brief"]];

  }
         withInitialMemo:$(@"\n%@ %@\n\n", [@"Usage:"[PINK] ioString],[_PI.arguments[0][BLUE]ioString])]
              withFormat:@"\n\n%@",[self.getOpts.stringRep[ORANGE] ioString]];

} //#ifdef DEBUG #else string]; #endif

_DT getOpts           {   // if ((!parseAgain || !rules.count) && _getOpts) return _getOpts;

  id opts = @{}.mutableCopy; __block id flag;

  if (specialArgs) NSLog(@"evaluating: %@", specialArgs);

  for (NSString *argv in specialArgs ?: [_PI.arguments subarrayFromIndex:1]){

    BOOL argIsFlag = [argv hasPrefix:@"-"];

    if (argIsFlag) {

      flag = [argv stringByReplacingAllOccurancesOfString:@"-" withString:@""];

      [_rules enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
          for (id k in obj[@"keys"])
            if ([k isEqualToString:flag]) { flag = [key copy]; *stop = YES; }
        }];

      opts[flag] = @[].mutableCopy;
    }
    else {

        if (flag) [opts[flag] addObject:argv];
        else [opts[@"?"] = opts[@"?"] ?: @[].mC addObject:argv];
    }
  }
  return _getOpts = [opts copy];
}

_VD __registerOpt __List_ opt { _rules = _rules ?: @{}.mC;

  NSParameterAssert(opt && opt.count);

  id key = opt.count > 1 ? opt[1] : opt[0];

  _rules[[key lowercaseString]] = @{  @"keys" : [opt subarrayFromIndex:opt.count > 1 ? 2 : 1],
                                     @"brief" : opt.count > 1 ? opt[0] : @"",
                                  @"required" : @([key isUppercase]) };
}

/// @[@"Uasge" [optional], @"key"[required, make CAPS if opt itself is REQUIRED!], @"k", @"keeey" [optional]

_VD registerOpts __List_ arrayOfOptsArrays {

  [self performSelector:@selector(__registerOpt:) withObjects:arrayOfOptsArrays];
}

_VD getOpt __Text_ usageThenKeyThenShortOpts __ ... {

  azva_list_to_nsarray(usageThenKeyThenShortOpts,opts); [self __registerOpt:opts];
}

@end


//      if(flag)  [opts[flag] addObject:arg];
//      else   {  [opts[@"?"] = opts[@"?"] ?: @[].mC addObject:arg];
//      else { flag = arg; opts[flag] = @[].mC; }
//    });
//  [_rules each:^(id primaryKey, id info) {
//    if ([d.allKeys containsAny:info[@"keys"]]) {
//      d[primaryKey] = [info[@"keys"] reduce:d[primaryKey]?:@[].mC
//                                  withBlock:^id(id sum, id obj) { id set;
//        if ((set = [d objectForKey:obj]))
//        [sum addObjectsFromArray:[List array:set]]; return sum;
//      }];
//    }
//  }];
//  parseAgain = NO;
//  return _getOpts = [d copy];
//    else {} else { if (argIsFlag) fl //argIsFlag && ![opts objectForKey:flag = arg] ? ({ opts[flag] = @[].mC; }) : ({
////        id existing = opts[flag]; // doesn't have - prefix ... adding or creating a value.
//        else [opts[flag] addObject:arg];
//      }) : ({ [opts[@"?"] = opts[@"?"] ?: @[].mC addObject:arg];
//       arrayByAddingObject:arg].mC;
//                                  [existing isKindOfClass:NSArray.class] ?
//                                  [existing arrayByAddingObject:arg]     : @[existing, arg]; });
// }) : ({ argIsFlag && !opts[flag = arg] ? ({ opts[flag] = @[].mC; })  // no current flag. save value.. create new flag capture.
// : ({ opts[@"?"] = [opts[@"?"] ?: @[] arrayByAddingObject:arg]; flag = nil; }); // No '-', add to unnamed array. });
