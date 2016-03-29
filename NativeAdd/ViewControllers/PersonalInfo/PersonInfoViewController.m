//
//  PersonInfoViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/24.
//
//

#import "PersonInfoViewController.h"

#import "CCUserViewController.h"
#import "PersonImageCell.h"
#import "PersonBasicInfoCell.h"

#import "EditInfoViewController.h"

#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface PersonInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UITableView *infoTable;
@property (nonatomic,strong) NSDictionary *userInfo;
@end

@implementation PersonInfoViewController

- (void)getPersonalInfo{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setLabelText:Babel(@"加载中")];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userToken = [[AuthorizeHelper sharedManager] getUserToken];
    NSDictionary *parameters = @{@"token":userToken};
    [manager POST:CCamGetUserInfoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        _userInfo = dic;
//        PersonInfo *userImage = [_userInfo objectAtIndex:0];
//        userImage.info = [dic objectForKey:@"image_url"];
        [_infoTable setDelegate:self];
        [_infoTable setDataSource:self];
        [_infoTable reloadData];
        
        [hud hide:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = Babel(@"网络故障");
        [hud hide:YES afterDelay:1.0];
    }];
}
- (void)returnWhenPresentSelf{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController.viewControllers count]==1) {
        UIBarButtonItem * dismissBtn = [[UIBarButtonItem alloc] initWithTitle:Babel(@"完成") style:UIBarButtonItemStylePlain target:self action:@selector(returnWhenPresentSelf)];
        self.navigationItem.rightBarButtonItem = dismissBtn;
        
    }
    
    _infoTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_infoTable registerClass:[PersonImageCell class] forCellReuseIdentifier:@"imageCell"];
    [_infoTable registerClass:[PersonBasicInfoCell class] forCellReuseIdentifier:@"infoCell"];
    [_infoTable registerClass:[PersonBasicInfoCell class] forCellReuseIdentifier:@"bandCell"];

    [_infoTable setBackgroundColor:[UIColor clearColor]];
    [_infoTable setSeparatorColor:CCamViewBackgroundColor];
    [self.view addSubview:_infoTable];
    if (self.hidesBottomBarWhenPushed) {
        [_infoTable setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
        [_infoTable setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 64, 0)];
    }else{
        [_infoTable setContentInset:UIEdgeInsetsMake(0, 0, 64+49, 0)];
        [_infoTable setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 64+49, 0)];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];[self getPersonalInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 5;
        case 1:
            return 5;
        default:
            return 0;
    }
    
//    switch (section) {
//        case 0:
//            return 5;
//        case 1:
//            return 3;
//        case 2:
//            return 5;
//        default:
//            return 0;
//    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            PersonImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            cell.info = _userInfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            PersonBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
            switch (indexPath.row) {
                case 1:
                    cell.type = @"nickName";
                    break;
                case 2:
                    cell.type = @"gender";
                    break;
                case 3:
                    cell.type = @"birth";
                    break;
                case 4:
                    cell.type = @"des";
                    break;
                default:
                    break;
            }
            cell.info = _userInfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }else if (indexPath.section ==1){
//        PersonBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
//        switch (indexPath.row) {
//            case 0:
//                cell.type = @"trueName";
//                break;
//            case 1:
//                cell.type = @"trueMobile";
//                break;
//            case 2:
//                cell.type = @"trueAddress";
//                break;
//                        default:
//                break;
//        }
//        cell.info = _userInfo;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        return cell;

        PersonBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bandCell"];
        switch (indexPath.row) {
            case 0:
                cell.type = @"bandMobile";
                break;
            case 1:
                cell.type = @"bandWechat";
                break;
            case 2:
                cell.type = @"bandWeibo";
                break;
            case 3:
                cell.type = @"bandQQ";
                break;
            case 4:
                cell.type = @"bandFacebook";
                break;
            default:
                break;
        }
        cell.info = _userInfo;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    }
//    else if (indexPath.section ==2){
//        PersonBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bandCell"];
//        switch (indexPath.row) {
//            case 0:
//                cell.type = @"bandMobile";
//                break;
//            case 1:
//                cell.type = @"bandWechat";
//                break;
//            case 2:
//                cell.type = @"bandWeibo";
//                break;
//            case 3:
//                cell.type = @"bandQQ";
//                break;
//            case 4:
//                cell.type = @"bandFacebook";
//                break;
//            default:
//                break;
//        }
//        cell.info = _userInfo;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//        return cell;
//
//    }
    
    static NSString *identifier = @"timelineCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_parent && [_parent isKindOfClass:[CCUserViewController class]]) {
        CCUserViewController *user = (CCUserViewController*)_parent;
        user.needUpdate = YES;
    }
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"编辑照片" delegate:self cancelButtonTitle:Babel(@"取消") destructiveButtonTitle:nil otherButtonTitles:Babel(@"从相册选择"),Babel(@"拍照"), nil];
            [actionsheet showInView:self.view];

        }else{
            PersonBasicInfoCell *cell = (PersonBasicInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
            EditInfoViewController *edit = [[EditInfoViewController alloc] init];
            edit.note = cell.note;
            switch (indexPath.row) {
                case 1:
                    edit.type = @"nickName";
                    edit.vcTitle = Babel(@"编辑昵称");
                    break;
                case 2:
                    edit.vcTitle = @"编辑性别";
                    edit.type = Babel(@"编辑性别");
                    break;
                case 3:
                    edit.vcTitle = Babel(@"编辑生日");
                    edit.type = @"birth";
                    break;
                case 4:
                    edit.vcTitle = Babel(@"编辑简介");
                    edit.type = @"des";
                    break;
                default:
                    break;
            }
            UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
            backItem.title=@"";
            self.navigationItem.backBarButtonItem=backItem;
            [self.navigationController pushViewController:edit animated:YES];
        }
    }else if (indexPath.section ==1){
         PersonBasicInfoCell *cell = (PersonBasicInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.type isEqualToString:@"bandMobile"]) {
            
            
        }else if ([cell.type isEqualToString:@"bandWechat"]) {
            if ([[cell.info objectForKey:@"wechat_name"] isEqualToString:@""]) {
                [[AuthorizeHelper sharedManager] getSocialPlatformInfoWithTypeID:@"2" shareType:UMShareToWechatSession isLogin:NO];

            }else{
                [[AuthorizeHelper sharedManager] unbindPlatformWithTypeID:@"2"];
            }

        }else if ([cell.type isEqualToString:@"bandWeibo"]) {
            if ([[cell.info objectForKey:@"weibo_name"] isEqualToString:@""]) {
                [[AuthorizeHelper sharedManager] getSocialPlatformInfoWithTypeID:@"3" shareType:UMShareToSina isLogin:NO];

            }else{
                [[AuthorizeHelper sharedManager] unbindPlatformWithTypeID:@"3"];
            }

        }else if ([cell.type isEqualToString:@"bandQQ"]) {
            if ([[cell.info objectForKey:@"QQ_name"] isEqualToString:@""]) {
                [[AuthorizeHelper sharedManager] getSocialPlatformInfoWithTypeID:@"4" shareType:UMShareToQQ isLogin:NO];

            }else{
                [[AuthorizeHelper sharedManager] unbindPlatformWithTypeID:@"4"];
            }

        }else if ([cell.type isEqualToString:@"bandFacebook"]) {
            if ([[cell.info objectForKey:@"facebook_name"] isEqualToString:@""]) {
                [[AuthorizeHelper sharedManager] getSocialPlatformInfoWithTypeID:@"5" shareType:UMShareToFacebook isLogin:NO];

            }else{
                [[AuthorizeHelper sharedManager] unbindPlatformWithTypeID:@"5"];
            }

        }
    }
//    else if (indexPath.section ==1){
//        PersonBasicInfoCell *cell = (PersonBasicInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
//        EditInfoViewController *edit = [[EditInfoViewController alloc] init];
//        edit.note = cell.note;
//        switch (indexPath.row) {
//            case 0:
//                edit.vcTitle = @"编辑收奖人姓名";
//                edit.type = @"trueName";
//                break;
//            case 1:
//                edit.vcTitle = @"编辑收奖手机号码";
//                edit.type = @"trueMobile";
//                break;
//            case 2:
//                edit.vcTitle = @"编辑收奖地址";
//                edit.type = @"trueAddress";
//                break;
//            default:
//                break;
//        }
//        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
//        backItem.title=@"";
//        self.navigationItem.backBarButtonItem=backItem;
//        [self.navigationController pushViewController:edit animated:YES];
//        
//    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            id info = _userInfo;
            return [_infoTable cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[PersonImageCell class] contentViewWidth:CCamViewWidth] ;
        }else{
            id info = _userInfo;
            return [_infoTable cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[PersonBasicInfoCell class] contentViewWidth:CCamViewWidth] ;
        }
    }else if (indexPath.section ==1){
        id info = _userInfo;
        return [_infoTable cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[PersonBasicInfoCell class] contentViewWidth:CCamViewWidth] ;
    }else if (indexPath.section ==2){
        id info = _userInfo;
        return [_infoTable cellHeightForIndexPath:indexPath model:info keyPath:@"info" cellClass:[PersonBasicInfoCell class] contentViewWidth:CCamViewWidth] ;
    }
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *identifier = @"infoHeader";
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    [view setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    
    UILabel *groupTitle = [UILabel new];
    [groupTitle setBackgroundColor:[UIColor clearColor]];
    [groupTitle setFrame:CGRectMake(10, 0, view.bounds.size.width, 30)];
    [groupTitle setTextAlignment:NSTextAlignmentLeft];
    
    switch (section) {
        case 0:
            [groupTitle setText:Babel(@"基础信息")];
            break;
        case 1:
            [groupTitle setText:Babel(@"账号关联信息")];
//            [groupTitle setText:@"奖品发放信息"];
            break;
        case 2:
            [groupTitle setText:@"账号关联信息"];
            break;
        default:
            break;
    }
    
    [groupTitle setTextColor:[UIColor darkGrayColor]];
    [groupTitle setFont:[UIFont systemFontOfSize:14.0]];
    [view addSubview:groupTitle];
    
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = CCamViewBackgroundColor;
}
#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.allowsEditing = YES;
            // 设置导航默认标题的颜色及字体大小
            picker.navigationBar.tintColor = [UIColor blackColor];
            picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
            [self presentViewController:picker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
 
    }else if (buttonIndex == 1){
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            // 设置导航默认标题的颜色及字体大小
            picker.navigationBar.tintColor = [UIColor blackColor];
            picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
            [self presentViewController:picker animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }];
        }
    }
}
#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];}];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSLog(@"%@",info);
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    //压缩用户上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.4);
    
    NSDictionary *parameters = @{@"token":[[AuthorizeHelper sharedManager] getUserToken]};
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:CCamUploadProfileImageURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"profile.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = Babel(@"发布照片中");
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          NSLog(@"%f",uploadProgress.fractionCompleted);
                          //                          [_submitHud setProgress:(CGFloat)uploadProgress.fractionCompleted animated:YES];
                          hud.progress = (float)uploadProgress.fractionCompleted;
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                          hud.mode = MBProgressHUDModeText;
                          hud.labelText = Babel(@"发布照片成功");
                          [hud hide:YES afterDelay:2.0];
                          
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                          hud.mode = MBProgressHUDModeText;
                          hud.labelText = Babel(@"发布照片失败");
                          [hud hide:YES afterDelay:1.0];
                          [self performSelector:@selector(getPersonalInfo) withObject:nil afterDelay:1.0];
                      }
                  }];
    
    [uploadTask resume];
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}
@end
