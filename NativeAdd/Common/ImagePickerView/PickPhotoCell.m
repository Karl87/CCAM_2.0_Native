//
//  CollectionViewCell.m
//  TestScrolls
//
//  Created by Karl on 2015/12/3.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "PickPhotoCell.h"
#import "Constants.h"

@implementation PickPhotoCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *selectedBG = [[UIView alloc] initWithFrame:self.bounds];
        [selectedBG setBackgroundColor:CCamRedColor];
        self.selectedBackgroundView = selectedBG;

    }
    return self;
}
@end
