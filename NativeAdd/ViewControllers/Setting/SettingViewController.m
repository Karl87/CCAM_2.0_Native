//
//  SettingViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/24.
//
//

#import "SettingViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "KLWebViewController.h"
#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
#import "CCUserViewController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *setting;
@property (nonatomic,strong) NSArray *settings_normal;
@property (nonatomic,strong) NSArray *settings_login;
@property (nonatomic,strong) NSArray *settings_action;
@property (nonatomic,strong) UIAlertView *updateAlert;
@property (nonatomic,strong) UIAlertView *testUpdateAlert;
@property (nonatomic,copy) NSString *updateURL;
@property (nonatomic,copy) NSString *testUpdateURL;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _settings_action = @[Babel(@"清理缓存"),Babel(@"检查更新"),Babel(@"给个好评"),Babel(@"意见反馈")];
    _settings_normal = @[Babel(@"关于角色相机")];
    _settings_login = @[Babel(@"登出")];
    _setting = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_setting];
    [_setting setBackgroundColor:CCamViewBackgroundColor];
    [_setting setSeparatorColor:CCamViewBackgroundColor];
    [_setting setDelegate:self];
    [_setting setDataSource:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return _settings_action.count;
            break;
        case 1:
            return _settings_normal.count;
            break;
        case 2:
            return _settings_login.count;
            break;
        default:
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([[AuthorizeHelper sharedManager] checkToken]) {
        return 3;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell;
    
    if (indexPath.section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.contentView setBackgroundColor:CCamRedColor];
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    }
    

    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [_settings_action objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [_settings_normal objectAtIndex:indexPath.row];
            break;
        case 2:
            cell.textLabel.text = [_settings_login objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section ==0 ) {
        if (indexPath.row == 0) {
            //显示缓存大小
            cell.detailTextLabel.text =[self folderSizeAtPath:NSTemporaryDirectory()];
        }else if (indexPath.row ==1){
            //显示系统版本
            cell.detailTextLabel.text =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        }
    }
    
    [cell layoutSubviews];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    //clear temp
                    [self clearCache:NSTemporaryDirectory()];
                    break;
                case 1:
                    //check update
                    [self checkAppUpdateWithAppID:CCamAppStoreID];
                    break;
                case 2:
                    //evaluate app
                    [self evaluateApp];
                    break;
                case 3:
                    [self callFeedbackPage];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    //aboutus
                    [self callAboutusPage];
                    break;
                default:
                    break;
            }

            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    //logout
                    [self logout];
                    break;
                default:
                    break;
            }

            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}
- (void)logout{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Babel(@"登出角色相机中");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:CCamLogoutURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSString *hubMessage = @"";
        
        if ([jsonStr isEqualToString:@"1"]) {
            hubMessage = Babel(@"登出成功");
            [[AuthorizeHelper sharedManager] setUserToken:@""];
            [[AuthorizeHelper sharedManager] setUserID:@""];
            
            if (_parent&&[_parent isKindOfClass:[CCUserViewController class]]) {
                CCUserViewController *user = (CCUserViewController*)_parent;
                user.needUpdate = YES;
            }
            
        }else{
            hubMessage = Babel(@"登出失败");
        }
        
        hud.labelText = hubMessage;
        [hud hide:YES afterDelay:1.0f];
        [_setting reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:Babel(@"网络故障")];
        [hud hide:YES afterDelay:1.0f];
    }];
}
-(NSString*)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        folderSize+=[[SDImageCache sharedImageCache] getSize];
        if (folderSize/1024.0<1024.0) {
            NSString *size =[NSString stringWithFormat:@"%.2fKB",folderSize/1024.0];
            if ([size isEqualToString:@"0.00KB"]) {
                size = Babel(@"暂无缓存");
            }
            return size;
        }else if (folderSize/1024.0/1024.0<1024.0){
            return [NSString stringWithFormat:@"%.2fMB",folderSize/1024.0/1024.0];
        }else if (folderSize/1024.0/1024.0/1024.0<1024.0){
            return [NSString stringWithFormat:@"%.2fGB",folderSize/1024.0/1024.0/1024.0];
        }else if (folderSize/1024.0/1024.0/1024.0/1024.0<1024.0){
            return [NSString stringWithFormat:@"%.2fTB",folderSize/1024.0/1024.0/1024.0/1024.0];
        }
    }
    return Babel(@"暂无缓存");
}
-(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}
-(void)clearCache:(NSString *)path{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Babel(@"清理缓存文件中");
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        hud.labelText =Babel(@"缓存我呢见清理完成");
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.0];
        [_setting reloadData];
    }];
    
}
- (void)checkAppUpdateWithAppID:(NSString*)appid{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = Babel(@"检查更新中");
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * currentVersion =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    
    [manager GET:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appid] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", jsonStr);
        NSError *error = nil;
        NSDictionary *updateDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            if (updateDic != nil) {
                NSInteger resultCount = [[updateDic objectForKey:@"resultCount"] integerValue];
                if (resultCount ==1) {
                    NSArray *resultArray = [updateDic objectForKey:@"results"];
                    NSDictionary *resultDic = [resultArray objectAtIndex:0];
                    NSString *lastVersion = [resultDic objectForKey:@"version"];
                    if ([lastVersion doubleValue]>[currentVersion doubleValue]) {
                        NSString *message = [NSString stringWithFormat:@"%@%@,%@？",Babel(@"最新版本为"),lastVersion,Babel(@"是否前往更新")];
                        _updateURL = [[resultDic objectForKey:@"trackViewUrl"] copy];
                        [hud hide:YES];
                        _updateAlert = [[UIAlertView alloc] initWithTitle:Babel(@"提示") message:message delegate:self cancelButtonTitle:Babel(@"暂时不要") otherButtonTitles:Babel(@"前往更新"), nil];
                        [_updateAlert show];
                    }else if ([lastVersion doubleValue]<[currentVersion doubleValue]) {
                        NSString *message = [NSString stringWithFormat:@"您使用的是测试版本,无法检查更新\n是否前往最新测试本下载页面？"];
                        _testUpdateURL = @"http://fir.im/ccam2/";
                        [hud hide:YES];
                        _testUpdateAlert = [[UIAlertView alloc] initWithTitle:Babel(@"提示") message:message delegate:self cancelButtonTitle:Babel(@"暂时不要") otherButtonTitles:Babel(@"前往更新"), nil];
                        [_testUpdateAlert show];
                    }else{
                        hud.mode = MBProgressHUDModeText;
                        [hud setLabelText:Babel(@"您使用的已经是最新版本")];
                        [hud hide:YES afterDelay:2.0f];
                    }
                }
            }
        }else{
            [hud setLabelText:Babel(@"检查更新失败")];
            [hud hide:YES afterDelay:1.0f];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud setLabelText:Babel(@"网络故障")];
        [hud hide:YES afterDelay:1.0f];
    }];

}
- (void)evaluateApp{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",CCamAppStoreID]]];
}
#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _updateAlert) {
        if (buttonIndex ==1) {
            if (_updateURL) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
            }
        }
    }else if (alertView == _testUpdateAlert){
        if (buttonIndex==1) {
            if (_testUpdateURL) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_testUpdateURL]];
            }
        }
    }
}
#pragma mark - Aboutus page
- (void)callAboutusPage{
    AboutUsViewController *about = [[AboutUsViewController alloc] init];
    about.vcTitle = Babel(@"关于角色相机");
    about.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:about animated:YES];
}
#pragma mark - Feedback page
- (void)callFeedbackPage{
    FeedbackViewController *about = [[FeedbackViewController alloc] init];
    about.vcTitle = Babel(@"意见反馈");
    about.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:about animated:YES];
}
@end
