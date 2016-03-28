//
//  KLCollectionLayout.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/19.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLCollectionLayout.h"
#import "Constants.h"

@interface KLCollectionLayout (){
    CGSize cvSize;
    CGPoint cvCenter;
}

@property (nonatomic,strong) NSMutableArray *attributeArray;
@property (nonatomic,strong) NSMutableDictionary *maxYDictionary;

@end

@implementation KLCollectionLayout

- (instancetype) init{
    self = [super init];
    if (self) {
        self.columnCount = 2;
        self.columnMargin = 2;
        self.rowMargin = 2;
        self.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2);
    }
    return  self;
}
- (NSMutableDictionary*)maxYDictionary{
    if (!_maxYDictionary) {
        _maxYDictionary = [NSMutableDictionary dictionary];
        for (int i =0; i<self.columnCount; i++) {
            NSString*column = [NSString stringWithFormat:@"%d",i];
            self.maxYDictionary[column] = @"0";
        }
    }
    return _maxYDictionary;
}
- (NSMutableArray*)attributeArray{
    if (!_attributeArray) {
        _attributeArray = [NSMutableArray array];
    }
    return _attributeArray;
}
#pragma mark
- (void)prepareLayout{
    cvSize = self.collectionView.frame.size;
    cvCenter = CGPointMake(cvSize.width / 2.0, cvSize.height / 2.0);
    
    for (int i = 0; i<self.columnCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        self.maxYDictionary[column] = @(self.sectionInset.top);
    }
    [self.attributeArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributeArray addObject:attributes];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:count inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath];
    [self.attributeArray addObject:attributes];
}
-(CGSize)collectionViewContentSize{
    __block NSString *maxColumn = @"0";
    [self.maxYDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * stop) {
        if ([maxY floatValue] > [self.maxYDictionary[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDictionary[maxColumn] floatValue] + self.sectionInset.bottom);
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __block NSString *miniColumn = @"0";
    [self.maxYDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * stop) {
        if ([maxY floatValue] < [self.maxYDictionary[miniColumn] floatValue]) {
            miniColumn = column;
        }
        
    }];
    
    //计算frame
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - self.sectionInset.left - self.sectionInset.right - self.columnMargin * (self.columnCount - 1))/self.columnCount;
    CGFloat height = [self.delegate collectionLayout:self heightForWidth:width indexPath:indexPath];
    CGFloat x = self.sectionInset.left + (width + self.columnMargin)*[miniColumn intValue];
    CGFloat y = [self.maxYDictionary[miniColumn] floatValue] + self.rowMargin;
    self.maxYDictionary[miniColumn] = @(height + y);
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(x, y, width, height);
    
    
    return attr;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attributeArray;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    attributes.size = CGSizeMake(CCamViewWidth, 44);
    if([elementKind isEqual:UICollectionElementKindSectionFooter])
    {
        attributes.center = CGPointMake(cvSize.width/2,self.collectionView.contentSize.height+22);
    }
    
    return attributes;
}
@end
