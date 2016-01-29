//
//  TimelineCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#define profileSize 30.0

#import "TimelineCell.h"
#import "TimelineCommentCell.h"

#import "Constants.h"
#import "CCamHelper.h"
#import "CCComment.h"
#import "CCLike.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface TimelineCell ()<MLEmojiLabelDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>

@end

@implementation TimelineCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_cellBG) {
            _cellBG = [[UIView alloc] initWithFrame:CGRectZero];
            [_cellBG setBackgroundColor:[UIColor whiteColor]];
            [_cellBG.layer setMasksToBounds:YES];
            [_cellBG.layer setCornerRadius:8.0];
            [self.contentView addSubview:_cellBG];
        }
        if(!_profileImage){
            _profileImage = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_profileImage.layer setMasksToBounds:YES];
            [_profileImage.layer setCornerRadius:profileSize/2];
            [_cellBG addSubview:_profileImage];
        }
        
        if (!_userName) {
            _userName = [[UILabel alloc] initWithFrame:CGRectZero];
            [_userName setTextColor:CCamGrayTextColor];
            [_userName setBackgroundColor:[UIColor clearColor]];
            [_userName setFont:[UIFont boldSystemFontOfSize:14.0]];
            [_userName setTextAlignment:NSTextAlignmentLeft];
            [_cellBG addSubview:_userName];
        }
        
        if (!_photoTime) {
            _photoTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [_photoTime setTextColor:CCamGrayTextColor];
            [_photoTime setBackgroundColor:[UIColor clearColor]];
            [_photoTime setFont:[UIFont systemFontOfSize:11.0]];
            [_photoTime setTextAlignment:NSTextAlignmentRight];
            [_cellBG addSubview:_photoTime];
        }
        
        if (!_photo) {
            _photo = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_cellBG addSubview:_photo];
        }
        
        if (!_photoTitle) {
            _photoTitle = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoTitle setFrame:CGRectZero];
            [_photoTitle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_photoTitle setBackgroundColor:[UIColor whiteColor]];
            [_photoTitle setTitleColor:CCamRedColor forState:UIControlStateNormal];
            [_photoTitle.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [_cellBG addSubview:_photoTitle];
        }
        
        if (!_photoDes) {
            _photoDes = [[UILabel alloc] initWithFrame:CGRectZero];
            [_photoDes setFont:[UIFont systemFontOfSize:11.0]];
            [_photoDes setTextColor:CCamGrayTextColor];
            [_photoDes setTextAlignment:NSTextAlignmentLeft];
            [_cellBG addSubview:_photoDes];
        }
        
        if (!_photoInput) {
            _photoInput = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoInput setFrame:CGRectZero];
            [_photoInput setImage:[[UIImage imageNamed:@"commentIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_photoInput.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_photoInput setTintColor:CCamViewBackgroundColor];
            [_cellBG addSubview:_photoInput];
        }
        
        if (!_photoLike) {
            _photoLike  = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoLike setFrame:CGRectZero];
            [_photoLike setImage:[[UIImage imageNamed:@"likeIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_photoLike.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_photoLike setTintColor:CCamViewBackgroundColor];
            [_cellBG addSubview:_photoLike];
        }
        
        if (!_photoMore) {
            _photoMore = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoMore setFrame:CGRectZero];
            [_photoMore setImage:[[UIImage imageNamed:@"moreIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            [_photoMore.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_photoMore setTintColor:CCamViewBackgroundColor];
            [_photoMore addTarget:self action:@selector(callMoreActionSheet) forControlEvents:UIControlEventTouchUpInside];
            [_cellBG addSubview:_photoMore];
        }
        
        if (!_likeView) {
            _likeView = [[UIView alloc] initWithFrame:CGRectZero];
            [_cellBG addSubview:_likeView];
        }
        
        if (!_likeLabel) {
            _likeLabel = [MLEmojiLabel new];
            [_likeLabel setText:@"♥ "];
            [_likeLabel setDelegate:self];
            _likeLabel.numberOfLines = 1;
            [_likeLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [_likeLabel setBackgroundColor:[UIColor clearColor]];
            [_likeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [_likeLabel setTextColor:CCamGrayTextColor];
            
            [_likeLabel setIsNeedAtAndPoundSign:YES];
            [_likeLabel setDisableEmoji:YES];
//            [_likeLabel setLineSpacing:3.0];
//            [_likeLabel setVerticalAlignment:TTTAttributedLabelVerticalAlignmentCenter];
            [_likeView addSubview:_likeLabel];
        }
        
        if (!_messageView) {
            _messageView = [[UIView alloc] initWithFrame:CGRectZero];
            [_cellBG addSubview:_messageView];
        }
        
        if (!_commentTable) {
            _commentTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            [_commentTable setDelegate:self];
            [_commentTable setDataSource:self];
            [_commentTable setBounces:NO];
            [_commentTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [_messageView addSubview:_commentTable];
        }
    }
    return self;
}
- (void)layoutTimelineCell{
    [_cellBG setFrame:CGRectMake(5, 3, self.bounds.size.width-10, self.bounds.size.height-6)];
    [_profileImage setFrame:CGRectMake(10, 5, profileSize, profileSize)];
    [_userName setFrame:CGRectMake(20+profileSize, 5, self.bounds.size.width-30-profileSize, profileSize)];
    [_photoTime setFrame:CGRectMake(20, 5, self.bounds.size.width-40, profileSize)];
    [_photo setFrame:CGRectMake(0, 10+profileSize, self.bounds.size.width, self.bounds.size.width)];
    
    BOOL onContest = NO;
    
    if (![_timeline.cNameCN isEqualToString:@""]&&![_timeline.cNameCN isEqualToString:@"<null>"]) {
        onContest = YES;
    }
    float titleHeight;
    
    if (onContest) {
        titleHeight = 30;
    }else{
        titleHeight = 0;
    }
    
    [_photoTitle setFrame:CGRectMake(10, 15+profileSize+self.bounds.size.width, self.bounds.size.width-20, titleHeight)];
    
    [_photoInput setFrame:CGRectMake(0, 15+titleHeight+profileSize+self.bounds.size.width, 40, 40)];
    [_photoLike setFrame:CGRectMake(40, 15+titleHeight+profileSize+self.bounds.size.width,40,40)];
    [_photoMore setFrame:CGRectMake(self.bounds.size.width-50, 15+titleHeight+profileSize+self.bounds.size.width,40,40)];
    
    [_likeView setFrame:CGRectMake(10, 65+titleHeight+self.bounds.size.width, self.bounds.size.width, 44)];
    [_likeLabel setFrame:CGRectMake(0, 0, _likeView.frame.size.width, _likeView.frame.size.height)];
    
    [_messageView setFrame:CGRectMake(0, 99+titleHeight+self.bounds.size.width, self.bounds.size.width, 30*[_timeline.comments count])];
    [_commentTable setFrame:CGRectMake(0, 0, self.bounds.size.width, 30*[_timeline.comments count])];
}
- (void)setLikeLabelText{
    
    if ([_timeline.likes count]>0) {
        BOOL firstLike = YES;
        for (CCLike *like in _timeline.likes) {
            NSString *current = [_likeLabel text];
            if (firstLike) {
                [_likeLabel setText:[NSString stringWithFormat:@"❤ %@",like.userName]];
            }else{
                [_likeLabel setText:[NSString stringWithFormat:@"%@, %@",current,like.userName]];
            }
            firstLike = NO;
//            [_likeLabel addLinkToURL:[NSURL URLWithString:like.userID] withRange:[_likeLabel.text rangeOfString:like.userName]];
        }
    }
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reloadComments{
    if(!_comments){
        _comments = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [_comments removeAllObjects];
    for (CCComment * comment in _timeline.comments) {
        [_comments addObject:comment];
    }
    [_commentTable reloadData];
}

#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_comments count]>4) {
        return 4;
    }
    
    return [_comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//        static NSString *identifier = @"timelineCell";
//        TimelineCell *cell = [[TimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        [cell.profileImage setImage:[UIImage imageNamed:@"icon132"]];
//        [cell.userName setText:@"角色相机"];
//        [cell.photo setImage:[UIImage imageNamed:@"test.jpg"]];
//        [cell.photoTitle setTitle:@"#角色相机#" forState:UIControlStateNormal];
//        [cell.photoDes setText:@"我是一段描述"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        CCTimeLine *timeLine = (CCTimeLine*)[_timeLines objectAtIndex:indexPath.row];
//        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:timeLine.timelineUserImage] placeholderImage:nil];
//        [cell.userName setText:timeLine.timelineUserName];
//        [cell.photo sd_setImageWithURL:[NSURL URLWithString:timeLine.image_fullsize] placeholderImage:nil];
//        [cell.photoDes setText:timeLine.timelineDes];
//        
//        return cell;
 
    
    static NSString *identifier = @"TimelineCommentCell";
    TimelineCommentCell *cell = [[TimelineCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.comment = [_comments objectAtIndex:indexPath.row];

    [cell.userName setTitle:cell.comment.userName forState:UIControlStateNormal];
    [cell.commentLabel setText:cell.comment.comment];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TimelineCommentCell *commentCell = (TimelineCommentCell*)cell;
    [commentCell layoutCommentCell];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 30;
}
- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    switch(type){
        case MLEmojiLabelLinkTypeURL:
            NSLog(@"点击了链接%@",link);
            break;
        case MLEmojiLabelLinkTypePhoneNumber:
            NSLog(@"点击了电话%@",link);
            break;
        case MLEmojiLabelLinkTypeEmail:
            NSLog(@"点击了邮箱%@",link);
            break;
        case MLEmojiLabelLinkTypeAt:
            NSLog(@"点击了用户%@",link);
            break;
        case MLEmojiLabelLinkTypePoundSign:
            NSLog(@"点击了话题%@",link);
            break;
        default:
            NSLog(@"点击了不知道啥%@",link);
            break;
    }
    
}
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"点击了某个自添加链接%@",url);
    
}
#pragma mark - UIActionsheet Delegate
- (void)callMoreActionSheet{
    UIActionSheet *actionsheet;
    
    if ([_timeline.timelineUserID isEqualToString:CCamMemberID]) {
        actionsheet = [[UIActionSheet alloc] initWithTitle:@"我的照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"分享",@"保存", nil];
    }else{
        if ([_timeline.report isEqualToString:@"1"]) {
            actionsheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@的照片",_timeline.timelineUserName] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消举报" otherButtonTitles:@"分享",@"保存", nil];
        }else{
            actionsheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"%@的照片",_timeline.timelineUserName] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"分享",@"保存", nil];
        }
    }
    
    
    
    [actionsheet showInView:[[ViewHelper sharedManager] getCurrentVC].view];
    
}
- (void)callShare{
    NSArray* imageArray = @[_timeline.image_fullsize];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeImage];
 
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[@(SSDKPlatformTypeSinaWeibo),
                                         @(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline),
                                         @(SSDKPlatformSubTypeQQFriend),
                                         @(SSDKPlatformTypeFacebook)]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([_timeline.timelineUserID isEqualToString:CCamMemberID]) {
        switch (buttonIndex) {
            case 0:
                [self deletePhoto];
                break;
            case 1:
                [self callShare];
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
                if ([self.timeline.report isEqualToString:@"1"]) {
                    self.timeline.report = @"0";
                    [self cancelReportPhoto];
                }else{
                    self.timeline.report = @"1";
                    [self reportPhoto];
                }
                break;
            case 1:
                [self callShare];
            default:
                break;
        }
    }
}
- (void)deletePhoto{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSDictionary *parameters = @{@"workid" :photoID};
    [manager GET:CCamDeletePhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)reportPhoto{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSDictionary *parameters = @{@"workid" :photoID};
    [manager GET:CCamReportPhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"report %@:result %@",photoID,result);
        self.timeline.report = @"1";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.timeline.report = @"0";
    }];
}
- (void)cancelReportPhoto{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *photoID = _timeline.timelineID;
    NSDictionary *parameters = @{@"workid" :photoID};
    [manager GET:CCamCancelReportPhotoURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"cancel Report %@:result %@",photoID,result);
        self.timeline.report = @"0";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.timeline.report = @"1";
    }];
}
- (void)sharePhoto{
    
}
@end
