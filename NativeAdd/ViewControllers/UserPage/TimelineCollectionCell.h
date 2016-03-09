//
//  TimelineCollectionCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/3/2.
//
//

#import <UIKit/UIKit.h>
#import "CCTimeLine.h"

@interface TimelineCollectionCell : UICollectionViewCell
@property (nonatomic,strong) CCTimeLine *timeline;
@property (nonatomic,strong) UIImageView *photoImage;

@end
