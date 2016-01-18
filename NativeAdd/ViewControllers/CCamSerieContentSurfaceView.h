//
//  CCamSerieContentSurfaceView.h
//  Unity-iPhone
//
//  Created by Karl on 2016/1/8.
//
//

#import <UIKit/UIKit.h>
#import <M13ProgressSuite/M13ProgressViewImage.h>

@interface CCamSerieContentSurfaceView : UIView
@property (nonatomic,strong) UIImageView *surfaceBG;
@property (nonatomic,strong) UIView *surfaceMask;
@property (nonatomic,strong) UIImageView *surfaceImage;
@property (nonatomic,strong) UIButton *surfaceButton;
@property (nonatomic,strong) M13ProgressViewImage *surfaceProgress;
@end
