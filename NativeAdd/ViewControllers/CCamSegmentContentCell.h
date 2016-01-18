//
//  CCamSegmentContentCell.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import <UIKit/UIKit.h>

@interface CCamSegmentContentCell : UICollectionViewCell
@property (nonatomic,strong) UIButton *callSeriesButton;
@property (nonatomic,strong) UICollectionView *serieCollection;
@property (nonatomic,strong) UICollectionView *serieContentCollection;
@property (nonatomic,strong) UICollectionView *stickerSetCollection;
@property (nonatomic,strong) UICollectionView *stickerSetContentCollection;
@property (nonatomic,strong) UICollectionView *filterCollection;
@property (nonatomic,strong) UISlider *filterSlider;
@property (nonatomic,strong) UIView *controlView;
@property (nonatomic,strong) UIView *eraseView;
@property (nonatomic,strong) UILabel *eraseTranLabel;
@property (nonatomic,strong) UILabel *eraseZoneLabel;
@property (nonatomic,strong) UISwitch *eraseTranSwitch;
@property (nonatomic,strong) UISwitch *eraseZoneSwitch;
@property (nonatomic,strong) UISlider *eraseBrushSlider;
@property (nonatomic,strong) UIButton *eraserResetButton;
@end
