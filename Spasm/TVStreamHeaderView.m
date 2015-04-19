#import "TVStreamHeaderView.h"

@implementation TVStreamHeaderView

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];

	_headerLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 0, 300, 24)];
	_headerLabel.bezeled = NO;
	_headerLabel.drawsBackground = NO;
	_headerLabel.selectable = NO;
  _headerLabel.textColor = [NSColor whiteColor];
	_headerLabel.font = [NSFont systemFontOfSize:24];
  NSShadow *shadow = [NSShadow new];
  [shadow setShadowColor:[NSColor colorWithWhite:0 alpha:0.75]];
  [shadow setShadowOffset:CGSizeMake(0, 1)];
  _headerLabel.shadow = shadow;
  _headerLabel.stringValue = @"Live Followed Channels";

	[self addSubview:_headerLabel];

	return self;
}

@end
