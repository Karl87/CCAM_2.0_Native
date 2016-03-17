//
//  CCamSubmitContestCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/5.
//
//

#import <UIKit/UIKit.h>

@interface CCamSubmitContestCell : UITableViewCell
@property (nonatomic,strong) UIView *cellBG;
@property (nonatomic,strong) UIView *cellSelBG;
@property (nonatomic,strong) UIButton *cellButton;
- (void)layoutCell;
@end
