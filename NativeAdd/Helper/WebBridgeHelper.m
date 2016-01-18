//
//  WebBridgeHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import "WebBridgeHelper.h"

@implementation WebBridgeHelper

+ (WebBridgeHelper*)sharedManager
{
    static dispatch_once_t pred;
    static WebBridgeHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (WebViewJavascriptBridge*)returnNewWebBridgeWithWebView:(UIWebView*)webview{
    WebViewJavascriptBridge *bridge = [WebViewJavascriptBridge bridgeForWebView:webview webViewDelegate:webview.delegate handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"Received message from javascript: %@", data);
//        responseCallback(@"");
    }];
    return bridge;
}

@end
