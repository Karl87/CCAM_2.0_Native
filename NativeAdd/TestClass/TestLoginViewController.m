//
//  TestLoginViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/10.
//
//

#import "TestLoginViewController.h"
#import "KLTextField.h"

@interface TestLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) KLTextField * account;
@property (nonatomic,strong) KLTextField * password;
@end

@implementation TestLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)shakeObject{
    [_account.viewShaker shake];
    [_password.viewShaker shake];
}
- (void)setPasswordApprence:(id)sender{
    UISwitch *swi = (UISwitch*)sender;
    [_password setSecureTextEntry:swi.on];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwitch *showPassword = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    showPassword.on = YES;
    [showPassword setTintColor:CCamGoldColor];
    [showPassword setOnTintColor:CCamGoldColor];
    
    [showPassword addTarget:self action:@selector(setPasswordApprence:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:showPassword];
    
    UIBarButtonItem *shake = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(shakeObject)];
    [self.navigationItem setRightBarButtonItem:shake];
    
    _account = [[KLTextField alloc] initWithFrame:CGRectMake(20, CCamNavigationBarHeight+20, self.view.frame.size.width-40, 44)];
    [self.view addSubview:_account];
    [_account setTextColor:[UIColor whiteColor]];
    [_account setTintColor:[UIColor whiteColor]];
    [_account.separator setBackgroundColor:CCamGrayTextColor];
    [_account setDelegate:self];
    _account.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"用户名" attributes:@{NSForegroundColorAttributeName: CCamGrayTextColor}];
    [_account.rule setText:@"4-10 Characters"];
    [_account setKeyboardType:UIKeyboardTypePhonePad];
    [_account setClearButtonMode:UITextFieldViewModeAlways];
    [_account addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _password = [[KLTextField alloc] initWithFrame:CGRectMake(20, CCamNavigationBarHeight+20+64, self.view.frame.size.width-40, 44)];
    [self.view addSubview:_password];
    [_password setTextColor:[UIColor whiteColor]];
    [_password setTintColor:[UIColor whiteColor]];
    [_password.separator setBackgroundColor:CCamGrayTextColor];
    [_password setDelegate:self];
    _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码" attributes:@{NSForegroundColorAttributeName: CCamGrayTextColor}];
    [_password.rule setText:@"4-10 Characters"];
    [_password setKeyboardType:UIKeyboardTypeDefault];
    [_password setSecureTextEntry:YES];
    [_password addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"!!!");
    if (textField == _account) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }else if (textField == _password){
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
            [_password setTextColor:[UIColor redColor]];
            [_password.viewShaker shake];
        }else{
            [_password setTextColor:[UIColor whiteColor]];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
