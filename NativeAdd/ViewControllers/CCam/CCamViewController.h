//
//  CCamViewController.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import "KLViewController.h"
#import "AFViewShaker.h"

@interface CCamViewController : KLViewController

@property (nonatomic,strong) UICollectionView *segmentContentCollection;
@property (nonatomic,strong) UICollectionView *segmentCollection;
@property (nonatomic,strong) UICollectionView *serieCollection;
@property (nonatomic,strong) UICollectionView *serieContentCollection;
@property (nonatomic,strong) UICollectionView *stickerSetCollection;
@property (nonatomic,strong) UICollectionView *stickerSetContentCollection;
@property (nonatomic,strong) UICollectionView *filterCollection;
@property (nonatomic,strong) AFViewShaker *characterTitleShaker;

- (void)scrollToTargetSerie;
- (void)updateSerieCollection;
- (void)updateStickerSetCollection;
- (void)updateFilterCollection;
- (void)SetLightControlAppear;
- (void)SetLightControlDisappear;
- (void)setLightDirectionX:(CGFloat)x andY:(CGFloat)y;
- (void)setLightStrength:(CGFloat)strength;
- (void)setShadowStrength:(CGFloat)strength;
- (void)SetAnimationControlAppear;
- (void)setAnimationInfo:(NSString*)info;
- (void)SetAnimationControlDisappear;
- (void)setHeadDirectionAvilable:(BOOL)avilable X:(CGFloat)x andY:(CGFloat)y;
@end

