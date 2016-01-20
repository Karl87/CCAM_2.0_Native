//
//  TimelineCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#define profileSize 30.0

#import "TimelineCell.h"
#import "Constants.h"

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
            [_userName setFont:[UIFont boldSystemFontOfSize:14.0]];
            [_userName setTextAlignment:NSTextAlignmentLeft];
            [_cellBG addSubview:_userName];
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
            [_cellBG addSubview:_photoMore];
        }
        
        if (!_likeView) {
            _likeView = [[UIView alloc] initWithFrame:CGRectZero];
            [_cellBG addSubview:_likeView];
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
            [_messageView addSubview:_commentTable];
        }
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [_cellBG setFrame:CGRectMake(5, 3, rect.size.width-10, rect.size.height-6)];
    [_profileImage setFrame:CGRectMake(10, 5, profileSize, profileSize)];
    [_userName setFrame:CGRectMake(20+profileSize, 5, rect.size.width-30-profileSize, profileSize)];
    [_photo setFrame:CGRectMake(0, 10+profileSize, rect.size.width, rect.size.width)];
    [_photoTitle setFrame:CGRectMake(10, 15+profileSize+rect.size.width, rect.size.width-20, 30)];
    
    
    [_photoInput setFrame:CGRectMake(0, 45+profileSize+rect.size.width, 40, 40)];
    [_photoLike setFrame:CGRectMake(40, 45+profileSize+rect.size.width,40,40)];
    [_photoMore setFrame:CGRectMake(rect.size.width-50, 45+profileSize+rect.size.width,40,40)];
    
    [_likeView setFrame:CGRectMake(0, 85+rect.size.width, rect.size.width, 44)];
    
    NSLog(@"%@",_timeline.comment);
    [_messageView setFrame:CGRectMake(0, 129+rect.size.width, rect.size.width, 30)];
    [_commentTable setFrame:CGRectMake(10, 5, _messageView.bounds.size.width, 44+120)];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - UITableView Delegate and Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.textLabel.text = @"Karl 哈哈哈哈哈哈哈哈哈啊！";
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 30;
}
@end
