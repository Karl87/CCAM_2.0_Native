//
//  CCamSubmitViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/4.
//
//


#define MAX_LIMIT_NUMS     140
#import "CCamScrollView.h"
#import "CCamSubmitContestCell.h"
#import "CCamSubmitViewController.h"
#import "AFHTTPSessionManager.h"
#import <pop/POP.h>
#import "AFViewShaker.h"
#import "CCamHelper.h"

#import "KLWebViewController.h"
#import "KLNavigationController.h"

#import <MBProgressHUD/MBProgressHUD.h>

@interface CCamSubmitViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) CCamScrollView *submitBG;
@property (nonatomic,strong) UIView *navi;

@property (nonatomic,strong) UILabel *navigationTitle;

@property (nonatomic,strong) NSMutableArray *contests;
@property (nonatomic,strong) UIView *loadBG;
@property (nonatomic,strong) UIActivityIndicatorView * loadContests;
@property (nonatomic,strong) UIButton *loadButton;

@property (nonatomic,strong) UITableView *contestTable;
@property (nonatomic,strong) UIImageView *submitImage;
@property (nonatomic,strong) UITextView *placeholderText;
@property (nonatomic,strong) UITextView *submitText;
@property (nonatomic,strong) UIButton *personalButton;
@property (nonatomic,strong) UIButton *submitButton;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UILabel *textNumLabel;
@property (nonatomic,strong) AFViewShaker *viewShaker;

@property (nonatomic,strong) NSString *currentContestID;
@property (nonatomic,strong) UIAlertView *submitAlert;
@end

@implementation CCamSubmitViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UnitySendMessage(UnityController.UTF8String, "GetCurrentCharactersSerieID", "");
    UnitySendMessage(UnityController.UTF8String, "GetAllCharacterList", "");
    
    _currentContestID = @"";
    _contests = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _submitBG = [[CCamScrollView alloc] initWithFrame:self.view.frame];
    [_submitBG setBackgroundColor:[UIColor whiteColor]];
    [_submitBG setBounces:NO];
    [_submitBG setContentSize:CGSizeMake(CCamViewWidth, CCamViewHeight)];
    [self.view addSubview:_submitBG];
    
    _navi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamThinNaviHeight)];
    [_navi setBackgroundColor:CCamSegmentColor];
    [self.view addSubview:_navi];
    
    _navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _navi.frame.size.width, CCamThinNaviHeight)];
    [_navi addSubview:_navigationTitle];
    [_navigationTitle setBackgroundColor:CCamSegmentColor];
    [_navigationTitle setText:Babel(@"发布照片")];
    [_navigationTitle setTextAlignment:NSTextAlignmentCenter];
    [_navigationTitle setTextColor:[UIColor whiteColor]];
    [_navigationTitle setFont:[UIFont boldSystemFontOfSize:17.0]];
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setShowsTouchWhenHighlighted:YES];
    [_backButton setImage:[[UIImage imageNamed:@"backButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_backButton sizeToFit];
    [_backButton setFrame:CGRectMake(0, 0, _backButton.frame.size.width+30, _navi.frame.size.height)];
    [_backButton setCenter:CGPointMake(_backButton.frame.size.width/2, _navi.frame.size.height/2)];
    [_backButton setTintColor:[UIColor whiteColor]];
    [_backButton addTarget:self action:@selector(backToController) forControlEvents:UIControlEventTouchUpInside];
    [_navi addSubview:_backButton];
    
    
    
    _loadBG  = [[UIView alloc] initWithFrame:CGRectMake(0, CCamThinNaviHeight+5, CCamViewWidth, 44)];
    [_loadBG setBackgroundColor:CCamBackgoundGrayColor];
    [_submitBG addSubview:_loadBG];
    
    _loadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loadButton setBackgroundColor:CCamBackgoundGrayColor];
    [_loadButton setTitle:Babel(@"加载活动列表") forState:UIControlStateNormal];
    [_loadButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
    [_loadButton setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_loadButton addTarget:self action:@selector(requestContests) forControlEvents:UIControlEventTouchUpInside];
    [_loadButton sizeToFit];
    [_loadButton setCenter:CGPointMake(_loadBG.bounds.size.width/2, _loadBG.bounds.size.height/2)];
    [_loadBG addSubview:_loadButton];
    [_loadButton setEnabled:NO];
    
    _loadContests = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_loadContests setFrame:CGRectMake(0,0, 44, 44)];
    [_loadContests setCenter:CGPointMake(_loadBG.bounds.size.width/2-_loadButton.bounds.size.width/2-22, _loadBG.bounds.size.height/2)];
    [_loadBG addSubview:_loadContests];
    [_loadContests startAnimating];
    
    _contestTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CCamThinNaviHeight+5, CCamViewWidth, 44) style:UITableViewStylePlain];
    [_contestTable setDataSource:self];
    [_contestTable setDelegate:self];
    [_contestTable setBounces:NO];
    [_contestTable setHidden:YES];
    [_submitBG addSubview:_contestTable];
    
    _submitImage = [[UIImageView alloc] initWithFrame:CGRectMake(CCamViewWidth/8, _contestTable.frame.origin.y+44+10, CCamViewWidth*3/4, CCamViewWidth*3/4)];
    [_submitBG addSubview:_submitImage];
    [_submitImage.layer setMasksToBounds:YES];
    [_submitImage.layer setCornerRadius:10.0];
    [_submitImage.layer setBorderWidth:1.0f];
    [_submitImage.layer setBorderColor:CCamBackgoundGrayColor.CGColor];
    
    _placeholderText = [[UITextView alloc] initWithFrame:CGRectMake(10, _submitImage.frame.origin.y+_submitImage.frame.size.height+10, CCamViewWidth-20, 44*3)];
    [_placeholderText setBackgroundColor:CCamBackgoundGrayColor];
    [_placeholderText setEditable:NO];
    [_placeholderText setText:Babel(@"说点什么吧")];
    [_placeholderText setTextColor:[UIColor lightGrayColor]];
    [_placeholderText setFont:[UIFont systemFontOfSize:14.0]];
    [_submitBG addSubview:_placeholderText];
    
    _submitText = [[UITextView alloc] initWithFrame:CGRectMake(10, _submitImage.frame.origin.y+_submitImage.frame.size.height+10, CCamViewWidth-20, 44*3)];
    [_submitText setBackgroundColor:[UIColor clearColor]];
    [_submitText setTextColor:CCamGrayTextColor];
    [_submitText setFont:[UIFont systemFontOfSize:14.0]];
    [_submitText setDelegate:self];
    [_submitBG addSubview:_submitText];
    
    _textNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, _submitText.frame.origin.y+_submitText.frame.size.height+5, CCamViewWidth-36, 36)];
    [_textNumLabel setTextAlignment:NSTextAlignmentRight];
    [_textNumLabel setBackgroundColor:[UIColor clearColor]];
    [_textNumLabel setFont:[UIFont systemFontOfSize:14.]];
    [_submitBG addSubview:_textNumLabel];
    
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setFrame:CGRectMake(0, CCamViewHeight-CCamThinSerieHeight, CCamViewWidth, CCamThinSerieHeight)];
    [_submitButton setTitle:Babel(@"发布") forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:CCamRedColor];
    [_submitButton setTintColor:CCamRedColor];
    [_submitButton addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
//    _personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_personalButton setBackgroundColor:[UIColor clearColor]];
//    [_personalButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [_personalButton setContentMode:UIViewContentModeScaleAspectFit];
//    [_personalButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
//    [_personalButton setTintColor:CCamGrayTextColor];
//    [_personalButton setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
//    [_personalButton setFrame:_textNumLabel.frame];
//    [_personalButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    [_personalButton setImage:[[self transformImage:[UIImage imageNamed:@"eraseDot"] Width:15 height:15] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    [_personalButton setTitle:@"仅自己可见" forState:UIControlStateNormal];
//    [_submitBG addSubview:_personalButton];
    
    _viewShaker = [[AFViewShaker alloc] initWithView:_submitText];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_submitImage != nil) {
        NSString *photoPath = [NSString stringWithFormat:@"%@/screenshot.jpg",CCamDocPath];
        [[FileHelper sharedManager] addSkipBackupAttributeToItemAtPath:photoPath];
        UIImage*img = [UIImage imageWithContentsOfFile:photoPath];
        [_submitImage setImage:img];
    }
    if ([_contests count] && [_contests count]>0) {
        
    }else{
        [self requestContests];
    }
    UnityPause(1);
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    UnityPause(0);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_submitBG endEditing:YES];
    
}
- (void)setConestButtonWithState:(BOOL)state{
    if (state) {
        [_loadButton setTitle:Babel(@"加载活动列表") forState:UIControlStateNormal];
        [_loadButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
        [_loadButton sizeToFit];
        [_loadButton setCenter:CGPointMake(_loadBG.bounds.size.width/2, _loadBG.bounds.size.height/2)];
        [_loadButton setEnabled:NO];
    }else{
        [_loadContests stopAnimating];
        [_loadButton setTitle:Babel(@"点击重新加载活动列表") forState:UIControlStateNormal];
        [_loadButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
        [_loadButton sizeToFit];
        [_loadButton setCenter:CGPointMake(_loadBG.bounds.size.width/2, _loadBG.bounds.size.height/2)];
        [_loadButton setEnabled:YES];
    }
}
- (void)getcontestsAnimation{
    NSInteger i = [_contests count];
    if (i<1) {
        return;
    }else{
        NSInteger j = i-1;
        [self.view endEditing:YES];
        [_submitBG setContentSize:CGSizeMake(CCamViewWidth, _submitBG.contentSize.height+j*44)];
        
        POPBasicAnimation *tableAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        tableAni.fromValue =[NSValue valueWithCGRect:CGRectMake(0, CCamThinNaviHeight+5, CCamViewWidth, 44)];
        tableAni.toValue = [NSValue valueWithCGRect:CGRectMake(0, CCamThinNaviHeight+5, CCamViewWidth, 44*i)];
        tableAni.beginTime = CACurrentMediaTime();
        tableAni.duration = 0.25f;
        [_contestTable pop_addAnimation:tableAni forKey:@"position"];
        
        POPBasicAnimation *imageAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        imageAni.fromValue =[NSValue valueWithCGRect:_submitImage.frame];
        imageAni.toValue = [NSValue valueWithCGRect:CGRectMake(_submitImage.frame.origin.x,_submitImage.frame.origin.y+44*j,_submitImage.frame.size.width,_submitImage.frame.size.height)];
        imageAni.beginTime = CACurrentMediaTime();
        imageAni.duration = 0.25f;
        [_submitImage pop_addAnimation:imageAni forKey:@"position"];
        
        POPBasicAnimation *placeAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        placeAni.fromValue =[NSValue valueWithCGRect:_placeholderText.frame];
        placeAni.toValue = [NSValue valueWithCGRect:CGRectMake(_placeholderText.frame.origin.x,_placeholderText.frame.origin.y+44*j,_placeholderText.frame.size.width,_placeholderText.frame.size.height)];
        placeAni.beginTime = CACurrentMediaTime();
        placeAni.duration = 0.25f;
        [_placeholderText pop_addAnimation:placeAni forKey:@"position"];
        
        POPBasicAnimation *textAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        textAni.fromValue =[NSValue valueWithCGRect:_submitText.frame];
        textAni.toValue = [NSValue valueWithCGRect:CGRectMake(_submitText.frame.origin.x,_submitText.frame.origin.y+44*j,_submitText.frame.size.width,_submitText.frame.size.height)];
        textAni.beginTime = CACurrentMediaTime();
        textAni.duration = 0.25f;
        [_submitText pop_addAnimation:textAni forKey:@"position"];
        
        POPBasicAnimation *numAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        numAni.fromValue =[NSValue valueWithCGRect:_textNumLabel.frame];
        numAni.toValue = [NSValue valueWithCGRect:CGRectMake(_textNumLabel.frame.origin.x,_textNumLabel.frame.origin.y+44*j,_textNumLabel.frame.size.width,_textNumLabel.frame.size.height)];
        numAni.beginTime = CACurrentMediaTime();
        numAni.duration = 0.25f;
        [_textNumLabel pop_addAnimation:numAni forKey:@"position"];
        
        POPBasicAnimation *personAni = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        personAni.fromValue =[NSValue valueWithCGRect:_personalButton.frame];
        personAni.toValue = [NSValue valueWithCGRect:CGRectMake(_personalButton.frame.origin.x,_personalButton.frame.origin.y+44*j,_personalButton.frame.size.width,_personalButton.frame.size.height)];
        personAni.beginTime = CACurrentMediaTime();
        personAni.duration = 0.25f;
        [_personalButton pop_addAnimation:personAni forKey:@"position"];
        
        [_submitBG setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)requestContests{
    
    [self setConestButtonWithState:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *serieID = [[iOSBindingManager sharedManager] getContestSerieID];
    NSDictionary *parameters = @{@"serieid":serieID};
    
    [manager GET:CCamGetCurrentContestsURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        NSError *error;
        NSArray *receiveArray = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        NSMutableArray * tempContests = [[NSMutableArray alloc] initWithCapacity:0];
        [self.contests removeAllObjects];
        for (int i = 0; i < receiveArray.count; i++) {
            NSDictionary* contestDic = [receiveArray objectAtIndex:i];
            [tempContests addObject:contestDic];
        }
        [self.contests addObjectsFromArray:tempContests];
//        NSDictionary *privacyItem = @{@"contestid":@"-1",@"name":@"仅自己可见",@"en_name":@"",@"zh_name":@""};
//        [self.contests addObject:privacyItem];
        [self.contestTable reloadData];
        
        [_contestTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        
        [self tableView:_contestTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        receiveArray = nil;
        [tempContests removeAllObjects];
        tempContests = nil;
        
        [_loadContests stopAnimating];
        [_loadBG setHidden:YES];
        [_contestTable setHidden:NO];
        
        [self getcontestsAnimation];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self setConestButtonWithState:NO];
        [self.contests removeAllObjects];
        NSDictionary *notPrivacyItem = @{@"contestid":@"0",@"name":@"分享到角色相机",@"en_name":@"Share to Character Camera",@"zh_name":@"分享到角色相機",@"url":@""};
        NSDictionary *privacyItem = @{@"contestid":@"-1",@"name":@"仅自己可见",@"en_name":@"",@"zh_name":@"僅自己可見",@"url":@""};
        [self.contests addObject:notPrivacyItem];
        [self.contests addObject:privacyItem];
        [self getcontestsAnimation];
    }];
}
- (void)uploadPhoto{



    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = Babel(@"发布照片中");
    
    [_submitButton setEnabled:NO];
    NSDictionary *parameters= @{@"token":[[AuthorizeHelper sharedManager] getUserToken],@"contestid":_currentContestID,@"description":_submitText.text,@"characterid":[[iOSBindingManager sharedManager] getSubmitCharactersList]};
    
    NSLog(@"%@",parameters);
    
    NSData *imageData = UIImageJPEGRepresentation(_submitImage.image, 0.4);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:CCamSubmitPhotoURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"submit.jpg" mimeType:@"image/jpeg"];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {

                      dispatch_async(dispatch_get_main_queue(), ^{
                          NSLog(@"%f",uploadProgress.fractionCompleted);
                          hud.progress = (float)uploadProgress.fractionCompleted;
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);

//                          hud.mode = MBProgressHUDModeText;
//                          hud.labelText =Babel(@"发布照片失败");
//                          [hud hide:YES afterDelay:2.0];
                          [hud hide:YES];
                          
                          [_submitButton setEnabled:YES];
                          
                          _submitAlert = [[UIAlertView alloc] initWithTitle:Babel(@"提示") message:Babel(@"噢？上传有点问题...") delegate:self cancelButtonTitle:Babel(@"取消") otherButtonTitles:Babel(@"重试"), nil];
                          [_submitAlert show];
                          
                      } else {
                          NSLog(@"%@ %@", response, responseObject);

                          hud.mode = MBProgressHUDModeText;
                          hud.labelText = Babel(@"发布照片成功");
                          [self performSelector:@selector(goToHomePage) withObject:nil afterDelay:1.0];
                      }
                  }];
    
    [uploadTask resume];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _submitAlert) {
        if (buttonIndex ==1) {
            [self uploadPhoto];
        }
    }
}
- (void)savePhoto{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText =Babel(@"保存照片至系统相册");
     UIImageWriteToSavedPhotosAlbum(_submitImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    hud.mode = MBProgressHUDModeText;
    if (error) {
        hud.labelText = Babel(@"保存照片失败");

    }else{
        hud.labelText = Babel(@"保存照片成功");

    }
    [hud hide:YES afterDelay:1.0];
    [self performSelector:@selector(uploadPhoto) withObject:nil afterDelay:1.0];
}
- (void)goToHomePage{
//    [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[iOSBindingManager sharedManager] showChangeSceneTransition];
    [self performSelector:@selector(removeSubmitView) withObject:nil afterDelay:0.25];
}
- (void)removeSubmitView{
    [self.navigationController removeFromParentViewController];
    [self.navigationController.view removeFromSuperview];

}
- (void)backToController{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_contests count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentContestID = [NSString stringWithFormat:@"%@",[[_contests objectAtIndex:indexPath.row] objectForKey:@"contestid"]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CCamSubmitContestCell *cell;
    
    if (cell == nil) {
        cell = [[CCamSubmitContestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"submitContestCell"];
        [cell.textLabel setHighlightedTextColor:CCamRedColor];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [cell.textLabel setTextColor:CCamGrayTextColor];
        
        NSString *language = [[SettingHelper sharedManager] getCurrentLanguage];
        NSString *contestNote;
        
        if ([language hasPrefix:@"zh-Hans"]) {
            contestNote = [[_contests objectAtIndex:indexPath.row] objectForKey:@"name"];
        }else if ([language hasPrefix:@"zh-Hant"]){
            contestNote = [[_contests objectAtIndex:indexPath.row] objectForKey:@"zh_name"];
        }else{
            contestNote = [[_contests objectAtIndex:indexPath.row] objectForKey:@"en_name"];
        }
        
        cell.textLabel.text = contestNote;
//        [cell layoutCell];
        
        if (!cell.cellButton) {
            cell.cellButton = [UIButton new];
            [cell.cellButton setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:cell.cellButton];
            [cell.cellButton setFrame:CGRectMake(0, 0, 150, 44)];
            cell.cellButton.tag =indexPath.row;//[[[_contests objectAtIndex:indexPath.row] objectForKey:@"contestid"] intValue];
            [cell.cellButton addTarget:self action:@selector(callRulePage:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    return cell;
}

- (void)callRulePage:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    if ([[[_contests objectAtIndex:button.tag] objectForKey:@"url"] isEqualToString:@""]) {
        return;
    }
    
//    if(button.tag == 0 || button.tag == -1){
//        return;
//    }
    
    KLWebViewController *agree = [[KLWebViewController alloc] init];
    agree.webURL = [[_contests objectAtIndex:button.tag] objectForKey:@"url"];
    agree.vcTitle = Babel(@"比赛规则");
    agree.setNavigationBar = YES;
    KLNavigationController *nv = [[KLNavigationController alloc] initWithRootViewController:agree];
    [self presentViewController:nv animated:YES completion:nil];
}

#pragma mark - text delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            _textNumLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@""]) {
        _placeholderText.hidden = NO;
        [_submitText setBackgroundColor:[UIColor clearColor]];
    }else{
        _placeholderText.hidden = YES;
        [_submitText setBackgroundColor:CCamBackgoundGrayColor];
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    if (MAX_LIMIT_NUMS - existTextNum>0) {
        [_textNumLabel setTextColor:CCamGrayTextColor];
         _textNumLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)MAX(0,MAX_LIMIT_NUMS - existTextNum),(long)MAX_LIMIT_NUMS];
    }else{
         _textNumLabel.text = Babel(@"字数已满");
        [_textNumLabel setTextColor:CCamRedColor];
        [_viewShaker shake];
    }
   
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.fromValue =[NSValue valueWithCGRect:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, -144, CCamViewWidth, CCamViewHeight)];
    anim.beginTime = CACurrentMediaTime();
    anim.duration = 0.25f;
    [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_submitBG pop_addAnimation:anim forKey:@"position"];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.toValue =[NSValue valueWithCGRect:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight)];
    anim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, -144, CCamViewWidth, CCamViewHeight)];
    anim.beginTime = CACurrentMediaTime();
    anim.duration = 0.25f;
    [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_submitBG pop_addAnimation:anim forKey:@"position"];    return YES;
}
- (UIImage*)transformImage:(UIImage*)image
                     Width:(CGFloat)width
                    height:(CGFloat)height {
    
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    CGImageRef imageRef = image.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4*destW,
                                                CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *resultImage = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return resultImage;
}
@end
