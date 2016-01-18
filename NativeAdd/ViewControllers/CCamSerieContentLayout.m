//
//  CCamSerieContentLayout.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/28.
//
//

#import "CCamSerieContentLayout.h"

@interface CCamSerieContentLayout ()

@property (nonatomic, assign) CGSize frameSize;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) NSInteger cellCount;

@end

@implementation CCamSerieContentLayout

- (id)init{
    self = [super init];
    if (self) {
//        NSLog(@"init");
        
        
        
        
        self.minimumLineSpacing = 0.0;
        self.minimumInteritemSpacing = 0.0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
    }
    return self;
}
-(void)prepareLayout
{
//    NSLog(@"Prepare layout!");
    
    _frameSize = self.collectionView.frame.size;
    self.itemSize = CGSizeMake(_frameSize.width/5, _frameSize.width/5);
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    
    long time;
    if (_cellCount%10 == 0) {
        time = _cellCount/10;
    }else{
        time = _cellCount/10+1;
    }
    
    _contentSize = CGSizeMake(time*_frameSize.width, _frameSize.height);
//    NSLog(@"%@",[NSValue valueWithCGSize:_frameSize]);
//    NSLog(@"%ld",(long)_cellCount);
//    NSLog(@"%@",[NSValue valueWithCGSize:_contentSize]);
    
}
-(CGSize)collectionViewContentSize
{
//    NSLog(@"collectionViewContentSize");
    return _contentSize;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = self.itemSize;
    NSInteger i = path.row%10;
    NSInteger j = path.row/10;
    if (i<5) {
        attributes.center = CGPointMake(self.itemSize.width/2+i*self.itemSize.width+j*_frameSize.width, self.itemSize.height/2);
    }else{
        attributes.center = CGPointMake(self.itemSize.width/2+(i-5)*self.itemSize.width+j*_frameSize.width, self.itemSize.height*3/2);
    }
    
    return attributes;
}
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < self.cellCount; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

@end
