//
//  ShareHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import <Foundation/Foundation.h>
#import "ShareViewController.h"
#import "CCTimeLine.h"

@interface ShareHelper : NSObject
+ (ShareHelper*)sharedManager;
- (void)initShareSDK;

- (void)callShareViewIsMyself:(BOOL)myself delegate:(id)delegate timeline:(CCTimeLine*)timeline indexPath:(NSIndexPath*)indexPath onlyShare:(BOOL)onlyShare shareImage:(BOOL)shareImage;
- (void)dismissShareView;
@end
