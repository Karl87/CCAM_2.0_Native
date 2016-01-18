//
//  CCamSerieContentCell.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import <UIKit/UIKit.h>
#import "CCSerie.h"
#import "CCObject.h"
#import <M13ProgressSuite/M13ProgressViewImage.h>
#import "CCamSerieContentSurfaceView.h"
@interface CCamSerieContentCell : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (nonatomic,strong) CCSerie *serie;
@property (nonatomic,strong) NSMutableArray *characterInfos;
@property (nonatomic,strong) UICollectionView *characterCollection;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) CCamSerieContentSurfaceView *surfaceView;

@property (nonatomic,strong) NSNumber *number;
@property (nonatomic,strong)CCObject *countObj;
- (void)reloadCharacters;
@end
