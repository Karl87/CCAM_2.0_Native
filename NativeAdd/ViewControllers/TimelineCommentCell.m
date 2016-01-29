//
//  TimelineCommentCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/20.
//
//

#import "TimelineCommentCell.h"
#import "Constants.h"

@implementation TimelineCommentCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_userName) {
            _userName = [UIButton buttonWithType:UIButtonTypeCustom];
            [_userName setFrame:CGRectZero];
            [_userName setBackgroundColor:[UIColor whiteColor]];
            [_userName setTitleColor:CCamRedColor forState:UIControlStateNormal];
            [_userName.titleLabel setFont:[UIFont boldSystemFontOfSize:11.0]];
            [self.contentView addSubview:_userName];
        }
        if (!_commentLabel) {
            _commentLabel = [[UILabel alloc] initWithFrame:self.bounds];
            [_commentLabel setText:@""];
            [_commentLabel setNumberOfLines:1];
            [_commentLabel setFont:[UIFont systemFontOfSize:11.0]];
            [_commentLabel setTextAlignment:NSTextAlignmentLeft];
            [_commentLabel setTextColor:CCamGrayTextColor];
            [_commentLabel setBackgroundColor:[UIColor clearColor]];
            [self.contentView addSubview:_commentLabel];
        }
    }
    return self;
}
- (void)layoutCommentCell{
    [_userName sizeToFit];
    [_userName setFrame:CGRectMake(10, (self.bounds.size.height-_userName.frame.size.height)/2, _userName.frame.size.width, _userName.frame.size.height)];
    [_commentLabel setFrame:CGRectMake(20+_userName.frame.size.width, 0, self.bounds.size.width-40-_userName.frame.size.width, self.bounds.size.height)];
    //    [_commentLabel setCenter:CGPointMake(_commentLabel.center.x, rect.size.height/2)];
    [_commentLabel setText:_comment.comment];
}
//- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
//    
//    [self layoutCommentCell];
//    
//    NSLog(@"%lu::%@",_comment.comment.length,_comment.comment);
//    NSLog(@"%@",[NSValue valueWithCGRect:_commentLabel.frame]);
//}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
