#import "TVStreamCellView.h"

#import "TVImageManager.h"

@implementation TVImageManager

+ (TVImageManager *)shared {
  static TVImageManager *shared = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    shared = [[TVImageManager alloc] init];
  });

  return shared;
}

- (id)init {
  if ((self = [super init]) == nil) {
    return nil;
  }

  _images = [[NSMutableDictionary alloc] init];
  _cells = [[NSMutableDictionary alloc] init];

  return self;
}

- (void)dealloc {
  _images = nil;
  _cells = nil;
}

- (void)clear {
  [_images removeAllObjects];
}

- (void)clearRequestsForTarget:(id)target {
  [_cells removeObjectForKey:[NSString stringWithFormat:@"%p", target]];
}

- (void)loadImageForCellView:(TVStreamCellView *)cellView withURL:(NSString *)URL {
  if (URL == nil) {
    return;
  }

  NSString *identifier = [NSString stringWithFormat:@"%p", cellView];

  NSImage *loadedImage = [_images objectForKey:URL];
  if (loadedImage != nil) {
    cellView.image = loadedImage;
    [cellView setNeedsDisplay:YES];
    return;
  }

  [_cells setObject:cellView forKey:identifier];

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURL *imageURL = [NSURL URLWithString:URL];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    if (data == nil) {
      return;
    }

    NSImage *loadedImage = [[NSImage alloc] initWithData:data];

    dispatch_sync(dispatch_get_main_queue(), ^{
      [_images setObject:loadedImage forKey:URL];
      TVStreamCellView *view = [_cells objectForKey:identifier];
      view.image = loadedImage;
      [view setNeedsDisplay:YES];
    });
  });
}

@end
