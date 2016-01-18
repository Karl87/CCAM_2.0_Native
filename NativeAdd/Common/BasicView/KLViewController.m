//
//  KLViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/16.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLViewController.h"

@implementation KLViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (self.setNavigationBar) {
//        if(iOS8){
//            [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//            UIVisualEffectView * blur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//            [blur setFrame:CGRectMake(0, -20, CCamViewWidth, CCamNavigationBarHeight)];
//            blur.userInteractionEnabled = NO;
//            [self.navigationController.navigationBar insertSubview:blur atIndex:0];
//        }else{
            [self.navigationController.navigationBar setBarTintColor:CCamRedColor];
//        }
        [self.navigationController.navigationBar setTranslucent:NO];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        shadow.shadowOffset = CGSizeMake(0, 1);
        [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                                          [UIColor whiteColor], NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self setTitle:self.vcTitle];
    [self.view setBackgroundColor:CCamViewBackgroundColor];
}

- (UIScrollView*)returnScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)contentSize pageEnable:(BOOL)pageEnable bounces:(BOOL)bounces backgroundColor:(UIColor*)color parentView:(UIView*)parentView{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [scrollView setContentSize:contentSize];
    [scrollView setPagingEnabled:pageEnable];
    [scrollView setBounces:bounces];
    [scrollView setBackgroundColor:color];
    [parentView addSubview:scrollView];

    return scrollView;
}
- (UIRefreshControl*)returnUIRefreshControlWithTintColor:(UIColor*)tintColor initString:(NSString*)initString textColor:(UIColor*)textColor textFont:(UIFont*)textFont parentView:(UIView*)parentView action:(SEL)action{
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh setUserInteractionEnabled:NO];
    [refresh setTintColor:tintColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:initString
                                                              attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                          textColor,NSForegroundColorAttributeName,
                                                                          textFont,NSFontAttributeName, nil]];
    
    [refresh addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [parentView addSubview:refresh];
    
    return refresh;
}

@end
