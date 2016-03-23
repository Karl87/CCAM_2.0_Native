//
//  MessageHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/1.
//
//

#import "MessageHelper.h"
#import "CCMessage.h"
#import "AFHTTPSessionManager.h"
#import "CCamHelper.h"
#import "KLNavigationController.h"

@interface MessageHelper()

@property (nonatomic,strong) NSTimer *msgTimer;

@end

@implementation MessageHelper
+ (MessageHelper*)sharedManager
{
    static dispatch_once_t pred;
    static MessageHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (id)init{
    self = [super init];
    if (self) {
        NSLog(@"MessageHelperInit!");
        _messageCount = @"0";
        

    }
    return self;
}
- (void)initTimer{
//    [self addObserver:self forKeyPath:@"receiveMessages" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    if (_msgTimer) {
        if (![_msgTimer isValid]) {
            NSLog(@"取消Timer暂停");
            [_msgTimer fire];
        }
    }else{
        NSLog(@"初始化Timer");
       _msgTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateMessage) userInfo:nil repeats:YES];
    }
}
- (void)invalidateTimer{
    if (_msgTimer) {
        if (_msgTimer.isValid) {
            NSLog(@"Timer暂停");
            [_msgTimer invalidate];
//             [self removeObserver:self forKeyPath:@"messages"];
        }
    }
}
- (void)updateMessage{
    
    
    if (![[AuthorizeHelper sharedManager] checkToken]) {
        NSLog(@"User not login, cancel update message!");
        _messageCount =@"0";
        NSLog(@"%@",_messageCount);
        
        [self updateMessageUI];
        return;
    }
    NSLog(@"update Message!");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"token":[[AuthorizeHelper sharedManager] getUserToken]};
    [manager POST:CCamGetUserMessageCountURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        _messageCount =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",_messageCount);

        [self updateMessageUI];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)updateMessageUI{
    if (_tabVC) {
        UITabBarItem *item =[_tabVC.tabBar.items firstObject];
        if ([_messageCount isEqualToString:@"0"]) {
            item.badgeValue = nil;
        }else{
            item.badgeValue = [NSString stringWithFormat:@"%@",_messageCount];
            if (_tabVC.childViewControllers && [_tabVC.childViewControllers count]) {
                if ([[_tabVC.childViewControllers firstObject] isKindOfClass:[KLNavigationController class]]){
                    KLNavigationController *nv = (KLNavigationController*)[_tabVC.childViewControllers firstObject];
                    if ([nv.topViewController isKindOfClass:[CCHomeViewController class]]){
                        CCHomeViewController *home = (CCHomeViewController*)nv.topViewController;
                        [home reloadMessageHeader];
                    }
                }
            }
        }
    }
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
////    if ([keyPath isEqualToString:@"receiveMessages"]) {
////        if(_tabVC){
////            UITabBarItem *item =[_tabVC.tabBar.items firstObject];
////            item.badgeValue = [NSString stringWithFormat:@"%ld",[_messages count]];
////        }
////    }
//    if (object == self) {
//        if(_tabVC){
//            UITabBarItem *item =[_tabVC.tabBar.items firstObject];
//            item.badgeValue = [NSString stringWithFormat:@"%ld",[_messages count]];
//        }
//    }
//}
- (void)dealloc{
    [self invalidateTimer];
   
}
@end
