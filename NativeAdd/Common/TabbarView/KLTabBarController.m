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

//test
#import "TestPostRequestWebViewController.h"
#import "KLImagePickerViewController.h"

@interface KLTabBarController () <UITabBarDelegate>

@property (nonatomic,strong) UIWindow * authorizeWindow;

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
        
    CCHomeViewController *vc_home = [[CCHomeViewController alloc] init];
    CCEventViewController *vc_event = [[CCEventViewController alloc] init];
    CCEventViewController *vc_nil = [[CCEventViewController alloc] init];
    CCSerieViewController *vc_serie = [[CCSerieViewController alloc] init];
    CCUserViewController *vc_me = [[CCUserViewController alloc] init];
    vc_me.showSetting = YES;
    
    [DataHelper sharedManager].serieVC = vc_serie;
    
    vc_me.vcTitle = @"我";
    vc_event.vcTitle = @"活动";
    vc_home.vcTitle = @"首页";
    vc_serie.vcTitle = @"系列";
    vc_nil.vcTitle = @"";
    
    vc_me.setNavigationBar =YES;
    vc_event.setNavigationBar = YES;
    vc_home.setNavigationBar = YES;
    vc_serie.setNavigationBar = YES;
    vc_nil.setNavigationBar = YES;
    
    KLNavigationController *navc1 = [[KLNavigationController alloc] initWithRootViewController:vc_home];
    KLNavigationController *navc2= [[KLNavigationController alloc] initWithRootViewController:vc_event];
    KLNavigationController *navc3 = [[KLNavigationController alloc] initWithRootViewController:vc_nil];
    KLNavigationController *navc4 = [[KLNavigationController alloc] initWithRootViewController:vc_serie];
    KLNavigationController *navc5 = [[KLNavigationController alloc] initWithRootViewController:vc_me];
    
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
    
    tabBarItem_home.title = @"Home";
    tabBarItem_home.image = [UIImage imageNamed:@"tabHomeIcon"];
    tabBarItem_discovery.title = @"Event";
    tabBarItem_discovery.image = [UIImage imageNamed:@"tabEventIcon"];
    tabBarItem_capture.title = @"";
    tabBarItem_message.title = @"Serie";
    tabBarItem_message.image = [UIImage imageNamed:@"tabSerieIcon"];
    tabBarItem_me.title = @"Me";
    tabBarItem_me.image = [UIImage imageNamed:@"tabMeIcon"];

    UIButton *midBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [midBtn setTintColor:CCamRedColor];
    [midBtn setBackgroundImage:[[UIImage imageNamed:@"tabCaptureIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [midBtn setFrame:CGRectMake(0, 0, 97.0/3, 90.0/3)];
    [midBtn addTarget:self action:@selector(customTabbarItemOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:midBtn];
    [self.tabBar setShadowImage:[[UIImage alloc] init]];

    [midBtn setCenter:CGPointMake(self.tabBar.frame.size.width/2, self.tabBar.frame.size.height/2)];
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
@end
