//
//  EditInfoViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/24.
//
//

#import "EditInfoViewController.h"
#import "InfoInputCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface EditInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate>

@property (nonatomic,strong) UIPickerView *genderPicker;
@property (nonatomic,strong) UIToolbar *genderToolBar;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIToolbar *dateToolBar;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) NSString *userGender;
@property (nonatomic,strong) UITableView *inputTable;
@property (nonatomic,strong) NSMutableArray *inputData;
@end

@implementation EditInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (NSString*)returnNumFormGender:(NSString*)gender{
    if ([gender isEqualToString:@"男"]) {
        return @"1";
    }else if ([gender isEqualToString:@"女"]){
        return @"2";
    }else if ([gender isEqualToString:@"保密"]){
        return @"3";
    }
    return @"";
}
- (void)updateUserInfo{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"更新信息中...";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager]getUserToken];
    NSDictionary *parameters;
    if ([self.type isEqualToString:@"nickName"]) {
        parameters = @{@"token":userToken,@"name":self.textField.text};
    }else if ([self.type isEqualToString:@"gender"]) {
        NSString *genderNum = [self returnNumFormGender:self.userGender];
        parameters = @{@"token":userToken,@"sex":genderNum};
    }else if ([self.type isEqualToString:@"birth"]) {
        parameters = @{@"token":userToken,@"birthday":self.textField.text};
    }else if ([self.type isEqualToString:@"address"]) {
        parameters = @{@"token":userToken,@"address":self.textField.text};
    }else if ([self.type isEqualToString:@"trueName"]) {
        parameters = @{@"token":userToken,@"consignee_name":self.textField.text};
    }else if ([self.type isEqualToString:@"trueMobile"]) {
        parameters = @{@"token":userToken,@"consignee_phone":self.textField.text};
    }else if ([self.type isEqualToString:@"trueAddress"]) {
        parameters = @{@"token":userToken,@"consignee_local":self.textField.text};
    }
    [manager POST:CCamEditUserInfoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        hud.labelText = @"更新成功";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.0];
        [self performSelector:@selector(returnToPersonInfo) withObject:nil afterDelay:1.1];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.labelText = @"网络故障";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.0];
    }];
}
- (void)returnToPersonInfo{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(updateUserInfo)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    _inputTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [_inputTable setDelegate:self];
    [_inputTable setDataSource:self];
    [_inputTable setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    [_inputTable registerClass:[InfoInputCell class] forCellReuseIdentifier:@"inputCell"];
    [self.view addSubview:_inputTable];
    
    //
    self.datePicker = [[UIDatePicker alloc]init];
    NSLocale*datelocale = [NSLocale currentLocale];
    self.datePicker.locale = datelocale;
    self.datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.dateToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, CCamViewWidth, 44)];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker)];
    self.dateToolBar.items = [NSArray arrayWithObject:right];
    
    //
//    self.genderPicker  = [[UIPickerView alloc] init];
//    self.genderPicker.delegate = self;
//    self.genderToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    
//    UIBarButtonItem *genderRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelGenderPicker)];
//    self.genderToolBar.items = [NSArray arrayWithObject:genderRight];
    
//    [self initInputData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_type isEqualToString:@"gender"]) {
        return 3;
    }

    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inputCell"];
    if (![self.type isEqualToString:@"gender"]) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        UITextField *textfield = [UITextField new];
        textfield.delegate = self;
        textfield.text = self.note;
        textfield.placeholder = @"";
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.textAlignment = NSTextAlignmentLeft;
        
        textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textfield.frame = CGRectMake(15, 0, CCamViewWidth-30,45);
        textfield.clearButtonMode = UITextFieldViewModeAlways;
        textfield.adjustsFontSizeToFitWidth = YES;
        textfield.keyboardType = UIKeyboardTypeDefault;
        textfield.returnKeyType = UIReturnKeyDone;
        [cell addSubview:textfield];
        
        if([self.type isEqualToString:@"birth"]){
            textfield.inputView = self.datePicker;
            textfield.inputAccessoryView = self.dateToolBar;
        }else if ([self.type isEqualToString:@"mobile"]){
            textfield.keyboardType = UIKeyboardTypePhonePad;
        }
        
        self.textField = textfield;
        [self.textField becomeFirstResponder];
    }else{
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"男";
                break;
            case 1:
                cell.textLabel.text = @"女";
                break;
            case 2:
                cell.textLabel.text = @"保密";
                break;
            default:
                break;
        }
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.textLabel.textColor = CCamGrayTextColor;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = CCamRedColor;
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5.0f;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0 && indexPath.row ==0) {
        
    }
    
    //    [self.view endEditing:YES];
    if (![self.type isEqualToString:@"gender"]) {
        [self.inputTable deselectRowAtIndexPath:indexPath animated:NO];
    }else{
        if (indexPath.row ==0) {
            self.userGender = @"男";
        }else if (indexPath.row ==1){
            self.userGender = @"女";
        }else if (indexPath.row==2){
            self.userGender = @"保密";
        }
        [self updateUserInfo];
    }
}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    
    return YES;
}
#pragma mark - DataPicker 代理方法

- (void)chooseDate:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    self.textField.text = dateString;
}
-(void) cancelPicker {
    if ([self.view endEditing:NO]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale* datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:datelocale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:datelocale];
        self.textField.text = [[NSString stringWithFormat:@"%@",[formatter stringFromDate:self.datePicker.date]] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    }
}
-(void)dateChanged:(UIDatePicker*)sender{
    NSDate *selectedDate = sender.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:selectedDate];
    self.textField.text = dateString;
}
@end
