//
//  TimelineTopCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/1/13.
//
//

#import "TimelineTopCell.h"
#import "Constants.h"
@implementation TimelineTopCell

- (void)drawRect:(CGRect)rect{
    [_message setFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (_message == nil) {
            _message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            [_message setFont:[UIFont systemFontOfSize:11.]];
            [_message setTextAlignment:NSTextAlignmentCenter];
            [_message setTextColor:CCamGrayTextColor];
            [self.contentView addSubview:_message];
        }
 
    }
    return self;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
