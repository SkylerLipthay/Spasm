#import <Cocoa/Cocoa.h>

@class TVTab;

@protocol TVTabDelegate

- (void)tabMouseDown:(TVTab *)tab event:(NSEvent *)event;
- (void)tabMouseUp:(TVTab *)tab event:(NSEvent *)event;
- (void)tabDragged:(TVTab *)tab event:(NSEvent *)event;

@end

@class TVTabContents;

@interface TVTab : NSView {
 @private
  BOOL _hover;
  NSPoint _hoverPoint;
  NSTrackingArea *_trackingArea;
}

@property BOOL active;
@property (weak) id<TVTabDelegate> delegate;
@property (setter = setView:, nonatomic) TVTabContents *view;
@property (setter = setTitle:, nonatomic) NSString *title;
@property (readonly) NSButton *closeButton;

@end
