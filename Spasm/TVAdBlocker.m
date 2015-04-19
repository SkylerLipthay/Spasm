#import "WebViewProxy.h"

#import "TVAdBlocker.h"

@implementation TVAdBlocker

+ (TVAdBlocker *)shared {
  static TVAdBlocker *shared = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    shared = [[TVAdBlocker alloc] init];
  });

  return shared;
}

- (id)init {
  if ((self = [super init]) == nil) {
    return nil;
  }

  [WebViewProxy handleRequestsWithHost:@"www.twitch.proxy" handler:^(NSURLRequest* req, WVPResponse *res) {
    [res respondWithHTML:[[TVAdBlocker shared] code]];
  }];

  return self;
}

- (void)setOriginalJTVURL:(NSURL *)originalJTVURL {
  if (_originalJTVURL != nil) {
    return;
  }

  _originalJTVURL = [originalJTVURL copy];
  NSData *data = [NSData dataWithContentsOfURL:originalJTVURL];
  _originalJTVCode = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
  NSString *hookCode = @";i.requestAds=function(){};var kint=setInterval(function(){if(1||t.contentPlayer.src != ''){e(i).trigger('allAdsCompleted');clearInterval(kint);}},100);i.initialize()";
  _newJTVCode = [_originalJTVCode stringByReplacingOccurrencesOfString:@",i.initialize()"
                                                            withString:hookCode];
}

- (NSString *)code {
  return [self.class shouldBlockAds] ? _newJTVCode : _originalJTVCode;
}

+ (BOOL)shouldBlockAds {
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldBlockAds"];
}

+ (void)setShouldBlockAds:(BOOL)shouldBlockAds {
  [[NSUserDefaults standardUserDefaults] setBool:shouldBlockAds forKey:@"shouldBlockAds"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
