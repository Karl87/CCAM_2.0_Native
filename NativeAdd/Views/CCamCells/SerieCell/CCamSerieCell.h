//
//  CCamSerieCell.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import <UIKit/UIKit.h>
#import "CCSerie.h"

@interface CCamSerieCell : UICollectionViewCell
@property (nonatomic,strong) CCSerie *serie;
@property (nonatomic,strong) UIImageView *serieImage;
@end
