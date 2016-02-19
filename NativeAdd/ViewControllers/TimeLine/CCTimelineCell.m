//
//  CCTimelineCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/2/19.
//
//

#import "CCTimelineCell.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>

const CGFloat contentLabelFontSize = 15;
const CGFloat maxContentLabelHeight = 54;

@interface CCTimelineCell ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CCTimelineCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
