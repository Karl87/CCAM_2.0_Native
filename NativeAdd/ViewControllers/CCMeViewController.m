//
//  CCMeViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import "CCMeViewController.h"
#import <CoreText/CoreText.h>
#import "TimelineCell.h"
#import "CCTimeLine.h"
#import "KLWebViewController.h"

@interface CCMeViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UIScrollView *userBG;
@property (nonatomic,strong)UIView * userTopView;
@property (nonatomic,strong)UIImageView *userProfile;
@property (nonatomic,strong)UIButton *photoCount;
@property (nonatomic,strong)UIButton *fansBtn;
@property (nonatomic,strong)UIButton *followsBtn;
@property (nonatomic,strong)UIButton *pageFuncBtn;
@property (nonatomic,strong)UIView *modeView;
@property (nonatomic,strong)UIButton *timelineBtn;
@property (nonatomic,strong)UIButton *flowBtn;
@property (nonatomic,strong) UITableView *timeline;
@property (nonatomic,strong) UICollectionView *photoCollection;

@property (nonatomic,strong) NSMutableArray *photos;
@end


@implementation CCMeViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _photos = [[NSMutableArray alloc] initWithCapacity:0];
    
    _userBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamViewHeight)];
    [_userBG setContentSize:CGSizeMake(CCamViewWidth, CCamViewHeight-CCamNavigationBarHeight)];
    [_userBG setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_userBG];
    
    _userTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, 92)];
    [_userTopView setBackgroundColor:[UIColor whiteColor]];
    [_userBG addSubview:_userTopView];
    
    _userProfile = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _userTopView.bounds.size.height-20, _userTopView.bounds.size.height-20)];
    [_userProfile.layer setMasksToBounds:YES];
    [_userProfile.layer setCornerRadius:_userProfile.bounds.size.height/2];
    [_userTopView addSubview:_userProfile];
    
    _pageFuncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pageFuncBtn setFrame:CGRectMake(25+_userProfile.bounds.size.width, 49, _userTopView.bounds.size.width-25-_userProfile.bounds.size.width-10, 24)];
    [_pageFuncBtn setTitle:@"编辑个人主页" forState:UIControlStateNormal];
    [_pageFuncBtn.titleLabel setFont:[UIFont systemFontOfSize:11.0]];
    [_pageFuncBtn setBackgroundColor:CCamViewBackgroundColor];
    [_pageFuncBtn setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_pageFuncBtn.layer setMasksToBounds:YES];
    [_pageFuncBtn.layer setCornerRadius:5.0];
    [_userTopView addSubview:_pageFuncBtn];
    
    _photoCount = [UIButton buttonWithType:UIButtonTypeCustom];
    [_photoCount setFrame:CGRectMake(_pageFuncBtn.frame.origin.x, 0, _pageFuncBtn.frame.size.width/3, 49)];
    [_photoCount.titleLabel setNumberOfLines:0];
    [_photoCount.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_photoCount setAttributedTitle:[self returnStrWithTitle:@"100" andSubtitle:@"提交照片"] forState:UIControlStateNormal];    [_photoCount setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_userTopView addSubview:_photoCount];
    
    _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fansBtn setFrame:CGRectMake(_pageFuncBtn.frame.origin.x+_pageFuncBtn.frame.size.width/3, 0, _pageFuncBtn.frame.size.width/3, 49)];
    [_fansBtn.titleLabel setNumberOfLines:0];
    [_fansBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_fansBtn setAttributedTitle:[self returnStrWithTitle:@"100" andSubtitle:@"关注者"] forState:UIControlStateNormal];
//    [_fansBtn setTitle:@"51\n提交照片" forState:UIControlStateNormal];
    [_fansBtn setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_userTopView addSubview:_fansBtn];
    
    _followsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followsBtn setFrame:CGRectMake(_pageFuncBtn.frame.origin.x+_pageFuncBtn.frame.size.width*2/3, 0, _pageFuncBtn.frame.size.width/3, 49)];
    [_followsBtn setAttributedTitle:[self returnStrWithTitle:@"100" andSubtitle:@"关注者"] forState:UIControlStateNormal];
    [_followsBtn.titleLabel setNumberOfLines:0];
    [_followsBtn setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
    [_followsBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_userTopView addSubview:_followsBtn];
    
    _modeView = [[UIView alloc] initWithFrame:CGRectMake(0, _userTopView.frame.origin.y+_userTopView.frame.size.height+1.0, CCamViewWidth, 38)];
    [_modeView setBackgroundColor:[UIColor whiteColor]];
    [_userBG addSubview:_modeView];
    
    _timelineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timelineBtn setImage:[[UIImage imageNamed:@"userList"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_timelineBtn setTintColor:CCamRedColor];
    [_timelineBtn setFrame:CGRectMake(0, 0, 38, 38)];
    [_timelineBtn setCenter:CGPointMake(_userTopView.bounds.size.height/2, 19)];
    [_modeView addSubview:_timelineBtn];
    
    _flowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_flowBtn setImage:[[UIImage imageNamed:@"userFlow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_flowBtn setTintColor:CCamViewBackgroundColor];
    [_flowBtn setFrame:CGRectMake(0, 0, 38, 38)];
    [_flowBtn setCenter:CGPointMake(_userTopView.bounds.size.height/2+48, 19)];
    [_modeView addSubview:_flowBtn];
    
    _timeline = [[UITableView alloc] initWithFrame:CGRectMake(0,_userTopView.frame.size.height+_modeView.frame.size.height+1 , CCamViewWidth, _userBG.frame.size.height-(_userTopView.frame.size.height+_modeView.frame.size.height+1)) style:UITableViewStylePlain];
    [_timeline setDelegate:self];
    [_timeline setDataSource:self];
    [_userBG addSubview:_timeline];
    
    if (![[[AuthorizeHelper sharedManager] getUserID] isEqualToString:@""]) {
        [self initSelfHomePage];

    }
}
- (NSMutableAttributedString *)returnStrWithTitle:(NSString *)mainTitle andSubtitle:(NSString *)subtitle{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",mainTitle,subtitle]];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0] range:NSMakeRange(0, mainTitle.length)];
    [str addAttribute:NSForegroundColorAttributeName value:CCamGrayTextColor range:NSMakeRange(0, mainTitle.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(mainTitle.length+1, subtitle.length)];
    [str addAttribute:NSForegroundColorAttributeName value:CCamViewBackgroundColor range:NSMakeRange(mainTitle.length+1, subtitle.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8.0];//调整行间距
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mainTitle.length+subtitle.length+1)];
    
    return str;
}
- (void)initSelfHomePage{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *userid = [[AuthorizeHelper sharedManager] getUserID];
    NSLog(@"访问用户%@主页",userid);
    NSDictionary *parameters = @{@"memberid" :userid};
    [manager GET:CCamGetUserHomePageURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
       NSDictionary *receiveDic =[NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        [_userProfile sd_setImageWithURL:[NSURL URLWithString:[[receiveDic objectForKey:@"member"] objectForKey:@"image_url"]]];
        [_photoCount setAttributedTitle:[self returnStrWithTitle:[receiveDic objectForKey:@"workNums"] andSubtitle:@"提交照片"] forState:UIControlStateNormal];
        [_fansBtn setAttributedTitle:[self returnStrWithTitle:[receiveDic objectForKey:@"byfollowNum"] andSubtitle:@"关注者"] forState:UIControlStateNormal];
        [_followsBtn setAttributedTitle:[self returnStrWithTitle:[receiveDic objectForKey:@"followNum"] andSubtitle:@"关注"] forState:UIControlStateNormal];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}
#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_photos count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    {
        static NSString *identifier = @"timelineCell";
        TimelineCell *cell = [[TimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CCTimeLine *timeLine = (CCTimeLine*)[_photos objectAtIndex:indexPath.row];
        cell.timeline = timeLine;
        [cell reloadComments];
        
        return cell;
    }
    
    static NSString *identifier = @"DefaultTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![cell isKindOfClass:[TimelineCell class]]) {
        return;
    }
    TimelineCell * timelineCell = (TimelineCell*)cell;
    [timelineCell layoutTimelineCell];
    
    if (![timelineCell.timeline.cNameCN isEqualToString:@""]&&![timelineCell.timeline.cNameCN isEqualToString:@"<null>"]) {
        [timelineCell.photoTitle setTitle:[NSString stringWithFormat:@"#%@#",timelineCell.timeline.cNameCN] forState:UIControlStateNormal];
        [timelineCell.photoTitle setTag:[timelineCell.timeline.timelineContestID intValue]];
        [timelineCell.photoTitle addTarget:self action:@selector(callContestWeb:) forControlEvents:UIControlEventTouchUpInside];
    }
    [timelineCell setLikeLabelText];
    [timelineCell.profileImage sd_setImageWithURL:[NSURL URLWithString:timelineCell.timeline.timelineUserImage] placeholderImage:nil];
    [timelineCell.userName setText:timelineCell.timeline.timelineUserName];
    [timelineCell.photo sd_setImageWithURL:[NSURL URLWithString:timelineCell.timeline.image_fullsize] placeholderImage:nil];
    [timelineCell.photoDes setText:timelineCell.timeline.timelineDes];
    
    
    NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:[timelineCell.timeline.dateline integerValue]];
    //    NSLog(@"%@ = %@",timelineCell.timeline.dateline,timeDate);
    //    NSLog(@"%@",[self compareCurrentTime:timeDate]);
    [timelineCell.photoTime setText:[self compareCurrentTime:timeDate]];
}
-(NSString *) compareCurrentTime:(NSDate*) compareDate
//
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}
- (void)callContestWeb:(id)sender{
    UIButton *btn = (UIButton*)sender;
    KLWebViewController *detail = [[KLWebViewController alloc] init];
    detail.webURL = [NSString stringWithFormat:@"http://www.c-cam.cc/index.php/First/Photo/index/contestid/%ld.html",(long)btn.tag];
    detail.vcTitle =btn.currentTitle;
    detail.hidesBottomBarWhenPushed = YES;
    
    id vc = nil;
    vc = detail;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    self.navigationItem.backBarButtonItem=backItem;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    CCPhotoViewController *photo = [[CCPhotoViewController alloc] init];
    //    photo.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:photo animated:YES];
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//
//{
//    if (section == 0) {
//        return 0;
//    }else{
//        return 44;
//    }
//
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
   
        CCTimeLine *timeLine = (CCTimeLine*)[_photos objectAtIndex:indexPath.row];
        if ([timeLine.cNameCN isEqualToString:@""]||[timeLine.cNameCN isEqualToString:@"<null>"]) {
            return 110+CCamViewWidth+30*[timeLine.comments count];
        }
        
        return 140+CCamViewWidth+30*[timeLine.comments count];
    
    return 0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    static NSString *identifier = @"header";
//    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
//
//    [view setFrame:CGRectMake(0, 0, CCamViewWidth, 44)];
//
//    UIView *place = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 22, 22)];
//    [place setBackgroundColor:CCamRedColor];
//    [view addSubview:place];
//
//    return view;
//}
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
//    view.tintColor = [UIColor clearColor];
//}
@end
