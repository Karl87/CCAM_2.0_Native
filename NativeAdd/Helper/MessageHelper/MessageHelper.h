//
//  MessageHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/1.
//
//

#import <Foundation/Foundation.h>
#import "KLTabBarController.h"

@interface MessageHelper : NSObject

@property (nonatomic, strong) NSString *messageCount;
@property (nonatomic,strong) KLTabBarController *tabVC;

/*单例MessageHelper*/
+ (MessageHelper*)sharedManager;
/*启动计时器*/
- (void)initTimer;
/*结束计时器*/
- (void)invalidateTimer;
/*尝试更新Message*/
- (void)updateMessage;
/*更新MessageUI*/
- (void)updateMessageUI;
@end
