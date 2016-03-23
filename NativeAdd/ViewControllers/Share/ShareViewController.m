//
//  ShareViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/7.
//
//

#import "ShareViewController.h"
#import "CCamHelper.h"
#import <pop/POP.h>


#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ShareViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UIView *optionPop;
@property (nonatomic,strong) UIScrollView *optionView;
@property (nonatomic,strong) UIPageControl *optionPageControl;
@property (nonatomic,strong) UIView *sharePop;
@property (nonatomic,strong) UIScrollView *shareView;
@property (nonatomic,strong) UIPageControl *sharePageControl;
@property (nonatomic,strong) NSMutableArray *optionBtns;
@property (nonatomic,strong) NSMutableArray *optionLabs;
@property (nonatomic,strong) UIAlertView *privacyAlert;
@end

@implementation ShareViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_isShareImage) {
        _isShareImage = NO;
    }
    
    _optionBtns = [NSMutableArray new];
    _optionLabs = [NSMutableArray new];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
    
    _optionPop = [[UIView alloc] initWithFrame:CGRectMake(0, CCamViewHeight, CCamViewWidth, 190)];
    [_optionPop setBackgroundColor:CCamViewBackgroundColor];
    [self.view addSubview:_optionPop];
    
    UIButton *optionClose = [UIButton new];
    [optionClose setTitle:Babel(@"取消") forState:UIControlStateNormal];
    [optionClose setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [optionClose.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [optionClose setFrame:CGRectMake(0,190-40, CCamViewWidth, 40)];
    [optionClose setBackgroundColor:[UIColor whiteColor]];
    [optionClose addTarget:self action:@selector(hideOptionPop) forControlEvents:UIControlEventTouchUpInside];
    [_optionPop addSubview:optionClose];
    
    UIView *optionViewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, 138)];
    [optionViewBG setBackgroundColor:[UIColor whiteColor]];
    [_optionPop addSubview:optionViewBG];
    
    _optionView  = [[UIScrollView alloc] init];
    [_optionView setPagingEnabled:YES];
    [_optionView setBounces:NO];
    [_optionView setBackgroundColor:[UIColor whiteColor]];
    [_optionView setDelegate:self];
    [_optionView setShowsHorizontalScrollIndicator:NO];
    [_optionPop addSubview:_optionView];
    
    [self setOptionBtns];
    
    _sharePop = [[UIView alloc] initWithFrame:CGRectMake(0, CCamViewHeight, CCamViewWidth, 260)];
    [_sharePop setBackgroundColor:CCamViewBackgroundColor];
    [self.view addSubview:_sharePop];
    
    UIButton *shareClose = [UIButton new];
    [shareClose setTitle:@"取消" forState:UIControlStateNormal];
    [shareClose setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [shareClose.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [shareClose setFrame:CGRectMake(0,260-40, CCamViewWidth, 40)];
    [shareClose setBackgroundColor:[UIColor whiteColor]];
    [shareClose addTarget:self action:@selector(hideSharePop) forControlEvents:UIControlEventTouchUpInside];
    [_sharePop addSubview:shareClose];
    
    UIView *shareViewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, 206)];
    [shareViewBG setBackgroundColor:[UIColor whiteColor]];
    [_sharePop addSubview:shareViewBG];
    
    _shareView  = [[UIScrollView alloc] init];
    [_shareView setPagingEnabled:YES];
    [_shareView setBounces:NO];
    [_shareView setBackgroundColor:[UIColor whiteColor]];
    [_shareView setDelegate:self];
    [_shareView setShowsHorizontalScrollIndicator:NO];
    [_sharePop addSubview:_shareView];
    
    [self setShareBtns];
}
- (void)setShareBtns{
    
    NSMutableArray *images = [NSMutableArray new];
    NSMutableArray *titles = [NSMutableArray new];
    
    if ([WXApi isWXAppSupportApi]&&[WXApi isWXAppInstalled]) {
        [images addObject:@"sheetWechat"];
        [images addObject:@"sheetTimeline"];
        [titles addObject:Babel(@"微信")];
        [titles addObject:Babel(@"朋友圈")];
    }
    
    [images addObject:@"sheetSinaWeibo"];
    [titles addObject:Babel(@"新浪微博")];
    
    if ([QQApiInterface isQQInstalled]&&[QQApiInterface isQQSupportApi]){
        [images addObject:@"sheetQQ"];
        [titles addObject:Babel(@"QQ")];
        [images addObject:@"sheetQZone"];
        [titles addObject:Babel(@"QQ空间")];
    }
    
    [images addObject:@"sheetFacebook"];
    [titles addObject:Babel(@"Facebook")];
    
    [images addObject:@"sheetCopyURL"];
    [titles addObject:Babel(@"复制链接")];

    if (titles.count>4) {
        [_shareView setFrame:CGRectMake((CCamViewWidth-320)/2, (206-160)/2-10, 320, 160)];
        if ([titles count]%8 !=0) {
            [_shareView setContentSize:CGSizeMake(320*(titles.count/8+1), 160)];
        }else{
            [_shareView setContentSize:CGSizeMake(320*titles.count/8, 160)];
        }
    }else{
        [_shareView setFrame:CGRectMake((CCamViewWidth-320)/2, (206-80)/2-10, 320, 80)];
        [_shareView setContentSize:CGSizeMake(_shareView.bounds.size.width, _shareView.bounds.size.height)];
    }
    
    for (int i = 0 ; i<[titles count]; i++) {
        [self returnShareBtnViewWithFrame:CGRectMake(i%4*80, i/4*80, 80, 80) image:[UIImage imageNamed:[images objectAtIndex:i]] title:[titles objectAtIndex:i]];
    }
    
    _sharePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 260-40-12-20, CCamViewWidth, 20)];
    [_sharePop addSubview:_sharePageControl];
    [_sharePageControl setNumberOfPages:_shareView.contentSize.width/320.0];
    [_sharePageControl setPageIndicatorTintColor:CCamPageNormalColor];
    [_sharePageControl setCurrentPageIndicatorTintColor:CCamPageSelectColor];
    [_sharePageControl setCurrentPage:0];
    [_sharePageControl setHidesForSinglePage:YES];
}
- (UIView *)returnShareBtnViewWithFrame:(CGRect)frame image:(UIImage*)image title:(NSString*)title{
    
    UIView *shareBtnView = [UIView new];
    [shareBtnView setBackgroundColor:[UIColor whiteColor]];
    [_shareView addSubview:shareBtnView];
    [shareBtnView setFrame:frame];
//    [shareBtnView setCenter:center];
    
    UIButton *shareBtn = [UIButton new];
    [shareBtn setFrame:CGRectMake((80-44)/2, (80-44)/2, 44, 44)];
    [shareBtn setBackgroundColor:[UIColor whiteColor]];
    [shareBtn.layer setMasksToBounds:YES];
    [shareBtn.layer setCornerRadius:shareBtn.bounds.size.height/2];
    [shareBtnView addSubview:shareBtn];
    [shareBtn setTitle:title forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:image forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *shareBtnLab = [UILabel new];
    [shareBtnLab setBackgroundColor:[UIColor whiteColor]];
    [shareBtnLab setFrame:CGRectMake(0, 64, 80, 20)];
    [shareBtnLab setFont:[UIFont systemFontOfSize:12.0]];
    [shareBtnLab setTextColor:CCamGrayTextColor];
    [shareBtnLab setTextAlignment:NSTextAlignmentCenter];
    [shareBtnLab setText:title];
    [shareBtnView addSubview:shareBtnLab];
    
    return shareBtnView;
}
- (void)shareBtnOnClick:(id)sender{
    [self hideSharePop];
    UIButton* btn = (UIButton *)sender;
    [delegate shareViewBtnClickWithType:@"Share" andTitle:btn.currentTitle isShareImage:_isShareImage];
}
- (void)setOptionBtns{
    if (_myself) {
        
        NSMutableArray *images = [NSMutableArray new];
        NSMutableArray *titles = [NSMutableArray new];
        
        [images addObjectsFromArray:@[@"sheetShareURL",@"sheetShareImage",@"sheetMyself",@"sheetDelete",@"sheetSave"]];
        
        [titles addObjectsFromArray: @[Babel(@"分享拉赞"),Babel(@"分享照片"),Babel(@"仅自己可见"),Babel(@"删除照片"),Babel(@"下载照片")]];
        
        if ([_timeline.timelineContestID isEqualToString:@"-1"]) {
            [images replaceObjectAtIndex:2 withObject:@"sheetOpen"];
            [titles replaceObjectAtIndex:2 withObject:Babel(@"全部人可见")];
        }
        
        if ([[[AuthorizeHelper sharedManager] getUserGroup] isEqualToString:@"0"]) {
            [images addObject:@"sheetAdmin"];
            [titles addObject:Babel(@"管理员工具")];
        }
        
        
        if ([titles count]>4) {
            [_optionView setFrame:CGRectMake((CCamViewWidth-4*80)/2, 0, 320, 138)];
            if ([titles count]%4 !=0) {
                [_optionView setContentSize:CGSizeMake(320*(titles.count/4+1), 138)];
            }else{
                [_optionView setContentSize:CGSizeMake(320*titles.count/4, 138)];
            }
            
        }else{
            [_optionView setFrame:CGRectMake((CCamViewWidth-titles.count*80)/2, 0, 80*titles.count, 138)];
            [_optionView setContentSize:CGSizeMake(_optionView.bounds.size.width, _optionView.bounds.size.height)];
        }
        
        for (int i = 0; i<[titles count]; i++) {
            [self returnOptionBtnViewWithFrame:CGRectMake(0, 0, 80, 90) center:CGPointMake(40+i*80, _optionView.bounds.size.height/2) image:[UIImage imageNamed:[images objectAtIndex:i]] title:[titles objectAtIndex:i]];
        }
    }else{
        
        NSMutableArray *images = [NSMutableArray new];
        NSMutableArray *titles = [NSMutableArray new];
        
        [images addObjectsFromArray:@[@"sheetShareURL",@"sheetShareImage",@"sheetReport",@"sheetSave"]];
        
        [titles addObjectsFromArray: @[Babel(@"分享拉赞"),Babel(@"分享照片"),Babel(@"举报照片"),Babel(@"下载照片")]];
        
        if ([_timeline.report isEqualToString:@"1"]) {
            [images replaceObjectAtIndex:2 withObject:@"sheetCancelReport"];
            [titles replaceObjectAtIndex:2 withObject:Babel(@"取消举报")];
        }
        
        if ([[[AuthorizeHelper sharedManager] getUserGroup] isEqualToString:@"0"]) {
            [images addObject:@"sheetAdmin"];
            [titles addObject:Babel(@"管理员工具")];
        }
        
        if ([titles count]>4) {
            [_optionView setFrame:CGRectMake((CCamViewWidth-4*80)/2, 0, 320, 138)];
            if ([titles count]%4 !=0) {
                [_optionView setContentSize:CGSizeMake(320*(titles.count/4+1), 138)];
            }else{
                [_optionView setContentSize:CGSizeMake(320*titles.count/4, 138)];
            }
            
        }else{
            [_optionView setFrame:CGRectMake((CCamViewWidth-titles.count*80)/2, 0, 80*titles.count, 138)];
            [_optionView setContentSize:CGSizeMake(_optionView.bounds.size.width, _optionView.bounds.size.height)];
        }

        for (int i = 0; i<[titles count]; i++) {
            [self returnOptionBtnViewWithFrame:CGRectMake(0, 0, 80, 90) center:CGPointMake(40+i*80, _optionView.bounds.size.height/2) image:[UIImage imageNamed:[images objectAtIndex:i]] title:[titles objectAtIndex:i]];
        }

    }
    
    _optionPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 190-40-12-20, CCamViewWidth, 20)];
    [_optionPop addSubview:_optionPageControl];
    [_optionPageControl setNumberOfPages:_optionView.contentSize.width/320.0];
    [_optionPageControl setPageIndicatorTintColor:CCamPageNormalColor];
    [_optionPageControl setCurrentPageIndicatorTintColor:CCamPageSelectColor];
    [_optionPageControl setCurrentPage:0];
    [_optionPageControl setHidesForSinglePage:YES];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _optionView) {
        NSInteger page= scrollView.contentOffset.x/scrollView.frame.size.width;
        [_optionPageControl setCurrentPage:page];
    }else if (scrollView == _shareView){
        NSInteger page= scrollView.contentOffset.x/scrollView.frame.size.width;
        [_sharePageControl setCurrentPage:page];
    }
}
- (void)optionBtnOnClick:(id)sender{
//    NSLog(@"shareURL");
    
    UIButton* btn = (UIButton *)sender;
    [delegate shareViewBtnClickWithType:@"Option" andTitle:btn.currentTitle isShareImage:_isShareImage];
    if([btn.currentTitle isEqualToString:Babel(@"分享拉赞")]){
        _isShareImage = NO;
        [self showSharePop];
    }else if ([btn.currentTitle isEqualToString:Babel(@"分享照片")]){
        _isShareImage = YES;
        [self showSharePop];
    }else if ([btn.currentTitle isEqualToString:Babel(@"仅自己可见")]){
        [self setPrivacy:sender state:YES];
    }else if ([btn.currentTitle isEqualToString:Babel(@"全部人可见")]){
        [self setPrivacy:sender state:NO];
    }else if ([btn.currentTitle isEqualToString:Babel(@"举报照片")]){
        [self setReportPhoto:sender state:YES];
    }else if ([btn.currentTitle isEqualToString:Babel(@"取消举报")]){
        [self setReportPhoto:sender state:NO];
    }
    else{
        [self hideOptionPop];
    }
}
- (void)setReportPhoto:(id)sender state:(BOOL)state{
    UIButton *btn = (UIButton *)sender;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
//    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
//    NSString *contestID ;
//    if (state) {
//        contestID = @"-1";
//    }else{
//        contestID = @"0";
//    }
    NSDictionary *parameters = @{@"workid" :photoID};//,@"token":token,@"contestid":contestID};
    [manager POST:CCamReportPhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---->%@",result);
        UILabel *lab = (UILabel*)[_optionLabs objectAtIndex:[_optionBtns indexOfObject:btn]];
        if (state) {
            _timeline.report = @"1";
            [btn setTitle:Babel(@"取消举报") forState:UIControlStateNormal];
            [lab setText:Babel(@"取消举报")];
            [btn setBackgroundImage:[UIImage imageNamed:@"sheetCancelReport"] forState:UIControlStateNormal];
        }else{
            _timeline.report = @"0";
            [btn setTitle:Babel(@"举报照片") forState:UIControlStateNormal];
            [lab setText:Babel(@"举报照片")];
            [btn setBackgroundImage:[UIImage imageNamed:@"sheetReport"] forState:UIControlStateNormal];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)setContestPhotoPrivacyWithIndex:(NSInteger)index{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSString *contestID = @"-1";
    NSDictionary *parameters = @{@"workid" :photoID,@"token":token,@"contestid":contestID};
    [manager POST:CCamPrivacyURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---->%@",result);
        UILabel *lab = (UILabel*)[_optionLabs objectAtIndex:index];
        UIButton *btn = (UIButton*)[_optionBtns objectAtIndex:index];

        _timeline.timelineContestID = @"-1";
        _timeline.cNameCN = @"";

        [btn setTitle:Babel(@"全部人可见") forState:UIControlStateNormal];
        [lab setText:Babel(@"全部人可见")];
        [btn setBackgroundImage:[UIImage imageNamed:@"sheetOpen"] forState:UIControlStateNormal];
        if (_timelineCell) {
            if (_timelineCell.privateBlock) {
                _timelineCell.privateBlock(_timelineCell.indexPath);
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _privacyAlert) {
        if (buttonIndex ==1) {
            [self setContestPhotoPrivacyWithIndex:alertView.tag];
        }
    }
}
- (void)setPrivacy:(id)sender state:(BOOL)state{
    
    if (_timeline.timelineContestID) {
        NSLog(@"*****%@",_timeline.timelineContestID);
    }
    //修改
    
    UIButton *btn = (UIButton *)sender;
    
    if(![_timeline.timelineContestID isEqualToString:@""]&&![_timeline.timelineContestID isEqualToString:@"0"]&&![_timeline.timelineContestID isEqualToString:@"-1"]&&![_timeline.timelineContestID isEqualToString:@"<null>"]&&![_timeline.timelineContestID isEqualToString:@"null"]){
        
        NSString *message = [NSString stringWithFormat:@"您的照片已经参加了比赛'%@',设置为仅自己可见将放弃参加比赛且无法恢复参赛状态, 确定取消？",_timeline.cNameCN];
        _privacyAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:Babel(@"暂时不要") otherButtonTitles:Babel(@"确定"),nil];
        _privacyAlert.tag = [_optionBtns indexOfObject:btn];
        [_privacyAlert show];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
    NSString *contestID ;
    if (state) {
        contestID = @"-1";
    }else{
        contestID = @"0";
    }
    NSDictionary *parameters = @{@"workid" :photoID,@"token":token,@"contestid":contestID};
    [manager POST:CCamPrivacyURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"---->%@",result);
        UILabel *lab = (UILabel*)[_optionLabs objectAtIndex:[_optionBtns indexOfObject:btn]];
        if (state) {
            _timeline.timelineContestID = @"-1";
            [btn setTitle:Babel(@"全部人可见") forState:UIControlStateNormal];
            [lab setText:Babel(@"全部人可见")];
            [btn setBackgroundImage:[UIImage imageNamed:@"sheetOpen"] forState:UIControlStateNormal];
            if (_timelineCell) {
                if (_timelineCell.privateBlock) {
                    _timelineCell.privateBlock(_timelineCell.indexPath);
                }
            }
        }else{
            _timeline.timelineContestID = @"0";
            [btn setTitle:Babel(@"仅自己可见") forState:UIControlStateNormal];
            [lab setText:Babel(@"仅自己可见")];
            [btn setBackgroundImage:[UIImage imageNamed:@"sheetMyself"] forState:UIControlStateNormal];
            if (_timelineCell) {
                if (_timelineCell.privateBlock) {
                    _timelineCell.privateBlock(_timelineCell.indexPath);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (UIView *)returnOptionBtnViewWithFrame:(CGRect)frame center:(CGPoint)center image:(UIImage*)image title:(NSString*)title{
    
    UIView *optionBtnView = [UIView new];
    [optionBtnView setBackgroundColor:[UIColor whiteColor]];
    [_optionView addSubview:optionBtnView];
    [optionBtnView setFrame:frame];
    [optionBtnView setCenter:center];
    
    UIButton *optionBtn = [UIButton new];
    [optionBtn setFrame:CGRectMake(10, 0, 60, 60)];
    [optionBtn setBackgroundColor:[UIColor whiteColor]];
    [optionBtn.layer setMasksToBounds:YES];
    [optionBtn.layer setCornerRadius:optionBtn.bounds.size.height/2];
    [optionBtnView addSubview:optionBtn];
    [optionBtn setTitle:title forState:UIControlStateNormal];
    [optionBtn setBackgroundImage:image forState:UIControlStateNormal];
    [optionBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [optionBtn addTarget:self action:@selector(optionBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_optionBtns addObject:optionBtn];
    
    UILabel *optionBtnLab = [UILabel new];
    [optionBtnLab setBackgroundColor:[UIColor whiteColor]];
    [optionBtnLab setFrame:CGRectMake(0, 70, 80, 20)];
    [optionBtnLab setFont:[UIFont systemFontOfSize:12.0]];
    [optionBtnLab setTextColor:CCamGrayTextColor];
    [optionBtnLab setTextAlignment:NSTextAlignmentCenter];
    [optionBtnLab setText:title];
    [optionBtnView addSubview:optionBtnLab];
    [_optionLabs addObject:optionBtnLab];
    
    return optionBtnView;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_onlyShare) {
        [self showSharePop];
    }else{
        [self showOptionPop];
    }
}
- (void)showSharePop{
    
    if (_optionPop.center.y == CCamViewHeight-95) {
        POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anSpring.fromValue = @(_optionPop.center.y);
        anSpring.toValue = @(CCamViewHeight+95);
        anSpring.beginTime = CACurrentMediaTime();
        anSpring.duration = 0.15f;
        [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
            if(finish) {
                NSLog(@"!");
                POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
                anSpring.fromValue = @(_sharePop.center.y);
                anSpring.toValue = @(CCamViewHeight-130);
                anSpring.beginTime = CACurrentMediaTime();
                anSpring.duration = 0.15f;
                [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
                    if(finish) {
                        NSLog(@"!");
                    }
                }];
                [_sharePop pop_addAnimation:anSpring forKey:@"position"];
            }
        }];
        [_optionPop pop_addAnimation:anSpring forKey:@"position"];
    }else{
        POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anSpring.fromValue = @(_sharePop.center.y);
        anSpring.toValue = @(CCamViewHeight-130);
        anSpring.beginTime = CACurrentMediaTime();
        anSpring.duration = 0.15f;
        [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
            if(finish) {
                NSLog(@"!");
            }
        }];
        [_sharePop pop_addAnimation:anSpring forKey:@"position"];
    }
}
- (void)hideSharePop{
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.fromValue = @(_sharePop.center.y);
    anSpring.toValue = @(CCamViewHeight+130);
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.duration = 0.15f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            if (_indexPath) {
                [delegate dissmisShareViewWith:_indexPath];
            }
            [self.view setBackgroundColor:[UIColor clearColor]];
            [[ShareHelper sharedManager] dismissShareView];
        }
    }];
    [_sharePop pop_addAnimation:anSpring forKey:@"position"];
}
- (void)showOptionPop{
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.fromValue = @(_optionPop.center.y);
    anSpring.toValue = @(CCamViewHeight-95);
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.duration = 0.15f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
        }
    }];
    [_optionPop pop_addAnimation:anSpring forKey:@"position"];
}
- (void)hideOptionPop{
    
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.fromValue = @(_optionPop.center.y);
    anSpring.toValue = @(CCamViewHeight+95);
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.duration = 0.15f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [delegate dissmisShareViewWith:_indexPath];
            [self.view setBackgroundColor:[UIColor clearColor]];
            [[ShareHelper sharedManager] dismissShareView];
        }
    }];
    [_optionPop pop_addAnimation:anSpring forKey:@"position"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    if (_optionPop.center.y == CCamViewHeight-95) {
        [self hideOptionPop];
    }else if (_sharePop.center.y == CCamViewHeight-130){
        [self hideSharePop];
    }
}
@end
