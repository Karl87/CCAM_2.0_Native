//
//  WebBridgeHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridge.h"

@interface WebBridgeHelper : NSObject

+ (WebBridgeHelper*)sharedManager;
- (WebViewJavascriptBridge*)returnNewWebBridgeWithWebView:(UIWebView*)webview;
@end
