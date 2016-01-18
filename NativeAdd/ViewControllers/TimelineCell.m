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
            _cellBG = [[UIView alloc] initWithFrame:CGRectMake(5, 2, CCamViewWidth-10, CCamViewWidth-10)];
            [_cellBG setBackgroundColor:[UIColor whiteColor]];
            [_cellBG.layer setMasksToBounds:YES];
            [_cellBG.layer setCornerRadius:8.0];
            [self.contentView addSubview:_cellBG];
        }
        if(!_profileImage){
            _profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, profileSize, profileSize)];
            [_profileImage.layer setMasksToBounds:YES];
            [_profileImage.layer setCornerRadius:_profileImage.frame.size.height/2];
            [_cellBG addSubview:_profileImage];
        }
        
        if (!_userName) {
            _userName = [[UILabel alloc] initWithFrame:CGRectMake(20+profileSize, 5, self.bounds.size.width-30-profileSize, profileSize)];
            [_userName setTextColor:CCamGrayTextColor];
            [_userName setFont:[UIFont boldSystemFontOfSize:17.0]];
            [_cellBG addSubview:_userName];
        }
        
        if (!_photo) {
            _photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10+profileSize, _cellBG.bounds.size.width, _cellBG.bounds.size.width)];
            [_cellBG addSubview:_photo];
        }
        
        if (!_photoTitle) {
            _photoTitle = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoTitle setFrame:CGRectMake(10, 15+profileSize+_cellBG.bounds.size.width, 200, 30)];
            [_photoTitle setBackgroundColor:[UIColor whiteColor]];
            [_photoTitle setTitleColor:CCamRedColor forState:UIControlStateNormal];
            [_photoTitle.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [_cellBG addSubview:_photoTitle];
        }
        
        if (!_photoDes) {
            _photoDes = [[UILabel alloc] initWithFrame:CGRectMake(10, 50+profileSize+_cellBG.bounds.size.width, _cellBG.bounds.size.width-20, 20)];
            [_photoDes setFont:[UIFont systemFontOfSize:11.0]];
            [_photoDes setTextColor:CCamGrayTextColor];
            [_photoDes setTextAlignment:NSTextAlignmentLeft];
            [_cellBG addSubview:_photoDes];
        }
        
        if (!_photoInput) {
            _photoInput = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoInput setFrame:CGRectMake(10, 75+profileSize+_cellBG.bounds.size.width, 30, 30)];
            [_photoInput setTitle:@"I" forState:UIControlStateNormal];
            [_photoInput setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
            [_cellBG addSubview:_photoInput];
        }
        
        if (!_photoLike) {
            _photoLike  = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoLike setFrame:CGRectMake(50, 75+profileSize+_cellBG.bounds.size.width, 30, 30)];
            [_photoLike setTitle:@"L" forState:UIControlStateNormal];
            [_photoLike setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
            [_cellBG addSubview:_photoLike];
        }
        
        if (!_photoMore) {
            _photoMore = [UIButton buttonWithType:UIButtonTypeCustom];
            [_photoMore setFrame:CGRectMake(_cellBG.bounds.size.width-40, 75+profileSize+_cellBG.bounds.size.width, 30, 30)];
            [_photoMore setTitle:@"M" forState:UIControlStateNormal];
            [_photoMore setTitleColor:CCamGrayTextColor forState:UIControlStateNormal];
            [_cellBG addSubview:_photoMore];
        }
        
        if (!_likeView) {
            _likeView = [[UIView alloc] initWithFrame:CGRectMake(0, 110+profileSize+_cellBG.bounds.size.width, _cellBG.bounds.size.width, 44)];
            [_cellBG addSubview:_likeView];
            UIView *divier = [[UIView alloc] initWithFrame:CGRectMake(10, 0, _likeView.bounds.size.width-20, 1)];
            [divier setBackgroundColor:CCamPhotoSegLightGray];
            [_likeView addSubview:divier];
        }
        
        if (!_messageView) {
            _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 154+profileSize+_cellBG.bounds.size.width, _cellBG.bounds.size.width, 44)];
            [_cellBG addSubview:_messageView];
            UIView *divier = [[UIView alloc] initWithFrame:CGRectMake(10, 0, _likeView.bounds.size.width-20, 1)];
            [divier setBackgroundColor:CCamPhotoSegLightGray];
            [_messageView addSubview:divier];
        }
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    [_cellBG setFrame:CGRectMake(5, 2, CCamViewWidth-10, 154+30+CCamViewWidth-10+44)];
    [_profileImage setFrame:CGRectMake(10, 5, profileSize, profileSize)];
    [_userName setFrame:CGRectMake(20+profileSize, 5, self.bounds.size.width-30-profileSize, profileSize)];
    [_photo setFrame:CGRectMake(0, 10+profileSize, _cellBG.bounds.size.width, _cellBG.bounds.size.width)];
    [_photoTitle setFrame:CGRectMake(10, 15+profileSize+_cellBG.bounds.size.width, 200, 30)];
    [_photoLike setFrame:CGRectMake(50, 75+profileSize+_cellBG.bounds.size.width, 30, 30)];
    [_photoMore setFrame:CGRectMake(_cellBG.bounds.size.width-40, 75+profileSize+_cellBG.bounds.size.width, 30, 30)];
    [_likeView setFrame:CGRectMake(0, 110+profileSize+_cellBG.bounds.size.width, _cellBG.bounds.size.width, 44)];
    [_messageView setFrame:CGRectMake(0, 154+profileSize+_cellBG.bounds.size.width, _cellBG.bounds.size.width, 44)];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
