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

@property (nonatomic,strong) UIButton *agreementBtn;
@property (nonatomic,strong) UIButton *licensesBtn;
@property (nonatomic,strong) UIButton *homepageBtn;
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:CCamRedColor];
    
    _logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 311, 311)];
    [_logo setCenter:CGPointMake(CCamViewWidth/2,CCamViewHeight-150-64)];
    [self.view addSubview:_logo];
    [_logo setContentMode:UIViewContentModeScaleAspectFit];
    [_logo setImage:[UIImage imageNamed:@"launchLogo"]];
    [_logo setTintColor:CCamRedColor];
    
    _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 143, 59)];
    [_titleImage setCenter:CGPointMake(CCamViewWidth/2, (CCamViewHeight-311)/2-64)];
    [self.view addSubview:_titleImage];
    [_titleImage setContentMode:UIViewContentModeScaleAspectFit];
    
    NSString*language = [[SettingHelper sharedManager] getCurrentLanguage];
    if ([language hasPrefix:@"zh-Hans"]) {
        [_titleImage setImage:[UIImage imageNamed:@"launchNoteCn"]];
    }else{
        [_titleImage setImage:[UIImage imageNamed:@"launchNoteZh"]];
    }
    
//    _titleImage = [UIImageView new];
//    [_titleImage setBackgroundColor:CCamRedColor];
//    [_titleImage setFrame:CGRectMake(0, 0, 298/2, 100/2)];
//    [_titleImage setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-80)];
//    [_titleImage setContentMode:UIViewContentModeScaleAspectFit];
//    [self.view addSubview:_titleImage];
//    [_titleImage setImage:[UIImage imageNamed:@"aboutTitleCn"]];
    
    _version = [UILabel new];
    [_version setBackgroundColor:CCamRedColor];
    [_version setText:[NSString stringWithFormat:@"%@ %@",Babel(@"版本"),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [_version setFrame:CGRectMake(0, _titleImage.frame.origin.y+_titleImage.frame.size.height+20, CCamViewWidth, 25)];
//    [_version setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-30)];
    [_version setTextColor:[UIColor whiteColor]];
    [_version setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_version setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_version];
    
    _copyright = [UILabel new];
    [_copyright setBackgroundColor:CCamRedColor];
    [_copyright setText:Babel(@"版权声明")];
    [_copyright setFrame:CGRectMake(0, _version.frame.origin.y+_version.frame.size.height, CCamViewWidth, 25)];
    [_copyright setTextColor:[UIColor whiteColor]];
    [_copyright setFont:[UIFont systemFontOfSize:14.0]];
    [_copyright setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_copyright];

    _agreementBtn = [UIButton new];
    [_agreementBtn setBackgroundColor:CCamRedColor];
    [_agreementBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_agreementBtn setTitle:Babel(@"查看用户协议") forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_agreementBtn sizeToFit];
    [_agreementBtn setFrame:CGRectMake(0, 0, _agreementBtn.frame.size.width+20, _agreementBtn.frame.size.height+10)];
    [_agreementBtn setCenter:CGPointMake(self.view.frame.size.width/2, _copyright.center.y+66)];
    [_agreementBtn addTarget:self action:@selector(callAgreement) forControlEvents:UIControlEventTouchUpInside];
    [_agreementBtn.layer setCornerRadius:_agreementBtn.frame.size.height/2];
    [_agreementBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_agreementBtn.layer setBorderWidth:1.0];
    [self.view addSubview:_agreementBtn];
    
    _licensesBtn = [UIButton new];
    [_licensesBtn setBackgroundColor:CCamRedColor];
    [_licensesBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_licensesBtn setTitle:Babel(@"Licenses") forState:UIControlStateNormal];
    [_licensesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_licensesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_licensesBtn sizeToFit];
     [_licensesBtn setFrame:CGRectMake(0, 0, _licensesBtn.frame.size.width+20, _licensesBtn.frame.size.height+10)];
    [_licensesBtn setCenter:CGPointMake(_agreementBtn.center.x+(_agreementBtn.bounds.size.width+_licensesBtn.bounds.size.width)/2+24, _agreementBtn.center.y)];
    [_licensesBtn addTarget:self action:@selector(callLicensespage) forControlEvents:UIControlEventTouchUpInside];
    [_licensesBtn.layer setCornerRadius:_licensesBtn.frame.size.height/2];
    [_licensesBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_licensesBtn.layer setBorderWidth:1.0];
    [self.view addSubview:_licensesBtn];
    
    _homepageBtn = [UIButton new];
    [_homepageBtn setBackgroundColor:CCamRedColor];
    [_homepageBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_homepageBtn setTitle:Babel(@"官方网站") forState:UIControlStateNormal];
    [_homepageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_homepageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_homepageBtn sizeToFit];
    [_homepageBtn setFrame:CGRectMake(0, 0, _homepageBtn.frame.size.width+20, _homepageBtn.frame.size.height+10)];
    [_homepageBtn setCenter:CGPointMake(_agreementBtn.center.x-(_agreementBtn.bounds.size.width+_homepageBtn.bounds.size.width)/2-24, _agreementBtn.center.y)];
    [_homepageBtn addTarget:self action:@selector(callHomepage) forControlEvents:UIControlEventTouchUpInside];
    [_homepageBtn.layer setCornerRadius:_homepageBtn.frame.size.height/2];
    [_homepageBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_homepageBtn.layer setBorderWidth:1.0];
    [self.view addSubview:_homepageBtn];
    
    UIBarButtonItem *contact = [[UIBarButtonItem alloc] initWithTitle:Babel(@"联系我们") style:UIBarButtonItemStylePlain target:self action:@selector(cantactus)];
    [self.navigationItem setRightBarButtonItem:contact];
    
}
- (void)cantactus{
    
    NSString *mail = [NSString stringWithFormat:@"Mail: enquiry@i-craftsmen.com"];
    NSString *wechat = [NSString stringWithFormat:@"%@: 角色相机Center",Babel(@"微信")];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Babel(@"联系我们")
                                  delegate:self
                                  cancelButtonTitle:Babel(@"取消")
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:mail,wechat,nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
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
    }else if (buttonIndex ==1){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"角色相机Center";
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"已复制微信公众号到粘贴板");
        [hud hide:YES afterDelay:1.0];
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
