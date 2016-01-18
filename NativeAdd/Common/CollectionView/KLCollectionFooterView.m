//
//  KLCollectionFooterView.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/25.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLCollectionFooterView.h"

@implementation KLCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 20)];
        self.noteLabel.textColor = [UIColor yellowColor];
        
        
        [self addSubview:self.noteLabel];
        
    }
    return self;
}

@end
