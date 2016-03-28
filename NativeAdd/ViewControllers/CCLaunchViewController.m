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
#import <SMS_SDK/SMSSDK.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <MBProgressHUD/MBProgressHUD.h>

#import "AFViewShaker.h"

@interface CCLaunchViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{
    BOOL show;
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) UIView *launchPopBG;
@property (nonatomic,strong) UIView *launchSquare;
@property (nonatomic,strong) UIScrollView *mobileBG;
@property (nonatomic,strong) UIView *platformsBG;

@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) NSMutableArray *segmegtItems;
@property (nonatomic,strong) UIView *segmentView;
@property (nonatomic,strong) UIView *segmentSlider;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) UIButton *loginZone;
@property (nonatomic,strong) UITextField *loginPhone;
@property (nonatomic,strong) AFViewShaker *loginPhoneShaker;
@property (nonatomic,strong) UITextField *loginPsw;
@property (nonatomic,strong) AFViewShaker *loginPswShaker;
@property (nonatomic,strong) UIButton *loginBtn;

@property (nonatomic,strong) UIButton *regZone;
@property (nonatomic,strong) UITextField *regPhone;
@property (nonatomic,strong) AFViewShaker *regPhoneShaker;
@property (nonatomic,strong) UITextField *regPsw;
@property (nonatomic,strong) AFViewShaker *regPswShaker;
@property (nonatomic,strong) UITextField *regCode;
@property (nonatomic,strong) AFViewShaker *regCodeShaker;
@property (nonatomic,strong) UIButton *regCodeBtn;
@property (nonatomic,strong) UIButton *regBtn;

@property (nonatomic,strong) UIButton *wechatBtn;
@property (nonatomic,strong) AFViewShaker *wechatShaker;
@property (nonatomic,strong) UIButton *qqBtn;
@property (nonatomic,strong) UIButton *facebookBtn;
@property (nonatomic,strong) UIButton *weiboBtn;
@property (nonatomic,strong) UIButton *agreementBtn;

@property (nonatomic,strong) UIAlertView *regAlert;
@property (nonatomic,strong) UIAlertView *pswAlert;
@property (nonatomic,strong) UIActionSheet *zoneActionSheet;

@end

@implementation CCLaunchViewController
- (void)callMobileLogin{
    
    [self.view endEditing:YES];
    
    if (![self checkLoginPhoneNumIsAvailable]||![self checkLoginPswIsAvailable]) {
        if (![self checkLoginPswIsAvailable]) {
            [_loginPswShaker shake];
        }
        if (![self checkLoginPhoneNumIsAvailable]) {
            [_loginPhoneShaker shake];
        }
        return;
    }
    NSString *phoneNum = [NSString stringWithFormat:@"%@%@",_regZone.currentTitle,_loginPhone.text];
    NSString *psw = _loginPsw.text;
    [[AuthorizeHelper sharedManager] mobileLoginWithPhone:phoneNum password:psw isLogin:YES];
}
- (NSString *)returnCorrectZone:(NSString *)str{
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
    return str;
}

- (BOOL)checkLoginPswIsAvailable{
    if (_loginPsw.text.length<6 || _loginPsw.text.length>16) {
        return NO;
    }
    return YES;
}
- (BOOL)checkLoginPhoneNumIsAvailable{
    
    NSLog(@"ZONE:%@;PHONE:%@;LENGTH:%ld",_loginZone.currentTitle,_loginPhone.text,_loginPhone.text.length);
    
    if ([_loginZone.currentTitle isEqualToString:@"+86"] && _loginPhone.text.length !=11) {
        return NO;
    }
    if ([_loginZone.currentTitle isEqualToString:@"+852"] && _loginPhone.text.length !=8) {            return NO;
    }
    if ([_loginZone.currentTitle isEqualToString:@"+853"] && _loginPhone.text.length !=8) {            return NO;
    }
    if ([_loginZone.currentTitle isEqualToString:@"+886"] && _loginPhone.text.length !=9) {            return NO;
    }
    if ([_loginZone.currentTitle isEqualToString:@"+1"] && _loginPhone.text.length !=10) {            return NO;
    }
    if ([_loginZone.currentTitle isEqualToString:@"+81"] && _loginPhone.text.length !=10) {            return NO;
    }
    if ([_loginZone.currentTitle isEqualToString:@"+82"]) {
        if (_loginPhone.text.length <6 || _loginPhone.text.length>9) {
            return NO;
        }
    }

    return YES;
}
- (BOOL)checkRegPswIsAvailable{
    if (_regPsw.text.length<6 || _regPsw.text.length>16) {
        return NO;
    }
    return YES;
}
- (BOOL)checkRegPhoneNumIsAvailable{
    if ([_regZone.currentTitle isEqualToString:@"+86"] && _regPhone.text.length !=11) {            return NO;
    }
    if ([_regZone.currentTitle isEqualToString:@"+852"] && _regPhone.text.length !=8) {            return NO;
    }
    if ([_regZone.currentTitle isEqualToString:@"+853"] && _regPhone.text.length !=8) {            return NO;
    }
    if ([_regZone.currentTitle isEqualToString:@"+886"] && _regPhone.text.length !=9) {            return NO;
    }
    if ([_regZone.currentTitle isEqualToString:@"+1"] && _regPhone.text.length !=10) {            return NO;
    }
    if ([_regZone.currentTitle isEqualToString:@"+81"] && _regPhone.text.length !=10) {            return NO;
    }
    if ([_regZone.currentTitle isEqualToString:@"+82"]) {
        if (_loginPhone.text.length <6 || _regPhone.text.length>9) {
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)checkRegCodeIsAvailable{
    if (_regCode.text.length !=4) {
        return NO;
    }
    return YES;
}
- (void)checkPhoneNumIsReged{
    
    [self.view endEditing:YES];
    
    if (![self checkRegPhoneNumIsAvailable] || ![self checkRegPswIsAvailable]) {
        if (![self checkRegPhoneNumIsAvailable]) {
            [_regPhoneShaker shake];
        }
        if (![self checkRegPswIsAvailable]) {
            [_regPswShaker shake];
        }
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Babel(@"校验信息中");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *phoneNum = [NSString stringWithFormat:@"%@%@",_regZone.currentTitle,_regPhone.text];
    NSDictionary *parameters = @{@"phone" :phoneNum};
    [manager POST:CCamCheckPhoneNumURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [hud hide:YES];
        NSString *note = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",note);
        if ([note isEqualToString:@"1"]) {
            [self callSMS];
        }else{
            [self callResetPassword];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
    }];
}
-(void)wechatLogin{
    
    [[AuthorizeHelper sharedManager] getSocialPlatformInfoWithTypeID:@"2" shareType:SSDKPlatformTypeWechat isLogin:YES];
}
- (void)weiboLogin{
    [[AuthorizeHelper sharedManager] getSocialPlatformInfoWithTypeID:@"3" shareType:SSDKPlatformTypeSinaWeibo isLogin:YES];
}
- (void)qqLogin{
    [[AuthorizeHelper sharedManager] getSocialPlatformInfoWithTypeID:@"4" shareType:SSDKPlatformTypeQQ isLogin:YES];
}
- (void)facebookLogin{
    [[AuthorizeHelper sharedManager] getSocialPlatformInfoWithTypeID:@"5" shareType:SSDKPlatformTypeFacebook isLogin:YES];
}
- (void)segItemOnClick:(id)sender{
    [self.view endEditing:YES];
    UIButton *button  = (UIButton*)sender;
    [_mobileBG setContentOffset:CGPointMake(_mobileBG.bounds.size.width*button.tag, _mobileBG.contentOffset.y) animated:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    [self.view endEditing:YES];
    
    if (scrollView == _mobileBG){
        [_segmentSlider setFrame:CGRectMake(scrollView.contentOffset.x * _segmentView.frame.size.width /scrollView.contentSize.width, _segmentSlider.frame.origin.y, _segmentSlider.frame.size.width, _segmentSlider.frame.size.height)];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self.view endEditing:YES];
    
    if (scrollView == _mobileBG){
        if (scrollView.contentOffset.x == 0) {
            [_pageControl setCurrentPage:0];
  
        }else{
            [_pageControl setCurrentPage:1];
 
        }
    }
}

- (void)pageTurn:(UIPageControl*)sender
{
    [self.view endEditing:YES];
    [_mobileBG setContentOffset:CGPointMake(_mobileBG.bounds.size.width*sender.currentPage, _mobileBG.contentOffset.y) animated:NO];
}
- (void)callZone{
    
    [self.view endEditing:YES];
    
    NSString *china = [NSString stringWithFormat:@"+86 %@",Babel(@"中国")];
    NSString *hk = [NSString stringWithFormat:@"+852 %@",Babel(@"中国香港")];
    NSString *mc = [NSString stringWithFormat:@"+853 %@",Babel(@"中国澳门")];
    NSString *tw = [NSString stringWithFormat:@"+886 %@",Babel(@"中国台湾")];
    NSString *us = [NSString stringWithFormat:@"+1 %@",Babel(@"美国")];
    NSString *jp = [NSString stringWithFormat:@"+81 %@",Babel(@"日本")];
    NSString *kr = [NSString stringWithFormat:@"+82 %@",Babel(@"韩国")];
    
    _zoneActionSheet = [[UIActionSheet alloc] initWithTitle:Babel(@"区域选择") delegate:self cancelButtonTitle:Babel(@"取消") destructiveButtonTitle:nil otherButtonTitles:china,hk,mc,tw, us,jp,kr,nil];
    [_zoneActionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet == _zoneActionSheet) {
        switch (buttonIndex) {
            case 0:
                [_loginZone setTitle:@"+86" forState:UIControlStateNormal];
                [_regZone setTitle:@"+86" forState:UIControlStateNormal];
                break;
            case 1:
                [_loginZone setTitle:@"+852" forState:UIControlStateNormal];
                [_regZone setTitle:@"+852" forState:UIControlStateNormal];
                break;
            case 2:
                [_loginZone setTitle:@"+853" forState:UIControlStateNormal];
                [_regZone setTitle:@"+853" forState:UIControlStateNormal];
                break;
            case 3:
                [_loginZone setTitle:@"+886" forState:UIControlStateNormal];
                [_regZone setTitle:@"+886" forState:UIControlStateNormal];
                break;
            case 4:
                [_loginZone setTitle:@"+1" forState:UIControlStateNormal];
                [_regZone setTitle:@"+1" forState:UIControlStateNormal];
                break;
            case 5:
                [_loginZone setTitle:@"+81" forState:UIControlStateNormal];
                [_regZone setTitle:@"+81" forState:UIControlStateNormal];
                break;
            case 6:
                [_loginZone setTitle:@"+82" forState:UIControlStateNormal];
                [_regZone setTitle:@"+82" forState:UIControlStateNormal];
                break;
            default:
                [_loginZone setTitle:@"+86" forState:UIControlStateNormal];
                [_regZone setTitle:@"+86" forState:UIControlStateNormal];
                break;
        }
    }
}
- (void)callResetPassword{
    NSString *message = [NSString stringWithFormat:@"%@ %@%@,\n%@?",_regZone.currentTitle,_regPhone.text,Babel(@"已注册"),Babel(@"是否重置密码")];
    _pswAlert = [[UIAlertView alloc] initWithTitle:Babel(@"确认手机号码") message:message delegate:self cancelButtonTitle:Babel(@"取消") otherButtonTitles:Babel(@"确定"),nil];
    [_pswAlert show];
}
- (void)callSMS{
    
    NSString *message = [NSString stringWithFormat:@"%@:\n%@ %@",Babel(@"我们会将验证码发送至"),_regZone.currentTitle,_regPhone.text];
    _regAlert = [[UIAlertView alloc] initWithTitle:Babel(@"确认手机号码") message:message delegate:self cancelButtonTitle:Babel(@"取消") otherButtonTitles:Babel(@"确定"),nil];
    [_regAlert show];
}
- (void)verifiSMSCode{
    
    [self.view endEditing:YES];
    
    if (![self checkRegPhoneNumIsAvailable] || ![self checkRegPswIsAvailable] || ![self checkRegCodeIsAvailable]) {
        if (![self checkRegCodeIsAvailable]) {
            [_regCodeShaker shake];
        }
        if (![self checkRegPhoneNumIsAvailable]) {
            [_regPhoneShaker shake];
        }
        if (![self checkRegPswIsAvailable]) {
            [_regPswShaker shake];
        }
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Babel(@"验证信息中");

    [SMSSDK commitVerificationCode:_regCode.text phoneNumber:_regPhone.text zone:_regZone.currentTitle result:^(NSError *error) {
        if (!error) {
            hud.labelText = Babel(@"验证成功");
            NSLog(@"验证成功");
            if ([_regBtn.currentTitle isEqualToString:Babel(@"注册")]) {
                [[AuthorizeHelper sharedManager] mobileLoginWithPhone:[NSString stringWithFormat:@"%@%@",_regZone.currentTitle,[_regPhone.text copy]] password:[_regPsw.text copy] isLogin:NO];
            }else if([_regBtn.currentTitle isEqualToString:Babel(@"修改密码")]){
                [[AuthorizeHelper sharedManager] mobileResetPasswordWithPhone:[NSString stringWithFormat:@"%@%@",_regZone.currentTitle,_regPhone.text] password:_regPsw.text];
            }
            [hud hide:YES];
        }else{
            hud.labelText = Babel(@"验证失败");
            NSLog(@"错误信息:%@",error);
            [hud hide:YES afterDelay:1.0f];
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _regAlert) {
        if (buttonIndex == 1) {
            [self getVerificationCode];
            [_regBtn setTitle:Babel(@"注册") forState:UIControlStateNormal];
            
        }
    }else if (alertView == _pswAlert){
        if (buttonIndex == 1) {
            [self getVerificationCode];
            [_regBtn setTitle:Babel(@"修改密码") forState:UIControlStateNormal];
        }
    }
}

- (void)smsTimerCount:(NSInteger)second{
    if (second>0) {
        [_regCodeBtn setEnabled:NO];
        [_regCodeBtn setBackgroundColor:CCamViewBackgroundColor];
        [_regCodeBtn setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
        [_regCodeBtn.titleLabel setText:[NSString stringWithFormat:@"%ld%@",second,Babel(@"秒")]];
        [_regCodeBtn setTitle:[NSString stringWithFormat:@"%ld%@",second,Babel(@"秒")] forState:UIControlStateNormal];
    }else{
        [_regCodeBtn setEnabled:YES];
        [_regCodeBtn setBackgroundColor:CCamYellowColor];
        [_regCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_regCodeBtn.titleLabel setText:Babel(@"获取验证码")];
        [_regCodeBtn setTitle:Babel(@"获取验证码") forState:UIControlStateNormal];
    }
}


- (void)getVerificationCode{
    
    [[AuthorizeHelper sharedManager] startSmsTimer];
    [_regCodeBtn setEnabled:NO];
    [_regCodeBtn setBackgroundColor:CCamViewBackgroundColor];
    [_regCodeBtn setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_regCodeBtn.titleLabel setText:[NSString stringWithFormat:@"30%@",Babel(@"秒")]];
    [_regCodeBtn setTitle:[NSString stringWithFormat:@"30%@",Babel(@"秒")] forState:UIControlStateNormal];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText =Babel(@"获取验证码中");
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_regPhone.text zone:[self returnCorrectZone:_regZone.currentTitle] customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            hud.labelText = Babel(@"获取验证码成功");
            NSLog(@"获取验证码成功");
        } else {
            hud.labelText = Babel(@"获取验证码失败");
            NSLog(@"错误信息：%@",error);
        }
        [hud hide:YES afterDelay:1.0f];
    }];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [SMSSDK registerApp:SMSAppKey
             withSecret:SMSAppSecret];
    
    show = NO;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
    _launchPopBG = [[UIView alloc] initWithFrame:self.view.frame];
    [_launchPopBG setUserInteractionEnabled:NO];
    [_launchPopBG setAlpha:0.0];
    [self.view addSubview:_launchPopBG];
    [_launchPopBG setBackgroundColor:CCamBarTintColor];
    
    _launchSquare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 264*1.2, 330*1.2)];
    [_launchSquare setCenter:CGPointMake(CCamViewWidth/2, CCamViewHeight/2)];
    [_launchSquare setBackgroundColor:[UIColor whiteColor]];
    [_launchSquare.layer setCornerRadius:10.];
    [_launchSquare.layer setMasksToBounds:YES];
    [self.view addSubview:_launchSquare];
//    [_launchSquare setHidden:YES];
    
    _mobileBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, _launchSquare.bounds.size.width, _launchSquare.bounds.size.height-44-109*1.2)];
    [_mobileBG setContentSize:CGSizeMake(2*_mobileBG.bounds.size.width, _mobileBG.bounds
                                        .size.height)];
    [_mobileBG setPagingEnabled:YES];
    [_mobileBG setDelegate:self];
    [_mobileBG setShowsHorizontalScrollIndicator:NO];
    [_launchSquare addSubview:_mobileBG];
    
    NSArray* segArray = @[Babel(@"登录"),Babel(@"注册")];
    _segmegtItems = [[NSMutableArray alloc] initWithCapacity:0];
    
    _segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamSegItemWidth*segArray.count, CCamSegItemHeight)];
    [_segmentView setCenter:CGPointMake(_launchSquare.bounds.size.width/2, 22)];
    [_segmentView setBackgroundColor:[UIColor clearColor]];
    [_launchSquare addSubview:_segmentView];
    
    for (int i = 0 ; i <segArray.count; i++) {
        UIButton *segButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [segButton setFrame:CGRectMake(CCamSegItemWidth*i, 0, CCamSegItemWidth, CCamSegItemHeight)];
        [segButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17.]];
        [segButton setTitle:[segArray objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0) {
            [segButton setTitleColor:CCamRedColor forState:UIControlStateNormal];
        }else{
            [segButton setTitleColor:CCamRedColor forState:UIControlStateNormal];
        }
        [segButton setTitleColor:CCamRedColor forState:UIControlStateHighlighted];
        [segButton setBackgroundColor:[UIColor clearColor]];
        [segButton setTag:i];
        [segButton addTarget:self action:@selector(segItemOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentView addSubview:segButton];
        [_segmegtItems addObject:segButton];
    }
    
    _segmentSlider = [[UIView alloc] initWithFrame:CGRectMake(0, CCamSegItemHeight-CCamSegSliderHeight-5, CCamSegItemWidth, CCamSegSliderHeight)];
    [_segmentSlider setBackgroundColor:[UIColor clearColor]];
    UIView *segmentSlider = [[UIView alloc] initWithFrame:CGRectMake((CCamSegItemWidth-CCamSegSliderWidth)/2, 0, CCamSegSliderWidth, CCamSegSliderHeight)];
    [segmentSlider setBackgroundColor:CCamRedColor];
    [_segmentSlider addSubview:segmentSlider];
    [_segmentView addSubview:_segmentSlider];
    
    
    
    _loginPhone = [[UITextField alloc] initWithFrame:CGRectMake(_launchSquare.bounds.size.width/8, 8, _launchSquare.bounds.size.width*3/4, 40)];
    [_loginPhone setPlaceholder:Babel(@"请输入手机号码")];
    [_loginPhone setFont:[UIFont systemFontOfSize:14.0]];
    [_loginPhone setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_loginPhone setBackgroundColor:CCamViewBackgroundColor];
    [_loginPhone setTextColor:CCamGrayTextColor];
    [_loginPhone.layer setCornerRadius:8.0];
    [_loginPhone.layer setMasksToBounds:YES];
    [_loginPhone setKeyboardType:UIKeyboardTypePhonePad];
    _loginZone = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginZone setFrame:CGRectMake(0, 0, 60, 40)];
    [_loginZone setTitle:@"+86" forState:UIControlStateNormal];
    [_loginZone setBackgroundColor:CCamViewBackgroundColor];
    [_loginZone.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_loginZone setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    _loginPhone.leftView = _loginZone;
    _loginPhone.leftViewMode = UITextFieldViewModeAlways;
    [_loginZone addTarget:self action:@selector(callZone) forControlEvents:UIControlEventTouchUpInside];
    [_mobileBG addSubview:_loginPhone];
    _loginPhoneShaker = [[AFViewShaker alloc] initWithView:_loginPhone];
    
    _loginPsw = [[UITextField alloc] initWithFrame:CGRectMake(_launchSquare.bounds.size.width/8, 40+8*2, _launchSquare.bounds.size.width*3/4, 40)];
    [_loginPsw setPlaceholder:Babel(@"请输入密码")];
    [_loginPsw setFont:[UIFont systemFontOfSize:14.0]];
    [_loginPsw setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_loginPsw setBackgroundColor:CCamViewBackgroundColor];
    [_loginPsw setTextColor:CCamGrayTextColor];
    [_loginPsw setSecureTextEntry:YES];
    [_loginPsw.layer setCornerRadius:8.0];
    [_loginPsw.layer setMasksToBounds:YES];
    _loginPsw.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _loginPsw.leftViewMode = UITextFieldViewModeAlways;
    [_mobileBG addSubview:_loginPsw];
    _loginPswShaker = [[AFViewShaker alloc] initWithView:_loginPsw];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:Babel(@"登录") forState:UIControlStateNormal];
    [_loginBtn setBackgroundColor:CCamRedColor];
    [_loginBtn setFrame:CGRectMake(_launchSquare.bounds.size.width/8, 40*2+8*3, _launchSquare.bounds.size.width*3/4, 40)];
    [_loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:8.0];
    [_loginBtn addTarget:self action:@selector(callMobileLogin) forControlEvents:UIControlEventTouchUpInside];
    [_mobileBG addSubview:_loginBtn];
    
    _regPhone = [[UITextField alloc] initWithFrame:CGRectMake(_launchSquare.bounds.size.width*9/8, 8, _launchSquare.bounds.size.width*3/4, 40)];
    [_regPhone setPlaceholder:Babel(@"请输入手机号码")];
    [_regPhone setFont:[UIFont systemFontOfSize:14.0]];
    [_regPhone setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_regPhone setKeyboardType:UIKeyboardTypePhonePad];
    [_regPhone setBackgroundColor:CCamViewBackgroundColor];
    [_regPhone setTextColor:CCamGrayTextColor];
    [_regPhone.layer setCornerRadius:8.0];
    [_regPhone.layer setMasksToBounds:YES];
    _regZone = [UIButton buttonWithType:UIButtonTypeCustom];
    [_regZone setFrame:CGRectMake(0, 0, 60, 40)];
    [_regZone setTitle:@"+86" forState:UIControlStateNormal];
    [_regZone setBackgroundColor:CCamViewBackgroundColor];
    [_regZone.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_regZone setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    _regPhone.leftView = _regZone;
    _regPhone.leftViewMode = UITextFieldViewModeAlways;
    [_regZone addTarget:self action:@selector(callZone) forControlEvents:UIControlEventTouchUpInside];
    [_mobileBG addSubview:_regPhone];
    _regPhoneShaker = [[AFViewShaker alloc] initWithView:_regPhone];
    
    
    _regPsw = [[UITextField alloc] initWithFrame:CGRectMake(_launchSquare.bounds.size.width*9/8, 40+8*2, _launchSquare.bounds.size.width*3/4, 40)];
    [_regPsw setPlaceholder:Babel(@"请输入密码")];
    [_regPsw setFont:[UIFont systemFontOfSize:14.0]];
    [_regPsw setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_regPsw setBackgroundColor:CCamViewBackgroundColor];
    [_regPsw setTextColor:CCamGrayTextColor];
    [_regPsw setSecureTextEntry:YES];
    [_regPsw.layer setCornerRadius:8.0];
    [_regPsw.layer setMasksToBounds:YES];
    _regPsw.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _regPsw.leftViewMode = UITextFieldViewModeAlways;
    [_mobileBG addSubview:_regPsw];
    _regPswShaker = [[AFViewShaker alloc] initWithView:_regPsw];

    
    _regCode = [[UITextField alloc] initWithFrame:CGRectMake(_launchSquare.bounds.size.width*9/8, 40*2+8*3, _launchSquare.bounds.size.width*3/8-5, 40)];
    [_regCode setPlaceholder:Babel(@"请输入验证码")];
    [_regCode setFont:[UIFont systemFontOfSize:14.0]];
    [_regCode setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_regCode setBackgroundColor:CCamViewBackgroundColor];
    [_regCode setTextColor:CCamGrayTextColor];
    [_regCode setKeyboardType:UIKeyboardTypeNumberPad];
    [_regCode.layer setCornerRadius:8.0];
    [_regCode.layer setMasksToBounds:YES];
    _regCode.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _regCode.leftViewMode = UITextFieldViewModeAlways;
    [_mobileBG addSubview:_regCode];
    _regCodeShaker = [[AFViewShaker alloc] initWithView:_regCode];

    _regCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_regCodeBtn setTitle:Babel(@"获取验证码") forState:UIControlStateNormal];
    [_regCodeBtn setBackgroundColor:CCamYellowColor];
    [_regCodeBtn setFrame:CGRectMake(_launchSquare.bounds.size.width*12/8+5, 40*2+8*3, _launchSquare.bounds.size.width*3/8-5, 40)];
    [_regCodeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_regCodeBtn.layer setMasksToBounds:YES];
    [_regCodeBtn.layer setCornerRadius:8.0];
    [_regCodeBtn addTarget:self action:@selector(checkPhoneNumIsReged) forControlEvents:UIControlEventTouchUpInside];
    [_mobileBG addSubview:_regCodeBtn];
    
    _regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_regBtn setTitle:Babel(@"注册") forState:UIControlStateNormal];
    [_regBtn setBackgroundColor:CCamRedColor];
    [_regBtn setFrame:CGRectMake(_launchSquare.bounds.size.width*9/8, 40*3+8*4, _launchSquare.bounds.size.width*3/4, 40)];
    [_regBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [_regBtn.layer setMasksToBounds:YES];
    [_regBtn.layer setCornerRadius:8.0];
    [_mobileBG addSubview:_regBtn];
    [_regBtn addTarget:self action:@selector(verifiSMSCode) forControlEvents:UIControlEventTouchUpInside];
    
    _platformsBG = [[UIView alloc] initWithFrame:CGRectMake(0, (330-109)*1.2, 264*1.2, 109*1.2)];
    [_platformsBG setBackgroundColor:CCamRedColor];
    [_launchSquare addSubview:_platformsBG];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    [_pageControl setFrame:CGRectMake(0, (330-109)*1.2-30, 264*1.2, 30)];
    [_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    _pageControl.currentPageIndicatorTintColor = CCamPageSelectColor;
    _pageControl.pageIndicatorTintColor = CCamPageNormalColor;
    [_launchSquare addSubview:_pageControl];
    
    UILabel *paltformTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, _platformsBG.bounds.size.width, 20)];
    [paltformTitle setText:Babel(@"社交平台账户登录")];
    [paltformTitle setTextAlignment:NSTextAlignmentCenter];
    [paltformTitle setFont:[UIFont boldSystemFontOfSize:11.0]];
    [paltformTitle setTextColor:[UIColor whiteColor]];
    [paltformTitle setBackgroundColor:CCamRedColor];
    [_platformsBG addSubview:paltformTitle];
    
    _wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wechatBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [_wechatBtn setCenter:CGPointMake(_platformsBG.bounds.size.width/2-30-66, _platformsBG.bounds.size.height/2)];
    [_wechatBtn setBackgroundImage:[UIImage imageNamed:@"wechatIcon"] forState:UIControlStateNormal];
    [_wechatBtn setBackgroundColor:CCamRedColor];
    [_wechatBtn.layer setMasksToBounds:YES];
    [_wechatBtn.layer setCornerRadius:_wechatBtn.frame.size.height/2];
    [_platformsBG addSubview:_wechatBtn];
    [_wechatBtn addTarget:self action:@selector(wechatLogin) forControlEvents:UIControlEventTouchUpInside];
    _wechatShaker = [[AFViewShaker alloc] initWithView:_wechatBtn];
    
    [_wechatShaker shakeWithDuration:1.0 completion:^{
        [self performSelector:@selector(wechatIconShake) withObject:nil afterDelay:3.0];
    }];
    
    UILabel *wechatLab = [UILabel new];
    [wechatLab setFont:[UIFont systemFontOfSize:11.0]];
    [wechatLab setBackgroundColor:CCamRedColor];
    [wechatLab setTextAlignment:NSTextAlignmentCenter];
    [wechatLab setTextColor:[UIColor whiteColor]];
    [wechatLab setText:Babel(@"推荐")];
    [wechatLab sizeToFit];
    [wechatLab setFrame:CGRectMake(0, 0, wechatLab.frame.size.width+10, wechatLab.frame.size.height+2)];
    [wechatLab setCenter:CGPointMake(_wechatBtn.center.x, _wechatBtn.center.y-_wechatBtn.frame.size.height/2-12)];
    [wechatLab.layer setCornerRadius:wechatLab.frame.size.height/2];
    [wechatLab.layer setBorderColor:[UIColor whiteColor].CGColor];
    [wechatLab.layer setBorderWidth:1.0];
    [_platformsBG addSubview:wechatLab];
    
    _weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_weiboBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [_weiboBtn setCenter:CGPointMake(_platformsBG.bounds.size.width/2-10-22, _platformsBG.bounds.size.height/2)];
    [_weiboBtn setBackgroundImage:[UIImage imageNamed:@"weiboIcon"] forState:UIControlStateNormal];
    [_weiboBtn setBackgroundColor:CCamRedColor];
    [_weiboBtn.layer setMasksToBounds:YES];
    [_weiboBtn.layer setCornerRadius:_weiboBtn.frame.size.height/2];
    [_platformsBG addSubview:_weiboBtn];
    [_weiboBtn addTarget:self action:@selector(weiboLogin) forControlEvents:UIControlEventTouchUpInside];

    
    _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_qqBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [_qqBtn setCenter:CGPointMake(_platformsBG.bounds.size.width/2+10+22, _platformsBG.bounds.size.height/2)];
    [_qqBtn setBackgroundImage:[UIImage imageNamed:@"qqIcon"] forState:UIControlStateNormal];
    [_qqBtn setBackgroundColor:CCamRedColor];
    [_qqBtn.layer setMasksToBounds:YES];
    [_qqBtn.layer setCornerRadius:_qqBtn.frame.size.height/2];
    [_platformsBG addSubview:_qqBtn];
    [_qqBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];

    
    _facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_facebookBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [_facebookBtn setCenter:CGPointMake(_platformsBG.bounds.size.width/2+30+66, _platformsBG.bounds.size.height/2)];
    [_facebookBtn setBackgroundImage:[UIImage imageNamed:@"facebookIcon"] forState:UIControlStateNormal];
    [_facebookBtn setBackgroundColor:CCamRedColor];
    [_facebookBtn.layer setMasksToBounds:YES];
    [_facebookBtn.layer setCornerRadius:_facebookBtn.frame.size.height/2];
    [_platformsBG addSubview:_facebookBtn];
    [_facebookBtn addTarget:self action:@selector(facebookLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreementBtn setTitle:Babel(@"我同意《角色相机使用协议》") forState:UIControlStateNormal];
    [_agreementBtn.titleLabel setFont:[UIFont systemFontOfSize:11.]];
    [_agreementBtn sizeToFit];
    [_agreementBtn setCenter:CGPointMake(_platformsBG.bounds.size.width/2, _platformsBG.bounds.size.height-_agreementBtn.bounds.size.height/2)];
    [_agreementBtn setBackgroundColor:[UIColor clearColor]];
    [_agreementBtn addTarget:self action:@selector(hideBouncesAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [_agreementBtn setTitleColor:CCamViewBackgroundColor forState:UIControlStateNormal];
    [_platformsBG addSubview:_agreementBtn];

    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[[UIImage imageNamed:@"albumClose"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_closeBtn setTintColor:CCamRedColor];
    [_closeBtn setBackgroundColor:[UIColor whiteColor]];
    [_closeBtn setFrame:CGRectMake(5, 5, 30, 30)];
    [_closeBtn addTarget:self action:@selector(hideBouncesAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [_launchSquare addSubview:_closeBtn];
    
    [_launchSquare setFrame:CGRectMake(_launchSquare.frame.origin.x, -_launchSquare.frame.size.height, _launchSquare.frame.size.width, _launchSquare.frame.size.height)];
    
}
- (void)wechatIconShake{
    [_wechatShaker shakeWithDuration:1.0 completion:^{
        [self performSelector:@selector(wechatIconShake) withObject:nil afterDelay:3.0];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self popBouncesAnimation];
}

- (void)popBouncesAnimation{
    NSLog(@"pop animation");
    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anBasic.fromValue = @(0.0);
//    if (iOS8) {
//        anBasic.toValue =  @(1.0);
//    }else{
        anBasic.toValue = @(0.8);
//    }
    anBasic.beginTime = CACurrentMediaTime();
    anBasic.duration = 0.25f;
    [_launchPopBG pop_addAnimation:anBasic forKey:@"fade"];
    
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
    [_launchSquare pop_addAnimation:anSpring forKey:@"position"];
}
- (void)hideBouncesAnimation:(id)sender{
    NSLog(@"hide animation");
    [self.view endEditing:YES];
    if (sender) {
        UIButton *btn = (UIButton*)sender;
        if (btn == _agreementBtn) {
            _dismissType = @"agreement";
        }
    }
    
    
    POPBasicAnimation *anBasic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    
//    if (iOS8) {
//        anBasic.fromValue =  @(1.0);
//    }else{
        anBasic.fromValue = @(0.8);
//    }
    anBasic.toValue = @(0.0);
    
    anBasic.beginTime = CACurrentMediaTime();
    anBasic.duration = 0.25f;
    [_launchPopBG pop_addAnimation:anBasic forKey:@"fade"];
    
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.fromValue = @(self.view.center.y);
    anSpring.toValue = @(CCamViewHeight+CCamViewWidth);
    anSpring.beginTime = CACurrentMediaTime();
//    anSpring.springBounciness = 10.0f;
    anSpring.duration = 0.25f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [[AuthorizeHelper sharedManager] dismissAuthorizeView];
        }
    }];
    [_launchSquare pop_addAnimation:anSpring forKey:@"position"];
}
@end
