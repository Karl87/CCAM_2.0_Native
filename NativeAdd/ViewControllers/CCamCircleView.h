//
//  CCamCircleView.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/14.
//
//

#import <UIKit/UIKit.h>

@protocol CCamCircleViewDelegat;

@interface CCamCircleView : UIView

@property (weak,nonatomic) id<CCamCircleViewDelegat>delegate;
@property (nonatomic,strong) UIImageView *circleBG;
@property (nonatomic,strong) UIImageView *circlePoint;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@end

@protocol CCamCircleViewDelegat <NSObject>
@optional
- (void)pointValueChanged:(CCamCircleView *)circle;
@end