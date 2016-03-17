//
//  CCamSerieContentCell.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import "CCamSerieContentCell.h"
#import "CCamHelper.h"
#import "Constants.h"
#import "CCObject.h"
#import "CCCharacter.h"
#import "CCAnimation.h"
#import "CCamCharacterCell.h"
#import "CCamAnimationCell.h"
#import "CCamPlaceholderCell.h"
#import "CCamSerieContentLayout.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <pop/POP.h>

#import <MBProgressHUD/MBProgressHUD.h>

#import "UIColor+FlatColors.h"

@implementation CCamSerieContentCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _characterInfos = [[NSMutableArray alloc] initWithCapacity:0];
        [self setClipsToBounds:YES];
        [self setBackgroundColor:CCamExLightGrayColor];
        
        if (_countObj == nil) {
            _countObj = [[CCObject alloc] init];
            _countObj.number = 0;
        }
        
        if (_characterCollection == nil) {
            UICollectionViewFlowLayout *layout = [[CCamSerieContentLayout alloc] init];
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.tag = CCamCharacterCollectionView;
            [collectionView setBackgroundColor:CCamExLightGrayColor];
            [collectionView setDelegate:self];
            [collectionView setDataSource:self];
            [collectionView setFrame:CGRectMake(15, 10, self.bounds.size.width-30, (self.bounds.size.width-30)/5*2)];
            [collectionView registerClass:[CCamCharacterCell class] forCellWithReuseIdentifier:@"characterCell"];
            [collectionView registerClass:[CCamAnimationCell class] forCellWithReuseIdentifier:@"animationCell"];
            [collectionView registerClass:[CCamPlaceholderCell class] forCellWithReuseIdentifier:@"placeholderCell"];
            [collectionView setBounces:NO];
            [collectionView setShowsHorizontalScrollIndicator:NO];
            [collectionView setShowsVerticalScrollIndicator:NO];
            [collectionView setPagingEnabled:YES];
            [self.contentView addSubview:collectionView];
            _characterCollection = collectionView;
        }
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
        if (_surfaceView == nil) {
            _surfaceView = [[CCamSerieContentSurfaceView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
            [self.contentView addSubview:_surfaceView];
            [_surfaceView setHidden:YES];
            [_surfaceView.surfaceButton addTarget:self action:@selector(downloadFirstCharacter) forControlEvents:UIControlEventTouchUpInside];
        }

    }
    return self;
}
- (void)reloadCharacters{
    [_characterInfos removeAllObjects];
    
    _countObj.number = 0;
    
    for (CCCharacter *character in _serie.characters) {
        if ([[FileHelper sharedManager] checkCharacterExist:character]) {
            NSLog(@"%lu",(unsigned long)[character.animations count]);
            for (CCAnimation *animation in character.animations) {
                if ([animation.type isEqualToString:@"pose"]) {
                    _countObj.number++;
                    [_characterInfos addObject:animation];
//                    [_characterInfos insertObject:animation atIndex:0];
                }
            }
        }else{
            [_characterInfos addObject:character];
        }
    }
    
    [_characterCollection reloadData];
    
    
    if ([_characterInfos count]%10 != 0) {
        [_pageControl setNumberOfPages:[_characterInfos count]/10+1];
    }else{
        [_pageControl setNumberOfPages:[_characterInfos count]/10];
    }
    
    [_pageControl setCurrentPage:_characterCollection.contentOffset.x/_characterCollection.bounds.size.width
     ];
    
}
- (void)downloadFirstCharacter{
    CCCharacter *character = [_characterInfos firstObject];
    [[DataHelper sharedManager]updateAnimationInfo:character];
//    [_surfaceView.surfaceButton setHidden:YES];
    [_surfaceView.surfaceButton setEnabled:NO];
    [_surfaceView.surfaceProgress setHidden:NO];
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
#pragma mark - 
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl.currentPage = _characterCollection.contentOffset.x/_characterCollection.bounds.size.width;

}

#pragma mark - UICollectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == CCamCharacterCollectionView) {
        return CGSizeMake(collectionView.bounds.size.width/5, collectionView.bounds.size.width/5);
    }
    
    return CGSizeZero;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    if (collectionView.tag == CCamCharacterCollectionView) {return 2.0;}
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    if (collectionView.tag == CCamCharacterCollectionView) {return 2.0;}
    
    return 0.0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_characterInfos count];
}
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell isKindOfClass:[CCamCharacterCell class]]) {
//        CCamCharacterCell *cCell = (CCamCharacterCell*)cell;
//        NSLog(@"%f",cCell.downloadProgress.progress);
//        [cCell.downloadProgress setHidden:YES];
//    }
//}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer;
        if ([[_characterInfos objectAtIndex:indexPath.row] isKindOfClass:[CCCharacter class]]) {
            cellIdentifer= @"characterCell";
            CCamCharacterCell *characterCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
            CCCharacter *character = [_characterInfos objectAtIndex: indexPath.row];
            characterCell.character = character;
            
            characterCell.downloadProgress.tag = 8000+[character.characterID intValue];
            
            if ([[DownloadHelper sharedManager].downloadInfos objectForKey:[NSString stringWithFormat:@"Character%@",character.characterID]]) {
                NSString *progress =[[DownloadHelper sharedManager].downloadInfos objectForKey:[NSString stringWithFormat:@"Character%@",character.characterID]];
                [characterCell.downloadProgress setProgress:[progress floatValue] animated:NO];
                [characterCell.downloadProgress setHidden:NO];
                [characterCell.stateImage setHidden:YES];
            }else{
                [characterCell.downloadProgress setProgress:0.0 animated:NO];
                [characterCell.downloadProgress setHidden:YES];
                [characterCell.stateImage setHidden:NO];
            }
            
//            NSLog(@"%f",characterCell.downloadProgress.progress);
//            [[NSNotificationCenter defaultCenter] addObserver:characterCell selector:@selector(refreshProgress) name:character.characterID object:nil];
            
//            [characterCell layoutCharacterCell];
            
            [characterCell.characterImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,characterCell.character.image_List]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL){
                POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
                ani.fromValue = [NSNumber numberWithFloat:0.0];
                ani.toValue = [NSNumber numberWithFloat:1.0];
                ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                ani.duration = 0.25;
                [characterCell.characterImage pop_addAnimation:ani forKey:@"alphaAnimation"];
            }];
            
            if ([[FileHelper sharedManager] checkCharacterExist:character]) {
                //                [_stateLabel setText:@"已下载"];
            }else{
                if ([[FileHelper sharedManager] checkCharacterUpdate:character]) {
                    //                    [_stateLabel setText:@"更新"];
                }else{
                    [characterCell.stateImage setImage:[UIImage imageNamed:@"characterDownloadIcon"]];
                    //                    [_stateLabel setText:@"下载"];
                }
            }

            
            return characterCell;
        }else if ([[_characterInfos objectAtIndex:indexPath.row] isKindOfClass:[CCAnimation class]]) {
            
            cellIdentifer= @"animationCell";
            CCamAnimationCell *animationCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
            CCAnimation *animation = [_characterInfos objectAtIndex: indexPath.row];
            animationCell.animation = animation;
            
            if(!animationCell.animationImage){
                animationCell.animationImage = [[UIImageView alloc] initWithFrame:CGRectMake(animationCell.bounds.size.width/8, animationCell.bounds.size.height/8, animationCell.bounds.size.width*3/4, animationCell.bounds.size.height*3/4)];
                [animationCell.animationImage setBackgroundColor:[UIColor clearColor]];
                [animationCell.animationImage setContentMode:UIViewContentModeScaleAspectFill];
                [animationCell.animationImage setClipsToBounds:YES];
                [animationCell.contentView addSubview:animationCell.animationImage];
            }
            
            if (!animationCell.mask) {
                animationCell.mask = [UIView new];
                [animationCell.mask setFrame:animationCell.animationImage.frame];
                [animationCell.contentView addSubview:animationCell.mask];
                [animationCell.mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.6]];
                [animationCell.mask setHidden:YES];
            }
            
            if (!animationCell.loading) {
                animationCell.loading = [UIActivityIndicatorView new];
                [animationCell.loading setFrame:CGRectMake(0, 0, 44, 44)];
                [animationCell.contentView addSubview:animationCell.loading];
                [animationCell.loading setCenter:animationCell.contentView.center];
                [animationCell.loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
                [animationCell.loading setTintColor:CCamRedColor];
                animationCell.loading.hidesWhenStopped = YES;
            }
            
            [animationCell.animationImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",animationCell.animation.image]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL){
                POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
                ani.fromValue = [NSNumber numberWithFloat:0.0];
                ani.toValue = [NSNumber numberWithFloat:1.0];
                ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                ani.duration = 0.25;
                [animationCell.animationImage pop_addAnimation:ani forKey:@"alphaAnimation"];
            }];
            return animationCell;
        }else if ([[_characterInfos objectAtIndex:indexPath.row] isKindOfClass:[CCObject class]]) {
            cellIdentifer= @"placeholderCell";
            CCamPlaceholderCell *placeholderCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
            return placeholderCell;
        }
  
    
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_characterInfos objectAtIndex:indexPath.row] isKindOfClass:[CCCharacter class]]){
        if (![[FileHelper sharedManager] checkCharacterExist:[_characterInfos objectAtIndex:indexPath.row]]) {
            CCamCharacterCell * cell = (CCamCharacterCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section]];
            if (cell.downloadProgress.hidden) {
                [cell.stateImage setHidden:YES];
                [cell.downloadProgress setHidden:NO];
                [[DataHelper sharedManager]updateAnimationInfo:cell.character];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Babel(@"请稍候") message:Babel(@"资源文件正在下载") delegate:nil cancelButtonTitle:Babel(@"确定") otherButtonTitles:nil];
                [alert show];
            }
        }
    }else if ([[_characterInfos objectAtIndex:indexPath.row] isKindOfClass:[CCAnimation class]]){
        
        CCamAnimationCell * cell = (CCamAnimationCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row inSection:indexPath.section]];
        [cell UILoadingCharacter];
//
        
        CCAnimation * cellAnimation = (CCAnimation*)[_characterInfos objectAtIndex:indexPath.row];
        CCCharacter * cellCharacter = [[CoreDataHelper sharedManager] getCharacter:cellAnimation.characterID];
                
        NSLog(@"动画名:%@，动画ID:%@,角色名称:%@,角色ID:%@,系列名称:%@,系列ID:%@",cellAnimation.nameCN,cellAnimation.animationID,cellAnimation.character.nameCN,cellAnimation.character.characterID,cellAnimation.character.serie.nameCN,cellAnimation.character.serie.serieID);
        
        NSLog(@"系列区域信息:%@",cellAnimation.character.serie.regionInfo);
        NSLog(@"系列区域类型:%@",cellAnimation.character.serie.regionType);
        
        NSLog(@"角色区域类型:%@",cellAnimation.character.regionType);
        NSLog(@"角色区域信息:%@",cellAnimation.character.regionInfo);

        NSString *region = [[AuthorizeHelper sharedManager] getUserZone];
        NSArray * regionArray = [cellAnimation.character.serie.regionInfo componentsSeparatedByString:@","];
        
        if([[[AuthorizeHelper sharedManager] getUserGroup] isEqualToString:@"0"]||[[[AuthorizeHelper sharedManager] getUserGroup] isEqualToString:@"ug0"]){
            if([cellAnimation.character.serie.regionType isEqualToString:@"include"]){
                
                if ([regionArray indexOfObject:region]==NSNotFound) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[DataHelper sharedManager].ccamVC.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText = Babel(@"管理员忽略版权地区限制");
                    [hud hide:YES afterDelay:2.0];
                }
            }else if ([cellAnimation.character.serie.regionType isEqualToString:@"exclude"]){
                if ([regionArray indexOfObject:region]!=NSNotFound) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[DataHelper sharedManager].ccamVC.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText = Babel(@"管理员忽略版权地区限制");
                    [hud hide:YES afterDelay:2.0];
                }
            }
        }else{
            if([cellAnimation.character.serie.regionType isEqualToString:@"include"]){
                
                if ([regionArray indexOfObject:region]==NSNotFound) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[DataHelper sharedManager].ccamVC.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText = Babel(@"由于版权原因,该角色无法在您所在的地区使用");
                    [hud hide:YES afterDelay:2.0];
                    return;
                }
            }else if ([cellAnimation.character.serie.regionType isEqualToString:@"exclude"]){
                if ([regionArray indexOfObject:region]!=NSNotFound) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[DataHelper sharedManager].ccamVC.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.detailsLabelText =Babel(@"由于版权原因,该角色无法在您所在的地区使用");
                    [hud hide:YES afterDelay:2.0];
                    return;
                }
            }
        }
        
        NSString *mPath = [NSString stringWithFormat:@"file://%@",[[FileHelper sharedManager] getCharacterFilePath:cellCharacter]];
        NSString *mSerieID = cellCharacter.serieID;
        NSString *mCharacterID = cellCharacter.characterID;
        NSString *mSelectPose = cellAnimation.clipName;
        NSString *mSelectFace = cellAnimation.poseFace;
        NSMutableArray *mPoseList = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *mFaceList = [[NSMutableArray alloc] initWithCapacity:0];
        for (CCAnimation*animation in cellCharacter.animations) {
            if ([animation.type isEqualToString:@"pose"]) {
                [mPoseList addObject:animation.clipName];
            }else if ([animation.type isEqualToString:@"face"]){
                [mFaceList addObject:animation.clipName];
            }
        }
        NSMutableDictionary * animationJson = [[NSMutableDictionary alloc] init];
        [animationJson setObject:mPath forKey:@"mPath"];
        [animationJson setObject:mSerieID forKey:@"mSerieID"];
        [animationJson setObject:mCharacterID forKey:@"mCharacterID"];
        [animationJson setObject:mSelectPose forKey:@"mSelectPose"];
        [animationJson setObject:mSelectFace forKey:@"mSelectFace"];
        [animationJson setObject:mPoseList forKey:@"mPoseList"];
        [animationJson setObject:mFaceList forKey:@"mFaceList"];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:animationJson options:0 error:nil];
        NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",jsonString);
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"加载模型" message:jsonString delegate:nil cancelButtonTitle:@"哦" otherButtonTitles: nil];
//        [alert show];
        UnitySendMessage("_plantFormInteractions", "OnClickACharacter", jsonString.UTF8String);
        
    }
}

@end
