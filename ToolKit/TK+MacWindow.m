//
//  TK+MacWindow.m
//  ToolKit
//
//  Created by Alex Gray on 4/22/15.
//  Copyright (c) 2015 Alex Gray. All rights reserved.
//

#import "TK+MacWindow.h"

_Enum(CardinalDirection, North, NorthEast, East, SouthEast, South, SouthWest, West, NorthWest)

@KIND(CardinalDirectionHelper)
- initWithRect __Rect_ r cornerInset __Flot_ c sideInset __Flot_ s;
- (CardinalDirection) directionForPoint __Cord_ p;
_RT rectForDirection:(CardinalDirection)direction;
_PR _Rect rect;
_PR _Flot cornerInset, sideInset;
@end

@Kind_(CleanFrameView,View)
#if MAC_ONLY
_RO NSCursor * northWestSouthEastCursor, *northeastsouthwestCursor, *eastWestCursor, *northSouthCursor;
#endif
_NA _Colr shadowColor, backgroundColor, strokeColor;
_NA _Flot cornerRadius, shadowBlurRadius, strokeLineWidth, resizeInsetSideWidth, resizeInsetCornerWidth;
@end

#if MAC_ONLY

@Plan CleanFrameWindow @dynamic strokeColor; //shadowColor, backgroundColor, , cornerRadius, shadowBlurRadius, strokeLineWidth, resizeInsetSideWidth, resizeInsetCornerWidth;


//- forwardingTargetForSelector __Meth_ s { return ![self respondsToSelector:s] ? self.contentView : [super forwardingTargetForSelector:s]; }

- initWithFrame __Rect_ r {

  self = [super initWithContentRect:r styleMask:NSBorderlessWindowMask backing: NSBackingStoreBuffered defer:NO];

  self.movableByWindowBackground  = false;
  self.alphaValue                 = 1;
  self.opaque                     = false;
  self.backgroundColor            = RED;//[NSColor r:0.145 g:0.608 b:0.604 a:1];
  self.hasShadow                  = false;
  self.contentView                = [CleanFrameView withRect:r];
  self.releasedWhenClosed         = false;
  return self;
}

_IT canBecomeMainWindow  { return YES; }

_IT canBecomeKeyWindow { return YES; }

@end


@Plan CleanFrameView { _Pict _cacheImage; }

- (CardinalDirectionHelper*) buildDirectionHelper {
  _Rect rect = NSInsetRect(self.bounds, self.shadowBlurRadius, self.shadowBlurRadius);
  return [CardinalDirectionHelper.alloc initWithRect:rect cornerInset:_resizeInsetCornerWidth sideInset:_resizeInsetSideWidth];
}


_VD mouseDown __Evnt_ theEvent {

  _Cord pointInView = [self convertPoint:theEvent.locationInWindow fromView: nil];
  _IsIt resize      = false;

  id directionHelper = self.buildDirectionHelper;
  CardinalDirection direction = [directionHelper directionForPoint:pointInView];

  if (direction < (CardinalDirection)NSIntegerMax) {
    resize = true;
    [self.window setMovableByWindowBackground:NO];
    [NCTR postNotificationName:NSWindowWillStartLiveResizeNotification object: self.window];
  }

  _Rect originalMouseLocationRect = [self.window convertRectToScreen:(NSRect){theEvent.locationInWindow,CGSizeZero}];
  _Cord originalMouseLocation     = originalMouseLocationRect.origin;
  _Rect originalFrame             = self.window.frame,
  windowFrame               = self.window.frame;
  _Cord delta                     = NSZeroPoint;

  while (YES) {

    _Evnt newEvent = [self.window nextEventMatchingMask:NSLeftMouseDraggedMask | NSLeftMouseUpMask];

    if (newEvent.type == NSLeftMouseUp) {
      [NCTR postNotificationName:NSWindowDidEndLiveResizeNotification object: self.window]; break;
    }

    _Rect newMouseLocationRect  = [self.window convertRectToScreen:(NSRect){newEvent.locationInWindow,CGSizeZero}];
    _Cord newMouseLocation      = newMouseLocationRect.origin;
    delta.x += (newMouseLocation.x - originalMouseLocation.x);
    delta.y += (newMouseLocation.y - originalMouseLocation.y);

    // println("delta: \(delta)")

    //var newFrame = originalFrame

    _Flot treshold  = 0,
    absdeltay = fabs(delta.y),
    absdeltax = fabs(delta.x);

    //            println("x/y: \(absdeltax) \(absdeltay)")

    if (resize && (fabs(delta.y) >= treshold || fabs(delta.x) >= treshold)) {

      // resize

      switch (direction) {
        case North:
            delta.y = windowFrame.size.height + delta.y > self.window.minSize.height ? delta.y : self.window.minSize.height - windowFrame.size.height;
          //
                    windowFrame.size.height += delta.y;
                    [self.window setFrame:windowFrame display: true animate: false];

        case NorthEast:
          //          delta.x = (windowFrame.size.width + delta.x > self.window!.minSize.width ? delta.x : self.window!.minSize.width - windowFrame.size.width)
          //          delta.y = (windowFrame.size.height + delta.y > self.window!.minSize.height ? delta.y : self.window!.minSize.height - windowFrame.size.height)
          //
          //          windowFrame.size.height += delta.y
          //          windowFrame.size.width += delta.x
          //          window.setFrame(windowFrame, display: true, animate: false)

        case East:
          //          delta.x = (windowFrame.size.width + delta.x > self.window!.minSize.width ? delta.x : self.window!.minSize.width - windowFrame.size.width)
          //
          //          windowFrame.size.width += delta.x
          //          window.setFrame(windowFrame, display: true, animate: false)

        case SouthEast:
          //          delta.x = (windowFrame.size.width + delta.x > self.window!.minSize.width ? delta.x : self.window!.minSize.width - windowFrame.size.width)
          //          delta.y = (windowFrame.size.height - delta.y > self.window!.minSize.height ? delta.y : windowFrame.size.height - self.window!.minSize.height)
          //
          //          windowFrame.size.width += delta.x
          //          windowFrame.size.height -= delta.y
          //          windowFrame.origin.y += delta.y
          //          window.setFrame(windowFrame, display: true, animate: false)

        case South:
          //          delta.y = (windowFrame.size.height - delta.y > self.window!.minSize.height ? delta.y : windowFrame.size.height - self.window!.minSize.height)
          //
          //          windowFrame.size.height -= delta.y
          //          windowFrame.origin.y += delta.y
          //          window.setFrame(windowFrame, display: true, animate: false)

        case SouthWest:
          //          delta.x = (windowFrame.size.width - delta.x > self.window!.minSize.width ? delta.x : windowFrame.size.width - self.window!.minSize.width)
          //          delta.y = (windowFrame.size.height - delta.y > self.window!.minSize.height ? delta.y : windowFrame.size.height - self.window!.minSize.height)

          //          windowFrame.origin.x += delta.x
          //          windowFrame.size.width -= delta.x
          //          windowFrame.size.height -= delta.y
          //          windowFrame.origin.y += delta.y
          //          window.setFrame(windowFrame, display: true, animate: false)
          //
        case West:
          //          delta.x = (windowFrame.size.width - delta.x > self.window!.minSize.width ? delta.x : windowFrame.size.width - self.window!.minSize.width)
          //
          //          windowFrame.origin.x += delta.x
          //          windowFrame.size.width -= delta.x
          //          window.setFrame(windowFrame, display: true, animate: false)

        case NorthWest:
          //          delta.x = (windowFrame.size.width - delta.x > self.window!.minSize.width ? delta.x : windowFrame.size.width - self.window!.minSize.width)
          //          delta.y = (windowFrame.size.height + delta.y > self.window!.minSize.height ? delta.y : self.window!.minSize.height - windowFrame.size.height)
          //
          //          windowFrame.origin.x += delta.x
          //          windowFrame.size.width -= delta.x
          //          windowFrame.size.height += delta.y
          //          window.setFrame(windowFrame, display: true, animate: false)
        default:
          break;
      }

      delta = NSZeroPoint;
    }
    if (!resize) {
      windowFrame.origin.x += delta.x;
      windowFrame.origin.y += delta.y;
      [self.window setFrame:windowFrame display: true animate: false];
      delta = NSZeroPoint;
    }
    originalMouseLocation = newMouseLocation;
  }
}

_VD drawRect __Rect_ r {

  if (!NSEqualSizes(_cacheImage.size, self.bounds.size) || !_cacheImage) {

    [_cacheImage = [NSImage.alloc initWithSize: self.bounds.size] lockFocus];

    _Rect rect = NSInsetRect(self.bounds, self.shadowBlurRadius, self.shadowBlurRadius);

    [NSGraphicsContext saveGraphicsState];

    NSShadow *shadow = NSShadow.new;
    shadow.shadowColor = self.shadowColor;
    shadow.shadowBlurRadius = self.shadowBlurRadius;
    [shadow set];

    NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect: rect xRadius: self.cornerRadius yRadius: self.cornerRadius];
    [self.backgroundColor setFill];
    [backgroundPath fill];

    [NSGraphicsContext restoreGraphicsState];

    rect.origin.x += 0.5;
    rect.origin.y += 0.5;
    NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect: rect xRadius: self.cornerRadius yRadius: self.cornerRadius];
    //        let borderPath = NSBezierPath(rect: rect)
    borderPath.lineWidth = self.strokeLineWidth;

    [self.strokeColor setStroke];
    [borderPath stroke];

    //       NSColor.redColor().setFill()
    //       NSRectFill(CGRect(x:0,y:0,width:10,height:100))//self.resizeRect())

    [_cacheImage unlockFocus];
    // println("set cache");
  } else {
    // println("load cache");
  }

  NSLog(@"cache: %@", _cacheImage);
  [RED set];
  NSRectFill(r);
//  [_cacheImage drawAtPoint:NSZeroPoint fromRect:NSZeroRect  operation:NSCompositeCopy fraction: 1];
}

- initWithFrame __Rect_ f {

  SUPERINITWITHFRAME(f);

  _cornerRadius = 5;
  _shadowBlurRadius = 15;
  _shadowColor =  BLACK;

  _Bndl bundle  = [Bndl bundleForClass:self.class];
  _Pict northWestSouthEastImage   = [NSImage imageNamed:@"resizenorthwestsoutheast.pdf"];// imageWithContentsOfFile:[bundle pathForResource:"" ofType:"pdf"]];
  _northWestSouthEastCursor = [NSCursor.alloc initWithImage:northWestSouthEastImage hotSpot:(NSPoint){northWestSouthEastImage.size.width/2, northWestSouthEastImage.size.height/2}];

  // /
  _Pict northeastsouthwestImage   = [NSImage imageNamed:@"resizenortheastsouthwest"];// NSImage(contentsOfFile: bundle.pathForResource("resizenortheastsouthwest", ofType:"pdf")!)!
  _northeastsouthwestCursor = [NSCursor.alloc initWithImage:northeastsouthwestImage hotSpot:(NSPoint){northeastsouthwestImage.size.width/2, northeastsouthwestImage.size.height/2}];

  // -
  _Pict eastWestImage   = [NSImage imageNamed:@"resizeeastwest"];// NSImage(contentsOfFile:bundle.pathForResource("resizeeastwest", ofType:"pdf")!)!
  _eastWestCursor = [NSCursor.alloc initWithImage:eastWestImage hotSpot:(NSPoint){eastWestImage.size.width/2, eastWestImage.size.height/2}];

  // |
  _Pict northSouthImage   = [NSImage imageNamed:@"resizenorthsouth"];// NSImage(contentsOfFile: bundle.pathForResource("resizenorthsouth", ofType:"pdf")!)!
  _northSouthCursor = [NSCursor.alloc initWithImage:northSouthImage hotSpot:(NSPoint){northSouthImage.size.width/2, northSouthImage.size.height/2}];

  //    self.wantsLayer = false // YES will made text drawing a little thinner compared to textview

  //      self.cacheImage = nil
  //      self.needsDisplay = true
  //    }
  //  }
  //  public var shadowBlurRadius: CGFloat = 15 {
  //    didSet {
  //      self.cacheImage = nil
  //      self.needsDisplay = true
  //    }
  //  }
  //  public var shadowColor: NSColor = NSColor(calibratedRed:0, green:0, blue:0, alpha:0.085) {
  //    didSet {
  //      self.cacheImage = nil
  //      self.needsDisplay = true
  //    }
  //  }
  //  public var backgroundColor: NSColor = NSColor.whiteColor() {
  //    didSet {
  //      self.cacheImage = nil
  //      self.needsDisplay = true
  //    }
  //  }
  //
  //  public var backgroundColor strokeColor: NSColor = NSColor(calibratedRed: 220/255, green: 220/255, blue: 220/255, alpha: 1) {
  //    didSet {
  //      self.cacheImage = nil
  //      self.needsDisplay = true
  //    }
  //  }
  //  public var strokeLineWidth: CGFloat = 0.5 {
  //    didSet {
  //      self.cacheImage = nil
  //      self.needsDisplay = true
  //    }
  //  }
  //  let resizeInsetCornerWidth = CGFloat(10)
  //  let   resizeInsetSideWidth = CGFloat(2)
  //
  //  var cacheImageSize = NSSize()
  //  var cacheImage: NSImage?

  return self;
}
- (NSEdgeInsets) alignmentRectInsets {
  return (NSEdgeInsets){ self.shadowBlurRadius, self.shadowBlurRadius, self.shadowBlurRadius, self.shadowBlurRadius};
}

_VD resetCursorRects {

  id directionHelper = self.buildDirectionHelper;

  [self addCursorRect:[directionHelper rectForDirection:North] cursor:_northSouthCursor];
  [self addCursorRect:[directionHelper rectForDirection:NorthEast] cursor:_northeastsouthwestCursor];

  [self addCursorRect:[directionHelper rectForDirection:East] cursor:_eastWestCursor];
  [self addCursorRect:[directionHelper rectForDirection:SouthEast] cursor:_northWestSouthEastCursor];
  [self addCursorRect:[directionHelper rectForDirection:South] cursor:_northSouthCursor];
  [self addCursorRect:[directionHelper rectForDirection:SouthWest] cursor:_northeastsouthwestCursor];
  [self addCursorRect:[directionHelper rectForDirection:West] cursor:_eastWestCursor];
    [self addCursorRect:[directionHelper rectForDirection:NorthWest] cursor:_northWestSouthEastCursor];

}

@end
#endif

/*

 // MARK:  Cursor

 override public func resetCursorRects() {

 let directionHelper = self.buildDirectionHelper()

 self.addCursorRect(directionHelper.rectForDirection(.North), cursor: northSouthCursor)
 self.addCursorRect(directionHelper.rectForDirection(.NorthEast), cursor: northeastsouthwestCursor)
 self.addCursorRect(directionHelper.rectForDirection(.East), cursor: eastWestCursor)
 self.addCursorRect(directionHelper.rectForDirection(.SouthEast), cursor: northWestSouthEastCursor)
 self.addCursorRect(directionHelper.rectForDirection(.South), cursor: northSouthCursor)
 self.addCursorRect(directionHelper.rectForDirection(.SouthWest), cursor: northeastsouthwestCursor)
 self.addCursorRect(directionHelper.rectForDirection(.West), cursor: eastWestCursor)
 self.addCursorRect(directionHelper.rectForDirection(.NorthWest), cursor: northWestSouthEastCursor)
 }

 private func buildDirectionHelper() -> CardinalDirectionHelper {
 var rect = self.bounds
 rect.inset(dx: self.shadowBlurRadius, dy: self.shadowBlurRadius)
 let directionHelper = CardinalDirectionHelper(rect: rect, cornerInset: resizeInsetCornerWidth, sideInset: resizeInsetSideWidth)
 return directionHelper
 }

 */


@Plan CardinalDirectionHelper
- initWithRect __Rect_ r cornerInset __Flot_ c sideInset __Flot_ s {  SUPERINIT;
  _rect         = r;
  _cornerInset  = c;
  _sideInset    = s; return self;
}
- (CardinalDirection) directionForPoint __Cord_ p  {

  return [[CardinalDirectionxVal().allKeys filterOne:^BOOL(id direction) {

    return NSPointInRect(p, [self rectForDirection:[direction intValue]]);
  }] intValue];
}
_RT rectForDirection:(CardinalDirection)direction {

  _Flot southTopCorner  = _rect.origin.y + _cornerInset,
  southTopSide    = _rect.origin.y + _sideInset,
  southBottom     = _rect.origin.y;

  _Flot northTop        = NSMaxY(_rect),
  northBottomCorner = northTop - _cornerInset,
  northBottomSide   = northTop - _sideInset;

  _Flot westLeft        = _rect.origin.x,
  westRightCorner = westLeft + _cornerInset,
  westRightSide   = westLeft + _sideInset;

  _Flot eastRight       = NSMaxX(_rect),
  eastLeftCorner  = eastRight - _cornerInset,
  eastLeftSide    = eastRight - _sideInset;

  return  direction == North     ? (NSRect){westRightCorner, northBottomSide, eastLeftCorner - westRightCorner, _sideInset}  :
  NSZeroRect;
  //            direction == .NorthEast ? NSRect(x: eastLeftCorner,   y: northBottomCorner, width: cornerInset,                       height: cornerInset) :
  //            direction == .East      ? NSRect(x: eastLeftSide,     y: southTopCorner,    width: sideInset,                         height: northBottomCorner - southTopCorner) :
  //            direction == .SouthEast ? NSRect(x: eastLeftCorner,   y: southBottom,       width: cornerInset,                       height: cornerInset) :
  //            direction == .South     ? NSRect(x: westRightCorner,  y: southBottom,       width: eastLeftCorner - westRightCorner,  height: sideInset)  :
  //            direction == .SouthWest ? NSRect(x: westLeft,         y: southBottom,       width: cornerInset,                       height: cornerInset) :
  //            direction == .West      ? NSRect(x: westLeft,         y: southTopCorner,    width: sideInset,                         height: northBottomCorner - southTopCorner) :
  //            direction == .NorthWest ? NSRect(x: westLeft,         y: northBottomCorner, width: cornerInset,                       height: cornerInset) : CGRectZero
  
  //  }
  
}
@end

