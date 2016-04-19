//
//  TimelineCommentCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/20.
//
//
#define cellMinHeight 15.0

#import "TimelineCommentCell.h"
#import "Constants.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import "CCUserViewController.h"

@interface TimelineCommentCell ()
@property (nonatomic,strong) UIButton *userName;
@property (nonatomic,strong) UILabel *commentLabel;
@end
@implementation TimelineCommentCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpTimelineCommeCell];
    }
    return self;
}
- (void)setUpTimelineCommeCell{
    self.contentView.backgroundColor = [UIColor whiteColor];
//    _userName = [UIButton new];
//    [_userName setBackgroundColor:[UIColor whiteColor]];
//    [_userName setTitleColor:CCamRedColor forState:UIControlStateNormal];
//    [_userName.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
//    [_userName setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    _commentLabel = [UILabel new];
    [_commentLabel setNumberOfLines:0];
    [_commentLabel setBackgroundColor:[UIColor clearColor]];
    [_commentLabel setTextAlignment:NSTextAlignmentLeft];
    [_commentLabel setTextColor:CCamGrayTextColor];
    [_commentLabel setFont:[UIFont systemFontOfSize:13.0]];

    NSArray *views = @[_commentLabel];
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    UIView *contentView = self.contentView;
    
//    _userName.sd_layout
//    .leftSpaceToView(contentView,10)
//    .topSpaceToView(contentView,0)
//    .heightIs(cellMinHeight);
    
    _commentLabel.sd_layout
    .leftSpaceToView(contentView,10)
    .topSpaceToView(contentView,0)
    .rightSpaceToView(contentView,10).autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_commentLabel bottomMargin:11];
}
- (void)callUserPage{
    CCUserViewController *userpage = [[CCUserViewController alloc] init];
    userpage.userID = _comment.userID;
    userpage.vcTitle = _comment.userName;
    userpage.hidesBottomBarWhenPushed = YES;
    [self callOtherVC:userpage];
}
- (void)callOtherVC:(id)vc{
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    _parent.parent.navigationItem.backBarButtonItem=backItem;
    [_parent.parent.navigationController pushViewController:vc animated:YES];
}
- (void)setComment:(CCComment *)comment{
    _comment = comment;
//    [_userName addTarget:self action:@selector(callUserPage:) forControlEvents:UIControlEventTouchUpInside];
//    [_userName setTitle:_comment.userName forState:UIControlStateNormal];
//    [_userName sizeToFit];
//    _userName.sd_layout.widthIs(_userName.bounds.size.width+2);

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   %@",_comment.userName,_comment.comment]];
    [str addAttribute:NSForegroundColorAttributeName value:CCamRedColor range:NSMakeRange(0,_comment.userName.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13.0] range:NSMakeRange(0,_comment.userName.length)];
//    [str addAttribute:NSForegroundColorAttributeName value:CCamGrayTextColor range:NSMakeRange(_comment.userName.length,str.length-1)];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(_comment.userName.length,str.length-1)];

    [_commentLabel setAttributedText:str];
    _commentLabel.sd_layout.leftSpaceToView(_userName,10);//.minHeightIs(cellMinHeight).maxHeightIs(44);
}

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    [self callUserPage];
    // Configure the view for the selected state
}

@end
