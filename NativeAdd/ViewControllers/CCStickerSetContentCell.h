//
//  CCStickerSetContentCell.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import <UIKit/UIKit.h>
#import "CCStickerSet.h"
@interface CCStickerSetContentCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic,strong) CCStickerSet *stickerSet;
@property (nonatomic,strong) NSMutableArray *stickerInfos;
@property (nonatomic,strong) UICollectionView *stickerCollection;
@property (nonatomic,strong) UIPageControl *pageControl;

- (void)reloadStickers;
@end
