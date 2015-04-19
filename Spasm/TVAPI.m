#import "TVAPI.h"

const NSString *TVAPIClientID = @"kklpgyip3o5rdx4ru8c3gerjegmyecg";
const NSString *TVAPIRoot = @"https://api.twitch.tv/";

@implementation TVAPI

+ (NSURL *)authorizationURL {
  NSDictionary *parameters = [self generateParameters:@{ @"response_type": @"token",
                                                         @"redirect_uri": @"spasm://control",
                                                         @"scope": @"user_read" }];
  return [NSURL URLWithString:[self URLStringForPath:@"kraken/oauth2/authorize" parameters:parameters]];
}

+ (NSURL *)streamListURLWithOffset:(NSUInteger)offset {
  NSDictionary *parameters = [self generateParameters:@{ @"limit": @(100), @"offset": @(offset) }];
  return [NSURL URLWithString:[self URLStringForPath:@"kraken/streams/followed" parameters:parameters]];
}

+ (NSURL *)streamURLWithName:(NSString *)name {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://twitch.tv/%@/hls", name]];
}

+ (NSURL *)chatURLWithName:(NSString *)name {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://twitch.tv/%@/chat", name]];
}

+ (NSDictionary *)generateParameters:(NSDictionary *)parameters {
  NSMutableDictionary *result = [parameters mutableCopy];
  [result setObject:TVAPIClientID forKey:@"client_id"];
  return result;
}

+ (NSString *)URLStringForPath:(NSString *)path parameters:(NSDictionary *)parameters {
  NSString *parametersString = [self queryStringFromParameters:parameters];
  return [NSString stringWithFormat:@"%@%@?%@", TVAPIRoot, path, parametersString];
}

+ (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
  if (parameters == nil) {
    return @"";
  }

  NSMutableArray *parts = [NSMutableArray array];

  for (id key in parameters) {
    id value = [parameters objectForKey:key];
    NSString *part = [NSString stringWithFormat: @"%@=%@", [self URLEncode:key], [self URLEncode:value]];
    [parts addObject: part];
  }

  return [parts componentsJoinedByString: @"&"];
}

+ (NSString *)URLEncode:(id)object {
  NSString *objectString = [NSString stringWithFormat:@"%@", object];
  return [objectString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)URLQueryParameters:(NSURL *)URL {
  NSString *queryString = [URL fragment];
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  NSArray *parameters = [queryString componentsSeparatedByString:@"&"];

  for (NSString *parameter in parameters) {
    NSArray *parts = [parameter componentsSeparatedByString:@"="];
    const NSStringEncoding encoding = NSUTF8StringEncoding;
    NSString *key = [[parts objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding];
    if ([parts count] > 1) {
      id value = [[parts objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding];
      [result setObject:value forKey:key];
    }
  }

  return result;
}

@end
