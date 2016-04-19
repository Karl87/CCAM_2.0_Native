//
//  AboutUsViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/2.
//
//

#import "AboutUsViewController.h"
#import "KLWebViewController.h"
#import "LicensesViewController.h"
#import "CCamHelper.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface AboutUsViewController ()<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) UIImageView *logo;
@property (nonatomic,strong) UIImageView *titleImage;
@property (nonatomic,strong) UILabel *version;
@property (nonatomic,strong) UILabel *copyright;

@property (nonatomic,strong) UIButton *wechatBtn;
@property (nonatomic,strong) UIButton *qqBtn;
@property (nonatomic,strong) UIButton *mailBtn;
@property (nonatomic,strong) UIButton *homepageBtn;

@property (nonatomic,strong) UIButton *agreementBtn;
@property (nonatomic,strong) UIButton *licensesBtn;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *imageBase = [[UIView alloc] init];
    [imageBase setFrame:CGRectMake(0, 0, 59+16+143, 59)];
    [imageBase setBackgroundColor:[UIColor whiteColor]];
    [imageBase setCenter:CGPointMake(CCamViewWidth/2,(CCamViewHeight-311)/2-64)];
    [self.view addSubview:imageBase];
    
    _logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 59)];
    [imageBase addSubview:_logo];
    [_logo setContentMode:UIViewContentModeScaleAspectFit];
    [_logo setImage:[[UIImage imageNamed:@"launchLogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_logo setTintColor:CCamRedColor];
    
    _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(59+16, 0, 143, 59)];
    [imageBase addSubview:_titleImage];
    [_titleImage setContentMode:UIViewContentModeScaleAspectFit];
    [_titleImage setTintColor:CCamRedColor];
    NSString*language = [[SettingHelper sharedManager] getCurrentLanguage];
    if ([language hasPrefix:@"zh-Hans"]) {
        [_titleImage setImage:[[UIImage imageNamed:@"launchNoteCn"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }else{
        [_titleImage setImage:[[UIImage imageNamed:@"launchNoteZh"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    
//    _titleImage = [UIImageView new];
//    [_titleImage setBackgroundColor:CCamRedColor];
//    [_titleImage setFrame:CGRectMake(0, 0, 298/2, 100/2)];
//    [_titleImage setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-80)];
//    [_titleImage setContentMode:UIViewContentModeScaleAspectFit];
//    [self.view addSubview:_titleImage];
//    [_titleImage setImage:[UIImage imageNamed:@"aboutTitleCn"]];
    
    _version = [UILabel new];
    [_version setBackgroundColor:[UIColor whiteColor]];
    [_version setText:[NSString stringWithFormat:@"%@ %@",Babel(@"版本"),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [_version setFrame:CGRectMake(0, imageBase.frame.origin.y+imageBase.frame.size.height+20, CCamViewWidth, 25)];
//    [_version setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-30)];
    [_version setTextColor:CCamRedColor];
    [_version setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_version setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_version];
    
    UIView *btnBase = [[UIView alloc] init];
    [btnBase setFrame:CGRectMake(imageBase.frame.origin.x, 0, 250, 100)];
    [btnBase setBackgroundColor:[UIColor whiteColor]];
    [btnBase setCenter:CGPointMake(btnBase.center.x,CCamViewHeight/2)];
    [self.view addSubview:btnBase];
    
    _wechatBtn = [UIButton new];
    [_wechatBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_wechatBtn setTitle:[NSString stringWithFormat:@"%@: 角色相机Center",Babel(@"微信")] forState:UIControlStateNormal];
    [_wechatBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_wechatBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_wechatBtn setFrame:CGRectMake(0, 0, btnBase.frame.size.width, btnBase.frame.size.height/4)];
    [_wechatBtn addTarget:self action:@selector(wechatClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBase addSubview:_wechatBtn];
    
    _homepageBtn = [UIButton new];
    [_homepageBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_homepageBtn setTitle:[NSString stringWithFormat:@"%@: http://www.i-craftsmen.com",Babel(@"官方网站")] forState:UIControlStateNormal];
    [_homepageBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_homepageBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_homepageBtn setFrame:CGRectMake(0, btnBase.frame.size.height/4, btnBase.frame.size.width, btnBase.frame.size.height/4)];
    [_homepageBtn addTarget:self action:@selector(callHomepage) forControlEvents:UIControlEventTouchUpInside];
    [btnBase addSubview:_homepageBtn];
    
    _mailBtn = [UIButton new];
    [_mailBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_mailBtn setTitle:[NSString stringWithFormat:@"%@: enquiry@i-craftsmen.com",Babel(@"商务合作")] forState:UIControlStateNormal];
    [_mailBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_mailBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_mailBtn setFrame:CGRectMake(0, btnBase.frame.size.height/4*2, btnBase.frame.size.width, btnBase.frame.size.height/4)];
    [_mailBtn addTarget:self action:@selector(mailClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBase addSubview:_mailBtn];
    
    _qqBtn = [UIButton new];
    [_qqBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_qqBtn setTitle:[NSString stringWithFormat:@"%@: 206653349",Babel(@"QQ群")] forState:UIControlStateNormal];
    [_qqBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_qqBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_qqBtn setFrame:CGRectMake(0, btnBase.frame.size.height/4*3, btnBase.frame.size.width, btnBase.frame.size.height/4)];
    [_qqBtn addTarget:self action:@selector(qqClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBase addSubview:_qqBtn];
    
//    _copyright = [UILabel new];
//    [_copyright setBackgroundColor:CCamRedColor];
//    [_copyright setText:Babel(@"版权声明")];
//    [_copyright setFrame:CGRectMake(0, _version.frame.origin.y+_version.frame.size.height, CCamViewWidth, 25)];
//    [_copyright setTextColor:[UIColor whiteColor]];
//    [_copyright setFont:[UIFont systemFontOfSize:14.0]];
//    [_copyright setTextAlignment:NSTextAlignmentCenter];
//    [self.view addSubview:_copyright];

    _agreementBtn = [UIButton new];
    [_agreementBtn setBackgroundColor:[UIColor whiteColor]];
    [_agreementBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_agreementBtn setTitle:Babel(@"查看用户协议") forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_agreementBtn sizeToFit];
    [_agreementBtn setFrame:CGRectMake(0, 0, _agreementBtn.frame.size.width+20, _agreementBtn.frame.size.height+10)];
    [_agreementBtn setCenter:CGPointMake(self.view.frame.size.width/2, CCamViewHeight-_agreementBtn.frame.size.height/2-64-20)];
    [_agreementBtn addTarget:self action:@selector(callAgreement) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreementBtn];
    
    
    UIImageView *icmLogo = [UIImageView new];
    [icmLogo setFrame:CGRectMake(0, 0, 112, 27)];
    [icmLogo setImage:[[UIImage imageNamed:@"icmLogo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [icmLogo setTintColor:CCamRedColor];
    [icmLogo setContentMode:UIViewContentModeScaleAspectFit];
    [icmLogo setCenter:CGPointMake(CCamViewWidth/2, CCamViewHeight-_agreementBtn.frame.size.height-64-30-20)];
    [self.view addSubview:icmLogo];
    
    UIBarButtonItem *contact = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"moreIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(moreClick)];
    [self.navigationItem setRightBarButtonItem:contact];
    
}
- (void)wechatClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"角色相机Center";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = Babel(@"已复制微信公众号到粘贴板");
    [hud hide:YES afterDelay:1.0];
}
- (void)mailClick{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.mailComposeDelegate = self;
        [mailPicker setToRecipients:@[@"enquiry@i-craftsmen.com"]];
        [self presentViewController:mailPicker animated:YES completion:nil];
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"enquiry@i-craftsmen.com";
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"已复制邮件到粘贴板");
        [hud hide:YES afterDelay:1.0];
    }

}
- (void)qqClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"206653349";
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = Babel(@"已复制QQ群号到粘贴板");
    [hud hide:YES afterDelay:1.0];
}
- (void)moreClick{
    
//    NSString *mail = [NSString stringWithFormat:@"Mail: enquiry@i-craftsmen.com"];
//    NSString *wechat = [NSString stringWithFormat:@"%@: 角色相机Center",Babel(@"微信")];
    NSString*licenses = @"Licenses";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:Babel(@"取消")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:licenses,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        [self callLicensespage];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error{
    
    switch (result){
            
        case MFMailComposeResultCancelled:  NSLog(@"Mail send canceled…");
            break;
        case MFMailComposeResultSaved:    NSLog(@"Mail saved…");
            break;
        case MFMailComposeResultSent:             NSLog(@"Mail sent…");
            break;
        case MFMailComposeResultFailed:  NSLog(@"Mail send errored: %@…", [error localizedDescription]);
            break;
        default:
            break;
            
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)callAgreement{
    KLWebViewController *agree = [[KLWebViewController alloc] init];
    agree.webURL = CCamAgreementURL;
    agree.vcTitle = Babel(@"角色相机用户协议");
    agree.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:agree animated:YES];

}
- (void)callHomepage{
    KLWebViewController *agree = [[KLWebViewController alloc] init];
    agree.webURL = CCamHomepageURL;
    agree.vcTitle = Babel(@"角色相机");
    agree.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:agree animated:YES];
}
- (void)callLicensespage{
    LicensesViewController *agree = [[LicensesViewController alloc] init];
    agree.vcTitle = Babel(@"Licenses");
    agree.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:agree animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
