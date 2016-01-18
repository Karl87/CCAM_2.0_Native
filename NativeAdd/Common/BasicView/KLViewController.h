//
//  KLViewController.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/16.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+WebCache.h"
#import "CoreDataHelper.h"
#import "AuthorizeHelper.h"

@interface KLViewController : UIViewController

@property (nonatomic,strong) NSString * vcTitle;
@property (nonatomic,strong) NSString * vcType;
@property (nonatomic,strong) NSString * vcURL;
@property (assign) BOOL setNavigationBar;

@property (assign,nonatomic) BOOL isScrollBackground;

- (UIScrollView*)returnScrollViewWithFrame:(CGRect)frame contentSize:(CGSize)contentSize pageEnable:(BOOL)pageEnable bounces:(BOOL)bounces backgroundColor:(UIColor*)color parentView:(UIView*)parentView;
- (UIRefreshControl*)returnUIRefreshControlWithTintColor:(UIColor*)tintColor initString:(NSString*)initString textColor:(UIColor*)textColor textFont:(UIFont*)textFont parentView:(UIView*)parentView action:(SEL)action;
@end
