//
//  KLCollectionViewController.h
//  CCamNativeKit
//
//  Created by Karl on 2015/11/25.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLViewController.h"
#import "KLCollectionView.h"
#import "KLCollectionLayout.h"
#import "KLCollectionCell.h"
#import "CCamRefreshHeader.h"
#import "CCamRefreshFooter.h"

@interface KLCollectionViewController : KLViewController

- (KLCollectionView*)returnCollectionViewWithFrame:(CGRect)rect layout:(KLCollectionLayout*)layout layoutDelegate:(id<KLCollectionLayoutDelegate>)layoutDelegate backgroundColor:(UIColor*)backgroundColor contentInset:(UIEdgeInsets)contentInset scrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets delegate:(id<UICollectionViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSource cellClass:(nullable Class)cellClass Identifier:(NSString *)identifier parentView:(UIView*)parentView;

@end


