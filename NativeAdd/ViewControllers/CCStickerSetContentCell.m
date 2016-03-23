//
//  CCStickerSetContentCell.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/29.
//
//

#import "CCStickerSetContentCell.h"
#import "Constants.h"
#import "CCSticker.h"
#import "CCamSerieContentLayout.h"
#import "CCStickerCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <pop/POP.h>
#import "CCamHelper.h"

@implementation CCStickerSetContentCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _stickerInfos = [[NSMutableArray alloc] initWithCapacity:0];
        [self setClipsToBounds:YES];
        [self setBackgroundColor:CCamExLightGrayColor];
    }
    return self;
}
- (void)reloadStickers{
    [_stickerInfos removeAllObjects];
    
    for (CCSticker *sticker in _stickerSet.stickers) {
        [_stickerInfos addObject:sticker];
    }
    
    if (_stickerCollection == nil) {
        CCamSerieContentLayout *layout = [[CCamSerieContentLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.tag = CCamStickerCollectionView;
        [collectionView setBackgroundColor:CCamExLightGrayColor];
        [collectionView setDelegate:self];
        [collectionView setDataSource:self];
        [collectionView setFrame:CGRectMake(15, 10, self.bounds.size.width-30, (self.bounds.size.width-30)/5*2)];
        [collectionView registerClass:[CCStickerCell class] forCellWithReuseIdentifier:@"stickerCell"];
        [collectionView setBounces:NO];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView setPagingEnabled:YES];
        [self.contentView addSubview:collectionView];
        _stickerCollection = collectionView;
    }
    
    [_stickerCollection reloadData];
    
    if (_pageControl == nil) {
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
        pageControl.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-15);
        pageControl.numberOfPages =1;
        pageControl.currentPage = 0;
        pageControl.hidesForSinglePage = NO;
        [self.contentView addSubview:pageControl];
        _pageControl = pageControl;
        _pageControl.currentPageIndicatorTintColor = CCamPageSelectColor;
        _pageControl.pageIndicatorTintColor = CCamPageNormalColor;
    }
    if ([_stickerInfos count]%10 != 0) {
        [_pageControl setNumberOfPages:[_stickerInfos count]/10+1];
    }else{
        [_pageControl setNumberOfPages:[_stickerInfos count]/10];
    }
    
    [_pageControl setCurrentPage:_stickerCollection.contentOffset.x/_stickerCollection.bounds.size.width
     ];
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
#pragma mark -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = _stickerCollection.contentOffset.x/_stickerCollection.bounds.size.width;
    
}

#pragma mark - UICollectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == CCamStickerCollectionView) {
        return CGSizeMake(collectionView.bounds.size.width/5, collectionView.bounds.size.width/5);
    }
    
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_stickerInfos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer;
    if ([[_stickerInfos objectAtIndex:indexPath.row] isKindOfClass:[CCSticker class]]) {
        cellIdentifer= @"stickerCell";
        CCStickerCell *stickerCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
        CCSticker *sticker = [_stickerInfos objectAtIndex: indexPath.row];
        stickerCell.sticker = sticker;
        
        NSLog(@"%@",sticker.image_Preview);
        NSLog(@"%@",sticker.image_Res);
        
        stickerCell.downloadProgress.tag = 9000 + [sticker.stickerID intValue];
        
        if ([[DownloadHelper sharedManager].downloadInfos objectForKey:[NSString stringWithFormat:@"Sticker%@",sticker.stickerID]]) {
            NSString *progress =[[DownloadHelper sharedManager].downloadInfos objectForKey:[NSString stringWithFormat:@"Sticker%@",sticker.stickerID]];
            [stickerCell.downloadProgress setProgress:[progress floatValue] animated:NO];
            [stickerCell.downloadProgress setHidden:NO];
            [stickerCell.stateImage setHidden:YES];
        }else{
            [stickerCell.downloadProgress setProgress:0.0 animated:NO];
            [stickerCell.downloadProgress setHidden:YES];
            [stickerCell.stateImage setHidden:NO];
        }
            [stickerCell.stickerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,stickerCell.sticker.image_Preview]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL){
            POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            ani.fromValue = [NSNumber numberWithFloat:0.0];
            ani.toValue = [NSNumber numberWithFloat:1.0];
            ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            ani.duration = 0.25;
            [stickerCell.stickerImage pop_addAnimation:ani forKey:@"alphaAnimation"];
        }];
        
        if (![[FileHelper sharedManager] checkStickerExist:sticker]) {
            [stickerCell.stateImage setHidden:NO];
            [stickerCell.stateImage setImage:[UIImage imageNamed:@"characterDownloadIcon"]];
        }else{
            [stickerCell.stateImage setHidden:YES];
        }
        
        return stickerCell;
    }
    
    
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CCStickerCell * cell = (CCStickerCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section]];
    if (![[FileHelper sharedManager] checkStickerExist:cell.sticker]) {
        if (cell.downloadProgress.hidden) {
            [cell.stateImage setHidden:YES];
            [cell.downloadProgress setHidden:NO];
            [[DownloadHelper sharedManager] downloadSticker:cell.sticker];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Babel(@"请稍候") message:Babel(@"资源文件正在下载") delegate:nil cancelButtonTitle:Babel(@"确定") otherButtonTitles:nil];
            [alert show];
        }
    }else{
        
        CCStickerCell * cell = (CCStickerCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section]];
        [cell UILoadingSticker];
        
        CCSticker *sticker = cell.sticker;
        NSString *sticker_url = [[FileHelper sharedManager] getStickerFilePath:sticker];
        NSString *sticker_type = sticker.type;
        NSString *sticker_text = sticker.text;
        NSString *sticker_text_font = sticker.textFont;
        NSString *sticker_text_color = sticker.textColor;
        NSString *sticker_text_coordinates = sticker.text_Coordinates;
        NSString *sticker_text_size = sticker.textSize;
        
        NSMutableDictionary *stickerJson = [[NSMutableDictionary alloc] init];
        [stickerJson setObject:sticker_url forKey:@"sticker_url"];
        [stickerJson setObject:sticker_type forKey:@"sticker_type"];
        [stickerJson setObject:sticker_text forKey:@"sticker_text"];
        [stickerJson setObject:sticker_text_font forKey:@"sticker_text_font"];
        [stickerJson setObject:sticker_text_color forKey:@"sticker_text_color"];
        [stickerJson setObject:sticker_text_coordinates forKey:@"sticker_text_coordinates"];
        [stickerJson setObject:sticker_text_size forKey:@"sticker_text_size"];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:stickerJson options:0 error:nil];
        NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        UnitySendMessage(UnityController.UTF8String, "OnClickAPaster", jsonString.UTF8String);

    }
}
@end
