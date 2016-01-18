//
//  TestAnimationViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/30.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "CCLaunchViewController.h"
#import "AuthorizeHelper.h"
#import <pop/POP.h>
#import "VBFPopFlatButton.h"

@interface CCLaunchViewController (){
    BOOL show;
}
@property (nonatomic,strong) UIView *blurBG;
@property (nonatomic,strong) UIView *square;
@property (nonatomic,strong) VBFPopFlatButton *close;
@property (nonatomic,strong) UIButton *wechatLogin;
@property (nonatomic,strong) UIButton *qqLogin;
@property (nonatomic,strong) UIButton *facebookLogin;
@property (nonatomic,strong) UIButton *weiboLogin;
@property (nonatomic,strong) UIButton *mobileLogin;
@property (nonatomic,strong) UIButton *agreementShow;
@property (nonatomic,strong) UIButton *registerAccount;
@end

@implementation CCLaunchViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    show = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    UIView *blurBG = [[UIView alloc] initWithFrame:self.view.frame];
    [blurBG setUserInteractionEnabled:NO];
    [blurBG setAlpha:0.0];
    [self.view addSubview:blurBG];
    
    if(iOS8){
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * blur = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        [blur setFrame:self.view.frame];
        [blur setUserInteractionEnabled:NO];
        [blurBG addSubview:blur];
    }else{
        [blurBG setBackgroundColor:CCamBarTintColor];
    }
    self.blurBG = blurBG;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth - 40, CCamViewWidth)];
    [view setCenter:CGPointMake(CCamViewWidth/2, -CCamViewWidth)];
    [view setBackgroundColor:CCamViewBackgroundColor];
    
    [view.layer setCornerRadius:10.];
    [self.view addSubview:view];
    self.square = view;
    
    
    UIButton *wechatLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatLogin setFrame:CGRectMake(50, 100, 50, 50)];
    [wechatLogin setBackgroundImage:[UIImage imageNamed:@"wechatIcon"] forState:UIControlStateNormal];
    [wechatLogin setBackgroundColor:CCamGoldColor];
    [wechatLogin.layer setMasksToBounds:YES];
    [wechatLogin.layer setCornerRadius:wechatLogin.frame.size.height/2];
    [self.square addSubview:wechatLogin];
    self.wechatLogin = wechatLogin;
    
    UIButton *weiboLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiboLogin setFrame:CGRectMake(50+15+50, 100, 50, 50)];
    [weiboLogin setBackgroundImage:[UIImage imageNamed:@"weiboIcon"] forState:UIControlStateNormal];
    [weiboLogin setBackgroundColor:CCamGoldColor];
    [weiboLogin.layer setMasksToBounds:YES];
    [weiboLogin.layer setCornerRadius:weiboLogin.frame.size.height/2];
    [self.square addSubview:weiboLogin];
    self.weiboLogin = weiboLogin;
    
    UIButton *qqLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqLogin setFrame:CGRectMake(50+15*2+50*2, 100, 50, 50)];
    [qqLogin setBackgroundImage:[UIImage imageNamed:@"qqIcon"] forState:UIControlStateNormal];
    [qqLogin setBackgroundColor:CCamGoldColor];
    [qqLogin.layer setMasksToBounds:YES];
    [qqLogin.layer setCornerRadius:qqLogin.frame.size.height/2];
    [self.square addSubview:qqLogin];
    self.qqLogin = qqLogin;
    
    UIButton *facebookLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookLogin setFrame:CGRectMake(50+15*3+50*3, 100, 50, 50)];
    [facebookLogin setBackgroundImage:[UIImage imageNamed:@"facebookIcon"] forState:UIControlStateNormal];
    [facebookLogin setBackgroundColor:CCamGoldColor];
    [facebookLogin.layer setMasksToBounds:YES];
    [facebookLogin.layer setCornerRadius:facebookLogin.frame.size.height/2];
    [self.square addSubview:facebookLogin];
    self.facebookLogin = facebookLogin;
    
    UIButton *mobileLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [mobileLogin setFrame:CGRectMake(50, 200, 200, 50)];
    [mobileLogin setImage:[UIImage imageNamed:@"mobileLogin"] forState:UIControlStateNormal];
    [mobileLogin setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [mobileLogin setTitle:@"手机号码登录" forState:UIControlStateNormal];
    [mobileLogin setBackgroundColor:CCamGoldColor];
    [mobileLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.square addSubview:mobileLogin];
    self.mobileLogin = mobileLogin;
    
    UIButton *agreementShow = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreementShow setFrame:CGRectMake(50, 280, 300, 50)];
    NSMutableAttributedString *agreementStr = [[NSMutableAttributedString alloc] initWithString:@"我同意《角色相机试用协议》"];
    NSRange strRange = {0,[agreementStr length]};
    [agreementStr addAttribute:NSUnderlineStyleAttributeName
                        value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                         range:strRange];
    [agreementShow setAttributedTitle:agreementStr forState:UIControlStateNormal];
    [agreementShow setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [agreementShow setBackgroundColor:[UIColor clearColor]];
    [agreementShow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreementShow.titleLabel setFont:[UIFont systemFontOfSize:11.]];
    [self.square addSubview:agreementShow];
    self.mobileLogin = agreementShow;
    
    UIButton *registerAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerAccount setFrame:CGRectMake(50, 330, 300, 50)];
    [registerAccount setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerAccount setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [registerAccount setBackgroundColor:[UIColor clearColor]];
    [registerAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerAccount.titleLabel setFont:[UIFont systemFontOfSize:11.]];
    [self.square addSubview:registerAccount];
    self.registerAccount = registerAccount;
    
    VBFPopFlatButton *close = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(15, 15, 30, 30) buttonType:buttonCloseType buttonStyle:buttonPlainStyle animateToInitialState:YES];
    close.lineThickness = 2;
    [close setTintColor:CCamGoldColor forState:UIControlStateNormal];
    [close setTintColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [close addTarget:self
                action:@selector(hideBouncesAnimation:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [self.square addSubview:close];
    self.close = close;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [self popBouncesAnimation];
}

- (void)popBouncesAnimation{
    NSLog(@"pop animation");
    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anBasic.fromValue = @(0.0);
    if (iOS8) {
        anBasic.toValue =  @(1.0);
    }else{
        anBasic.toValue = @(0.8);
    }
    anBasic.beginTime = CACurrentMediaTime();
    anBasic.duration = 0.25f;
    [self.blurBG pop_addAnimation:anBasic forKey:@"fade"];
    
    
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.fromValue = @(-CCamViewWidth);
    anSpring.toValue = @(self.view.center.y);
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.springBounciness = 10.0f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [self.square pop_addAnimation:anSpring forKey:@"position"];
}
- (void)hideBouncesAnimation:(id)sender{
    NSLog(@"hide animation");
    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
    if (iOS8) {
        anBasic.fromValue =  @(1.0);
    }else{
        anBasic.fromValue = @(0.8);
    }
    anBasic.toValue = @(0.0);
    
    anBasic.beginTime = CACurrentMediaTime();
    anBasic.duration = 0.25f;
    [self.blurBG pop_addAnimation:anBasic forKey:@"fade"];
    
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.fromValue = @(self.view.center.y);
    anSpring.toValue = @(CCamViewHeight+CCamViewWidth);
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.springBounciness = 10.0f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [[AuthorizeHelper sharedManager] dismissAuthorizeView];
        }
    }];
    [self.square pop_addAnimation:anSpring forKey:@"position"];
}
@end
