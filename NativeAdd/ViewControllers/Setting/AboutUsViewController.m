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

@interface AboutUsViewController ()
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
    
    _logo = [UIImageView new];
    [_logo setBackgroundColor:CCamRedColor];
    [_logo setFrame:CGRectMake(0, 0, 275/4, 280/4)];
    [_logo setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-150)];
    [_logo setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_logo];
    [_logo setImage:[UIImage imageNamed:@"aboutLogo"]];
    
    _titleImage = [UIImageView new];
    [_titleImage setBackgroundColor:CCamRedColor];
    [_titleImage setFrame:CGRectMake(0, 0, 298/2, 100/2)];
    [_titleImage setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-80)];
    [_titleImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_titleImage];
    [_titleImage setImage:[UIImage imageNamed:@"aboutTitleCn"]];
    
    _version = [UILabel new];
    [_version setBackgroundColor:CCamRedColor];
    [_version setText:[NSString stringWithFormat:@"%@ %@",Babel(@"版本"),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [_version setFrame:CGRectMake(0, 0, CCamViewWidth, 44)];
    [_version setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-30)];
    [_version setTextColor:[UIColor whiteColor]];
    [_version setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_version setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_version];
    
    _copyright = [UILabel new];
    [_copyright setBackgroundColor:CCamRedColor];
    [_copyright setText:Babel(@"版权声明")];
    [_copyright setFrame:CGRectMake(0, CCamViewHeight-44-CCamNavigationBarHeight, CCamViewWidth, 44)];
    [_copyright setTextColor:[UIColor whiteColor]];
    [_copyright setFont:[UIFont systemFontOfSize:11.0]];
    [_copyright setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_copyright];
    
    _agreementBtn = [UIButton new];
    [_agreementBtn setBackgroundColor:CCamRedColor];
    [_agreementBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_agreementBtn setTitle:Babel(@"查看用户协议") forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_agreementBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_agreementBtn sizeToFit];
    [_agreementBtn setCenter:CGPointMake(self.view.frame.size.width/2, _copyright.center.y-44)];
    [_agreementBtn addTarget:self action:@selector(callAgreement) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreementBtn];
    
    _licensesBtn = [UIButton new];
    [_licensesBtn setBackgroundColor:CCamRedColor];
    [_licensesBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_licensesBtn setTitle:Babel(@"Licenses") forState:UIControlStateNormal];
    [_licensesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_licensesBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_licensesBtn sizeToFit];
    [_licensesBtn setCenter:CGPointMake(_agreementBtn.center.x+(_agreementBtn.bounds.size.width+_licensesBtn.bounds.size.width)/2+44, _agreementBtn.center.y)];
    [_licensesBtn addTarget:self action:@selector(callLicensespage) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_licensesBtn];
    
    _homepageBtn = [UIButton new];
    [_homepageBtn setBackgroundColor:CCamRedColor];
    [_homepageBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [_homepageBtn setTitle:Babel(@"官方网站") forState:UIControlStateNormal];
    [_homepageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_homepageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_homepageBtn sizeToFit];
    [_homepageBtn setCenter:CGPointMake(_agreementBtn.center.x-(_agreementBtn.bounds.size.width+_homepageBtn.bounds.size.width)/2-44, _agreementBtn.center.y)];
    [_homepageBtn addTarget:self action:@selector(callHomepage) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_homepageBtn];
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
