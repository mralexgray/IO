
#import "TK_Private.h"

Text *              _fakeBundleIdentifier = nil;
Text * const     TerminalNotifierBundleID = @"nl.superalloy.oss.terminal-notifier",
     * const NotificationCenterUIBundleID = @"com.apple.notificationcenterui";

#define NSAppKitVersionNumber10_8 1187 // Set OS Params
#define NSAppKitVersionNumber10_9 1265

#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)

/// @note Overriding bundleIdentifier works, but overriding NSUserNotificationAlertStyle does not work.

@XtraPlan(NSBundle,FakeBundleIdentifier)

- _Text_ __bundleIdentifier { return self == NSBundle.mainBundle ? _fakeBundleIdentifier
                                     ?: TerminalNotifierBundleID : self.__bundleIdentifier;
}

- _Text_ clinotifier__bundleIdentifier {
  
/*!  since this app doesn't use NSApplication we cannot pass any arbitary app id,
  we only can pass some existing app id otherwise notifications will be send to daemon,
  but not presented to the user radar://11956694.
  after swizzling original method will have the same name as current */

  return self == NSBundle.mainBundle ? @"com.apple.finder" : self.clinotifier__bundleIdentifier;
}

@XtraStop(FakeBundleIdentifier)

@Plan IONotifier

#if !TARGET_OS_IPHONE

static _IsIt isMavericks() { return !(floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_8); /* MO On a 10.8 - 10.8.x system, YES on 10.9 or later system */ }

static _IsIt InstallFakeBundleIdentifierHook() {

  Class class; if (!(class = objc_getClass("NSBundle"))) return NO;

  Method origMethod = class_getInstanceMethod(class, @selector(bundleIdentifier));

  _Text (*origBID)(_ObjC, SEL) = (_Void*)method_getImplementation(origMethod);

  return class_replaceMethod(class, @selector(bundleIdentifier), imp_implementationWithBlock(^NSString*(id self, SEL sel){

    return self == NSBundle.mainBundle ? _fakeBundleIdentifier ?: TerminalNotifierBundleID : origBID(self, sel);

  }), "@:@"), YES; //  return ncDelegate->_fakeBundleID ?: @"com.apple.finder"; }), "@:@"); method_exchangeImplementations(class_getInstanceMethod(class, @selector(bundleIdentifier)), class_getInstanceMethod(class, @selector(__bundleIdentifier)));
}

+ _Void_ load { Class class = objc_getClass("NSBundle");

/*! it turns out that NSUserNotificationCenter doesn't want to work with CLI Foundation apps,
  and the only reason for this is the app identifier. I haven't found a way to 'fake' Info.plist,
  pass a dictionary directly to NSBundle construction so I just swizzled
  -[NSBundle bundleIdentifier] method for [NSBundle mainBundle] */

    method_exchangeImplementations(class_getInstanceMethod(class, @selector(bundleIdentifier)),
                                   class_getInstanceMethod(class, @selector(clinotifier__bundleIdentifier)));
}

- initWithNotification:_Note_ n { SUPERINIT;

  NSUNOT *userNotification = n.userInfo[NSApplicationLaunchUserNotificationKey];
  if (userNotification) return [self userActivatedNotification:userNotification], self;


  if ([NSProcessInfo.processInfo.arguments indexOfObject:@"-help"] != NSNotFound) [self printHelpBanner], exit(0);

  NSArray *runningProcesses = [NSWorkspace.sharedWorkspace.runningApplications valueForKey:@"bundleIdentifier"];

  if ([runningProcesses indexOfObject:NotificationCenterUIBundleID] == NSNotFound)
    NSLog(@"[!] Unable to post a notification for the current user (%@), as it has no running NotificationCenter instance.", NSUserName()), exit(1);

  NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;

  NSString *subtitle = defaults[@"subtitle"];
  NSString *message  = defaults[@"message"];
  NSString *remove   = defaults[@"remove"];
  NSString *list     = defaults[@"list"];
  NSString *sound    = defaults[@"sound"];

  // If there is no message and data is piped to the application, use that instead.

  message = message || isatty(STDIN_FILENO) ? message :

    [NSString.alloc initWithData:[NSData dataWithData:NSFileHandle.fileHandleWithStandardInput.readDataToEndOfFile]
                                             encoding:NSUTF8StringEncoding];

  if (!message && !remove && !list) [self printHelpBanner], exit(1);

  if (list) [self listNotificationWithGroupID:list], exit(0);

  // Install the fake bundle ID hook so we can fake the sender. This also needs to be done to be able to remove a message.
  if (defaults[@"sender"]) {
    @autoreleasepool {
      if (InstallFakeBundleIdentifierHook()) {
        _fakeBundleIdentifier = defaults[@"sender"];
      }
    }
  }

  if (remove) {
    [self removeNotificationWithGroupID:remove];
    if (message == nil) exit(0);
  }

  if (message) {
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    if (defaults[@"activate"]) options[@"bundleID"]         = defaults[@"activate"];
    if (defaults[@"group"])    options[@"groupID"]          = defaults[@"group"];
    if (defaults[@"execute"])  options[@"command"]          = defaults[@"execute"];
    if (defaults[@"appIcon"])  options[@"appIcon"]          = defaults[@"appIcon"];
    if (defaults[@"contentImage"]) options[@"contentImage"] = defaults[@"contentImage"];
    if (defaults[@"open"]) {
        /*
         * it may be better to use stringByAddingPercentEncodingWithAllowedCharacters instead of stringByAddingPercentEscapesUsingEncoding,
         * but stringByAddingPercentEncodingWithAllowedCharacters is only available on OS X 10.9 or higher.
         */
        NSString *encodedURL = [defaults[@"open"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:defaults[@"open"]];
        NSString *fragment = [url fragment];
        if (fragment) {
            options[@"open"] = [self decodeFragmentInURL:encodedURL fragment:fragment];
        } else {
            options[@"open"] = encodedURL;
        }
    }

    [self deliverNotificationWithTitle:defaults[@"title"] ?: @"Terminal"
                              subtitle:subtitle
                               message:message
                               options:options
                                 sound:sound];
  }
  return self;
}

- _Void_  deliverNotificationWithTitle:(NSString*)title       subtitle:(NSString*)subtitle
                               message:(NSString*)message      options:(NSDictionary*)options
                                                                 sound:(NSString*)sound {

  // First remove earlier notification with the same group ID.
  if (options[@"groupID"]) [self removeNotificationWithGroupID:options[@"groupID"]];

  NSUserNotification *userNotification = [NSUserNotification new];
  userNotification.title = title;
  userNotification.subtitle = subtitle;
  userNotification.informativeText = message;
  userNotification.userInfo = options;

  if(isMavericks()){
    // Mavericks options
    if(options[@"appIcon"]){
      // replacement app icon
      [userNotification setValue:[self getImageFromURL:options[@"appIcon"]] forKey:@"_identityImage"];
      [userNotification setValue:@(false) forKey:@"_identityImageHasBorder"];
    }
    if(options[@"contentImage"]){
      // content image
      userNotification.contentImage = [self getImageFromURL:options[@"contentImage"]];
    }
  }

  if (sound != nil) {
    userNotification.soundName = [sound isEqualToString: @"default"] ? NSUserNotificationDefaultSoundName : sound ;
  }

  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  center.delegate = _ObjC_ self;
  [center scheduleNotification:userNotification];
}

- _Void_ removeNotificationWithGroupID:(NSString*)groupID {

  for (NSUserNotification *userNotification in AZUNOTC.deliveredNotifications) {
    if ([@"ALL" isEqualToString:groupID] || [userNotification.userInfo[@"groupID"] isEqualToString:groupID]) {
      printf("* Removing previously sent notification, which was sent on: %s\n", userNotification.actualDeliveryDate.description.UTF8String);
      [AZUNOTC removeDeliveredNotification:userNotification];
    }
  }
}

- _Void_   listNotificationWithGroupID:(NSString*)listGroupID {

  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];

  NSMutableArray *lines = @[].mC;

  for (NSUNOT *userNotification in center.deliveredNotifications) {
    NSString *deliveredgroupID = userNotification.userInfo[@"groupID"],
             *title            = userNotification.title,
             *subtitle         = userNotification.subtitle,
             *message          = userNotification.informativeText,
             *deliveredAt      = [userNotification.actualDeliveryDate description];

    if (SameString(@"ALL",listGroupID)|| SameString(deliveredgroupID,listGroupID))
      [lines addObject:$(@"%@\t%@\t%@\t%@\t%@", deliveredgroupID, title, subtitle, message, deliveredAt)];

  }

  if (lines.count > 0) { printf("GroupID\tTitle\tSubtitle\tMessage\tDelivered At\n");
    for (NSString *line in lines) printf("%s\n", [line UTF8String]);
  }
}

- _Void_     userActivatedNotification:(NSUserNotification*)userNotification {

  [AZUNOTC removeDeliveredNotification:userNotification];

  NSString *groupID  = userNotification.userInfo[@"groupID"],
           *bundleID = userNotification.userInfo[@"bundleID"],
           *command  = userNotification.userInfo[@"command"],
           *open     = userNotification.userInfo[@"open"];

  NSLog(@"User activated notification:");
  NSLog(@" group ID: %@", groupID);
  NSLog(@"    title: %@", userNotification.title);
  NSLog(@" subtitle: %@", userNotification.subtitle);
  NSLog(@"  message: %@", userNotification.informativeText);
  NSLog(@"bundle ID: %@", bundleID);
  NSLog(@"  command: %@", command);
  NSLog(@"     open: %@", open);

  BOOL success = YES;
  if (bundleID) success &= [self activateAppWithBundleID:bundleID];
  if (command)  success &= [self executeShellCommand:command];
  if (open)     success &= [AZWORKSPACE openURL:open.urlified];

  exit(success ? 0 : 1);
}

- (BOOL)       activateAppWithBundleID:(NSString*)bundleID {

  id app = [SBApplication applicationWithBundleIdentifier:bundleID];
  return app ? [app activate], YES : NSLog(@"Unable to find an application with the specified bundle indentifier."), NO;
}

- (BOOL)           executeShellCommand:(NSString*)command {

  NSPipe *pipe = [NSPipe pipe];
  NSFileHandle *fileHandle = [pipe fileHandleForReading];

  NSTask *task = [NSTask new];
  task.launchPath = @"/bin/sh";
  task.arguments = @[@"-c", command];
  task.standardOutput = pipe;
  task.standardError = pipe;
  [task launch];

  NSData *data = nil;
  NSMutableData *accumulatedData = [NSMutableData data];
  while ((data = [fileHandle availableData]) && [data length]) {
    [accumulatedData appendData:data];
  }

  [task waitUntilExit];
  NSLog(@"command output:\n%@", [[NSString alloc] initWithData:accumulatedData encoding:NSUTF8StringEncoding]);
  return [task terminationStatus] == 0;
}

- (BOOL)        userNotificationCenter:(__unused uNCtr) center
             shouldPresentNotification:(__unused uNote) userNotification {

  return YES;
}

- _Void_        userNotificationCenter:(__unused uNCtr) center
                didDeliverNotification:(__unused uNote) userNotification {

  exit(0); /// Once the notification is delivered we can exit.
}

#pragma mark - Helpers

- (NSImage*)           getImageFromURL:(NSString*) url {

  NSURL *imageURL = [NSURL URLWithString:url];
  return [NSImage.alloc initWithContentsOfURL:imageURL.scheme.length ? imageURL
                                 /* Prefix 'file://' if no scheme */ : [NSURL fileURLWithPath:url]];
}

- (NSString*)       decodeFragmentInURL:(NSString*)encodedURL fragment:(NSString*)framgent {

/*! @abstract Decode fragment identifier
    @see http://tools.ietf.org/html/rfc3986#section-2.1
    @see http://en.wikipedia.org/wiki/URI_scheme
 */

    NSString *beforeStr = [@"%23" stringByAppendingString:framgent],
              *afterStr  = [@"#" stringByAppendingString:framgent];
  return [encodedURL stringByReplacingOccurrencesOfString:beforeStr withString:afterStr];
}
- _Void_ printHelpBanner {

  const char *appName = [[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleExecutable"] UTF8String],
          *appVersion = [[NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] UTF8String];

#define BG(x)   "\e[48;5;"#x"m"
#define FG(x)   "\e[38;5;"#x"m"
#define RESET   "\e[0m"

  printf("\n" BG(2) "%s (%s)\e[m  %sis a command-line tool to send OS X User Notifications." RESET "\n\
\n\
Usage: %s -[message|list|remove] [VALUE|ID|ID] [options]\n\
\n\
\e[38;5;88mEither of these is required (unless message data is piped to the tool):\n\
\n\
  -help              " FG(3) "Display this help banner.\n\
  -message VALUE     The notification message.\n\
  -remove ID         Removes a notification with the specified ‘group’ ID.\n\
  -list ID           If the specified ‘group’ ID exists show when it was delivered,\n\
                     or use ‘ALL’ as ID to see all notifications.\n\
                     The output is a tab-separated list." RESET "\n\
\n\
Optional:\n\
\n\
  -title VALUE       The notification title. Defaults to ‘Terminal’.\n\
  -subtitle VALUE    The notification subtitle.\n\
  -sound NAME        The name of a sound to play when the notification appears. The names are listed\n\
                     in Sound Preferences. Use 'default' for the default notification sound.\n\
  -group ID          A string which identifies the group the notifications belong to.\n\
                     Old notifications with the same ID will be removed.\n\
  -activate ID       The bundle identifier of the application to activate when the user clicks the notification.\n\
  -sender ID         The bundle identifier of the application that should be shown as the sender, including its icon.\n\
  -appIcon URL       The URL of a image to display instead of the application icon (Mavericks+ only)\n\
  -contentImage URL  The URL of a image to display attached to the notification (Mavericks+ only)\n\
  -open URL          The URL of a resource to open when the user clicks the notification.\n\
  -execute COMMAND   A shell command to perform when the user clicks the notification.\n\
\n\
When the user activates a notification, the results are logged to the system logs.\n\
Use Console.app to view these logs.\n\
\n\
Note that in some circumstances the first character of a message has to be escaped in order to be recognized.\n\
An example of this is when using an open bracket, which has to be escaped like so: ‘\n\\n\[’.\n\
\n\
For more information see https://github.com/alloy/terminal-notifier.\n\n", appName, appVersion,FG(3),appName);

}
￭


@interface EVSCLINotifier : NSObject <NSUserNotificationCenterDelegate>

@property NSFileHandle *stdinFileHandle;
@property NSUserNotificationCenter *userNotificationCenter;

@end

@implementation EVSCLINotifier

- init {
  if (!(self = [super init])) return nil;

  _stdinFileHandle = NSFileHandle.fileHandleWithStandardInput;
  __block EVSCLINotifier * bSelf = self;
  _stdinFileHandle.readabilityHandler = ^(NSFileHandle *fileHandle){

      NSString *str = [[NSString.alloc initWithData:fileHandle.availableData encoding:NSUTF8StringEncoding]
                                                 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
      !str.length ?: [bSelf postMessage:str];
  };
  (_userNotificationCenter =  
  NSUserNotificationCenter.defaultUserNotificationCenter).delegate = self;

  return self;
}

- _Void_ run {
    [self.stdinFileHandle waitForDataInBackgroundAndNotify];
    [NSRunLoop.currentRunLoop run];
}

- _Void_ postMessage:(NSString *)message {
    NSUserNotification *notification = NSUserNotification.new;
    notification.title = @"CLI Notifier";
    notification.informativeText = message;

    NSLog(@"scheduling: %@", notification);

    [self.userNotificationCenter scheduleNotification:notification];
}

- _Void_ userNotificationCenter:(__unused uNCtr)cntr didDeliverNotification:(__unused uNote)note {
    NSLog(@"delivered: %@", note);
}

- _Void_ userNotificationCenter:(__unused uNCtr)cntr  didActivateNotification:(__unused uNote) note {
    NSLog(@"activated: %@", note);
}

#endif

￭


//int main(int argc, char const *argv[])
//{
//
//   @autoreleasepool {
//
//    EVSCLINotifier *cliNotifier = EVSCLINotifier.new;
//    [cliNotifier run];
//
//  }
//    return 0;
//}

//#import <ScriptingBridge/ScriptingBridge.h>
