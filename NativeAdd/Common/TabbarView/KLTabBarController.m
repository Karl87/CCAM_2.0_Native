//
//  KLTabBarController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/17.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLTabBarController.h"
#import "KLNavigationController.h"

#import "CCamHelper.h"
#import "CCHomeViewController.h"
#import "CCEventViewController.h"
#import "CCSerieViewController.h"
#import "CCUserViewController.h"

#import "LaunchScreenViewController.h"

//test
#import "TestPostRequestWebViewController.h"
#import "KLImagePickerViewController.h"

@interface KLTabBarController () <UITabBarDelegate>

@property (nonatomic,strong) CCHomeViewController *vc_home;
@property (nonatomic,strong) CCEventViewController *vc_event;
@property (nonatomic,strong) CCSerieViewController *vc_serie;
@property (nonatomic,strong) CCUserViewController *vc_me;

@property (nonatomic,strong) UIWindow * authorizeWindow;
@property (nonatomic,strong) LaunchScreenViewController *launchScreen;
@property (nonatomic,assign) NSUInteger lastSelectedIndex;
@end

@implementation KLTabBarController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MessageHelper sharedManager].tabVC = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MessageHelper sharedManager].tabVC = nil;
}
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    _lastSelectedIndex = 0;
    
    _vc_home = [[CCHomeViewController alloc] init];
    _vc_event = [[CCEventViewController alloc] init];
    CCEventViewController *vc_nil = [[CCEventViewController alloc] init];
    _vc_serie = [[CCSerieViewController alloc] init];
    _vc_me = [[CCUserViewController alloc] init];
    _vc_me.showSetting = YES;
    
    [DataHelper sharedManager].serieVC = _vc_serie;
    
    _vc_me.vcTitle = NSLocalizedString(@"我", @"");
    _vc_event.vcTitle = NSLocalizedString(@"活动", @"");
    _vc_home.vcTitle = NSLocalizedString(@"首页", @"");
    _vc_serie.vcTitle = NSLocalizedString(@"系列", @"");
    vc_nil.vcTitle = @"";
    
    _vc_me.setNavigationBar =YES;
    _vc_event.setNavigationBar = YES;
    _vc_home.setNavigationBar = YES;
    _vc_serie.setNavigationBar = YES;
    vc_nil.setNavigationBar = YES;
    
    KLNavigationController *navc1 = [[KLNavigationController alloc] initWithRootViewController:_vc_home];
    KLNavigationController *navc2= [[KLNavigationController alloc] initWithRootViewController:_vc_event];
    KLNavigationController *navc3 = [[KLNavigationController alloc] initWithRootViewController:vc_nil];
    KLNavigationController *navc4 = [[KLNavigationController alloc] initWithRootViewController:_vc_serie];
    KLNavigationController *navc5 = [[KLNavigationController alloc] initWithRootViewController:_vc_me];
    
    self.viewControllers = [NSArray arrayWithObjects:navc1, navc2, navc3,navc4,navc5,nil ];
    
    [self.tabBar setTintColor:CCamRedColor];
    if(iOS8){
        [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView * blur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        [blur setFrame:CGRectMake(0, 0, CCamViewWidth, CCamTabBarHeight)];
//        [self.tabBar addSubview:blur];
        
        UIView *tabSurface = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamTabBarHeight)];
        [tabSurface setBackgroundColor:[UIColor whiteColor]];
        [tabSurface setAlpha:0.9];
        [self.tabBar addSubview:tabSurface];
        
    }else{
        [self.tabBar setBarTintColor:CCamBarTintColor];
    }

    UITabBarItem *tabBarItem_home = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem_discovery = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem_capture = [self.tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem_message = [self.tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem_me = [self.tabBar.items objectAtIndex:4];
    
    tabBarItem_home.title = NSLocalizedString(@"首页", @"");
    tabBarItem_home.image = [UIImage imageNamed:@"tabHomeIcon"];
    tabBarItem_discovery.title = NSLocalizedString(@"活动", @"");
    tabBarItem_discovery.image = [UIImage imageNamed:@"tabEventIcon"];
    tabBarItem_capture.title = @"";
    tabBarItem_message.title = NSLocalizedString(@"系列", @"");
    tabBarItem_message.image = [UIImage imageNamed:@"tabSerieIcon"];
    tabBarItem_me.title = NSLocalizedString(@"我", @"");
    tabBarItem_me.image = [UIImage imageNamed:@"tabMeIcon"];

    UIButton *midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [midBtn setTintColor:CCamRedColor];
    [midBtn setBackgroundImage:[[UIImage imageNamed:@"tabCaptureIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [midBtn setFrame:CGRectMake(0, 0, 97.0/3, 90.0/3)];
    [midBtn addTarget:self action:@selector(customTabbarItemOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:midBtn];
    [self.tabBar setShadowImage:[[UIImage alloc] init]];

    [midBtn setCenter:CGPointMake(self.tabBar.frame.size.width/2, self.tabBar.frame.size.height/2)];
    
    
    if ([iOSBindingManager sharedManager].showLauchScreen) {
        _launchScreen = [[LaunchScreenViewController alloc] init];
        [self.view addSubview:_launchScreen.view];
        [iOSBindingManager sharedManager].showLauchScreen = NO;
    }
}

- (void)customTabbarItemOnClick{
    
    if ([[AuthorizeHelper sharedManager] checkToken]) {
        UnitySendMessage(UnityController.UTF8String, "LoadEditScene", "");

    }else{
        [[AuthorizeHelper sharedManager] callAuthorizeView];

    }
    
    
}
- (void)KillWindow{

}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger selectedIndex = [tabBar.items indexOfObject:item];
    if (selectedIndex ==_lastSelectedIndex) {
        _lastSelectedIndex = selectedIndex;
        switch (selectedIndex) {
            case 0:
                [_vc_home returnTopPosition];
                break;
            case 1:
                [_vc_event returnTopPosition];
                break;
            case 3:
                [_vc_serie returnTopPosition];
                break;
            case 4:
                [_vc_me returnTopPosition];
                break;
            default:
                break;
        }
    }else{
        _lastSelectedIndex = selectedIndex;
    }
}
- (void)reloadWhenLogin{
    NSLog(@"reload");
    [_vc_home reloadInfo];
    [_vc_me reloadInfo];
    [_vc_event reloadInfo];
    [_vc_serie reloadInfo];

}
@end
