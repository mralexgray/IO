

@import AtoZUniversal;

#define MID(X,MINI,MAXI) MAX( MIN(X,MAXI), MINI )

@protocol Bicolor <NSObject, IndexSet, KeyGet> @concrete

//  @"Apple"[2] -> fg -> 2/256  | color @"Apple"[ORANGE]  -> fgwith ORANGE color

@property                        id fclr, bclr; // NS/UIColor
@property                       int ftty, btty; // 1-255
@property (readonly)           BOOL colored;
@property (readonly, copy) NSString *x;         // ansi esaped "string"

- (id<Bicolor>) withFG:_;
- (id<Bicolor>) withBG:_;

@end

@protocol CLIDelegate <NSObject>

@optional
- (NSString*) optForMethod:(SEL)_;              // Otherwise it is the moethod's first letter.
@property (readonly)   Class   optionClass;     // Otherwise it's YOU!
@property (readonly) NSArray * optionMethods;   // if present, will only opt out these methods.
@concrete
@property (readonly,copy) NSArray *_options;
@property (readonly, copy) NSString *_usage;
@end
