//
//  KLCollectionLayout.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/19.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLCollectionLayout;

@protocol KLCollectionLayoutDelegate <NSObject>

@required

- (CGFloat)collectionLayout:(KLCollectionLayout*)layout heightForWidth:(CGFloat)width indexPath:(NSIndexPath*)indexPath;

@end

@interface KLCollectionLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat rowMargin;
@property (nonatomic, assign) CGFloat columnMargin;
@property (nonatomic, assign) CGFloat columnCount;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@property (nonatomic, weak) id<KLCollectionLayoutDelegate>delegate;

@end
