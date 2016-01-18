//
//  KLCollectionViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/25.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLCollectionViewController.h"

@implementation KLCollectionViewController

- (KLCollectionView*)returnCollectionViewWithFrame:(CGRect)rect layout:(KLCollectionLayout*)layout layoutDelegate:(id<KLCollectionLayoutDelegate>)layoutDelegate backgroundColor:(UIColor*)backgroundColor contentInset:(UIEdgeInsets)contentInset scrollIndicatorInsets:(UIEdgeInsets)scrollIndicatorInsets delegate:(id<UICollectionViewDelegate>)delegate dataSource:(id<UICollectionViewDataSource>)dataSource cellClass:(nullable Class)cellClass Identifier:(NSString *)identifier parentView:(UIView*)parentView{
    
    layout.delegate  =layoutDelegate;

    KLCollectionView *collectionView = [[KLCollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    [collectionView setBackgroundColor:backgroundColor];
    [collectionView setContentInset:contentInset];
    [collectionView setScrollIndicatorInsets:scrollIndicatorInsets];
    [collectionView setDataSource:dataSource];
    [collectionView setDelegate:delegate];
    [collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
    [parentView addSubview:collectionView];
    
    return collectionView;
}

@end
