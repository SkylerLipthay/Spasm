#import "SNRHUDTextField.h"
#import "SNRHUDButton.h"

#import "TVStreamFooterView.h"

@implementation TVStreamFooterView

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];

	_input = [[SNRHUDTextField alloc] initWithFrame:NSMakeRect(20, 21, 150, 24)];
	_input.font = [NSFont systemFontOfSize:13];
  _input.delegate = self;
  [[_input cell] setPlaceholderString:@"Channel name"];
	[self addSubview:_input];

  NSButton *button = [[SNRHUDButton alloc] initWithFrame:NSMakeRect(180, 20, 110, 26)];
  button.target = self;
  button.action = @selector(buttonPressed);
  button.title = @"Load Channel";
  [self addSubview:button];

	return self;
}

- (void)buttonPressed {
  if (_input.stringValue.length == 0) {
    return;
  }

  [_delegate footerView:self requestedChannelWithName:_input.stringValue];
}

- (BOOL)control:(NSControl *)control
       textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector {
  if (commandSelector == @selector(insertNewline:)) {
    [self buttonPressed];
    return YES;
  }

  return NO;
}

@end
