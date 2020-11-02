//
//  RNInspectorBridge.m
//  RNInspector
//
//  Created by Paker on 02/11/20.
//

#import <React/RCTConvert.h>
#import "RNInspectorBridge.h"
#import "IOSInspector.h"

@implementation RNInspectorBridge

RCT_EXPORT_MODULE(RNInspector);

RCT_EXPORT_METHOD(sendRequestWithUID:(nonnull NSString *)uid request:(nonnull NSDictionary *)request) {
  NSMutableURLRequest *m_request = [[NSMutableURLRequest alloc] init];
  m_request.URL = [NSURL URLWithString:[RCTConvert NSString:request[@"url"]]];
  m_request.HTTPMethod = [RCTConvert NSString:request[@"method"]];
  m_request.allHTTPHeaderFields = [RCTConvert NSDictionary:request[@"headers"]];
  m_request.HTTPBody = [RCTConvert NSData:request[@"body"]];
  [IOSInspector sendRequestWithUID:uid request:m_request];
}

RCT_EXPORT_METHOD(sendResponseWithUID:(nonnull NSString *)uid response:(nonnull NSDictionary *)response body:(nullable NSString *)body) {
  NSHTTPURLResponse *m_response = [[NSHTTPURLResponse alloc]
                                   initWithURL:[NSURL URLWithString:@""]
                                    statusCode:[RCTConvert NSInteger:response[@"status"]]
                                   HTTPVersion:@"1.1"
                                  headerFields:[RCTConvert NSDictionary:response[@"headers"]]];
  [IOSInspector sendResponseWithUID:uid response:m_response body:[RCTConvert NSData:body]];
}

@end
