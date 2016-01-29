//
//  PushToViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/4.
//
//

#import "PushToViewController.h"
#import "KLPageControl.h"
#import "HoCell.h"
#import "CCamHelper.h"
#import "Constants.h"

#import "CCSerie.h"
#import "CCCharacter.h"
#import "CCAnimation.h"

@interface PushToViewController ()<UIScrollViewDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSInteger characters;
    NSInteger stickers;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) KLPageControl *pageControl;

@property (nonatomic,strong) NSMutableArray *segArray;
@property (nonatomic,strong) NSMutableArray *serieArray;
@property (nonatomic,strong) NSMutableArray *characterArray;
@property (nonatomic,strong) NSMutableArray *charactersAndAnimations;

@property (nonatomic,strong) UICollectionView *segCollection;
@property (nonatomic,strong) UICollectionView *contentCollection;
@property (nonatomic,strong) UICollectionView *seriesCollection;
@property (nonatomic,strong) UICollectionView *stickersCollection;
@property (nonatomic,strong) UICollectionView *charactersCollection;
@property (nonatomic,strong) UICollectionView *stickerCollection;
@end

@implementation PushToViewController
//- (void)getTotalSerieInfo{
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString *token = [[AuthorizeHelper sharedManager] getUserToken];
//    NSDictionary *parameters = @{@"token" :token,@"version":@""};
//    [manager POST:@"http://www.c-cam.cc/index.php/Api_new/Getmemberxml/get_xml.html" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%lu",(unsigned long)[responseObject length]);
//        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//        NSError *error;
//        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
//        [_serieArray removeAllObjects];
//        [_serieArray addObjectsFromArray:[receiveDic objectForKey:@"series"]];
//        [_seriesCollection reloadData];
//        [_characterArray removeAllObjects];
//        [_characterArray addObjectsFromArray:[[_serieArray objectAtIndex:0] objectForKey:@"characters"]];
//        [_charactersCollection reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    
//    }];
//}
//- (void)getCharacterDetailInfoWithID:(NSString*)characterID{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *parameters = @{@"character_id" :characterID};
//    [manager POST:@"http://www.c-cam.cc/index.php/Api_new/Index/get_animations_json.html" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%lu",(unsigned long)[responseObject length]);
//        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//    }];
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == _segCollection || collectionView == _contentCollection){
        return [_segArray count];
    }else if (collectionView == _seriesCollection){
        return [[DataHelper sharedManager].series count];
    }else if (collectionView == _stickersCollection){
        return [[DataHelper sharedManager].stickerSets count];
    }else if (collectionView == _charactersCollection){
        return [_charactersAndAnimations count];
    }else if (collectionView == _stickerCollection){
        return stickers;
    }
    return 0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(collectionView.contentOffset.x<indexPath.row*88){
//        [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x +88, 0) animated:YES];
//    }else if (collectionView.contentOffset.x>indexPath.row*88){
//        [collectionView setContentOffset:CGPointMake(collectionView.contentOffset.x -88, 0) animated:YES];
//    }
    
    if (collectionView == self.segCollection) {
        [self.contentCollection setContentOffset:CGPointMake(indexPath.row*self.view.bounds.size.width, 0) animated:YES];
    }else if (collectionView == self.seriesCollection){
        [_charactersAndAnimations removeAllObjects];
        CCSerie *serie = (CCSerie*)[[DataHelper sharedManager].series objectAtIndex:indexPath.row];
        for (CCCharacter* character in serie.characters) {
            for (CCAnimation*animation in character.animations) {
                [_charactersAndAnimations addObject:animation];
            }
        }
        for (CCCharacter* character in serie.characters) {
            [_charactersAndAnimations addObject:character];
        }
        NSLog(@"character count = %lu",(unsigned long)[_characterArray count]);
        [self.charactersCollection reloadData];
    }else if (collectionView == self.stickersCollection){
        stickers = indexPath.row+8;
        [self.stickerCollection reloadData];
    }else if (collectionView == self.charactersCollection){
        if ([[_charactersAndAnimations objectAtIndex:indexPath.row] isKindOfClass:[CCCharacter class]]) {
            CCCharacter *character = [_charactersAndAnimations objectAtIndex:indexPath.row];

            NSString *filePath = [NSString stringWithFormat:@"%@/CharacterCamera/S%@C%@/%@.assetbundle",CCamDocPath,character.serieID,character.characterID,character.version];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath isDirectory:NO]) {
                [[DataHelper sharedManager] updateAnimationInfo:character];
            }
        }else{
            NSLog(@"Click Animation");
        }
//        NSString *dirPath = [NSString stringWithFormat:@"%@/CharacterCamera/s%@c%@",CCamDocPath,[[_characterArray objectAtIndex:indexPath.row] objectForKey:@"serie_id"],[[_characterArray objectAtIndex:indexPath.row] objectForKey:@"character_id"]];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if (![fileManager fileExistsAtPath:dirPath isDirectory:YES]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Dir" message:dirPath delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        [self getCharacterDetailInfoWithID:[[_characterArray objectAtIndex:indexPath.row] objectForKey:@"character_id"]];
    }else if (collectionView == self.stickerCollection){
        stickers += 5;
        [self.stickerCollection reloadData];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer;
    if (collectionView == _segCollection) {
        cellIdentifer = @"segCell";
    }else if (collectionView == _contentCollection){
        cellIdentifer = @"contentCell";
    }else if (collectionView == _seriesCollection){
        cellIdentifer = @"serieCell";
    }else if (collectionView == _stickersCollection){
        cellIdentifer = @"stickersCell";
    }else if (collectionView == _charactersCollection){
        cellIdentifer = @"characterCell";
    }else if (collectionView == _stickerCollection){
        cellIdentifer = @"stickerCell";
    }
    HoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    
    if (collectionView == self.segCollection) {
        if (cell.label == nil) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
            [label setTextColor:[UIColor whiteColor]];
            [label setText:[_segArray objectAtIndex:indexPath.row]];
            [cell setBackgroundColor:CCamViewBackgroundColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:label];
            cell.label = label;
        }else{
            [cell.label setText:[_segArray objectAtIndex:indexPath.row]];
        }
        if (cell.selectView == nil) {
            UIView* view = [[UIView alloc] initWithFrame:cell.contentView.frame];
            [view setBackgroundColor:CCamGoldColor];
            cell.selectView = view;
            [cell setSelectedBackgroundView:cell.selectView];
        }
    }

    if (collectionView == self.contentCollection) {
        if (cell.label == nil) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
            [label setTextColor:[UIColor whiteColor]];
            [label setText:[_segArray objectAtIndex:indexPath.row]];
            [cell setBackgroundColor:CCamViewBackgroundColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:label];
            cell.label = label;
        }else{
            [cell.label setText:[_segArray objectAtIndex:indexPath.row]];
        }
        if (indexPath.row == 0) {
            if (self.seriesCollection == nil) {
                UICollectionViewFlowLayout *serieLayout=[[UICollectionViewFlowLayout alloc] init];
                [serieLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
                
                _seriesCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,cell.contentView.bounds.size.height-44,self.view.frame.size.width ,44) collectionViewLayout:serieLayout];
                [_seriesCollection registerClass:[HoCell class] forCellWithReuseIdentifier:@"serieCell"];
                [_seriesCollection setBackgroundColor:CCamViewBackgroundColor];
                [cell.contentView addSubview:_seriesCollection];
                
                [_seriesCollection setBounces:NO];
                [_seriesCollection setDataSource:self];
                [_seriesCollection setDelegate:self];
            }else{
                [_seriesCollection setHidden:NO];
            }
            if (self.charactersCollection == nil) {
                UICollectionViewFlowLayout *characterLayout=[[UICollectionViewFlowLayout alloc] init];
                [characterLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
                
                _charactersCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(5,5,cell.contentView.bounds.size.width-10 ,cell.contentView.bounds.size.height-44-10) collectionViewLayout:characterLayout];
                [_charactersCollection registerClass:[HoCell class] forCellWithReuseIdentifier:@"characterCell"];
                [_charactersCollection setBackgroundColor:CCamViewBackgroundColor];
                [cell.contentView addSubview:_charactersCollection];
                
                [_charactersCollection setBounces:NO];
                [_charactersCollection setDataSource:self];
                [_charactersCollection setDelegate:self];
                [_charactersCollection setPagingEnabled:YES];
            }else{
                [_charactersCollection setHidden:NO];
            }
        }else{
            [_seriesCollection setHidden:YES];
            [_charactersCollection setHidden:YES];
        }
        if (indexPath.row == 1) {
            if (self.stickersCollection == nil) {
                UICollectionViewFlowLayout *stickersLayout=[[UICollectionViewFlowLayout alloc] init];
                [stickersLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
                
                _stickersCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,cell.contentView.bounds.size.height-44,self.view.frame.size.width ,44) collectionViewLayout:stickersLayout];
                [_stickersCollection registerClass:[HoCell class] forCellWithReuseIdentifier:@"stickersCell"];
                [_stickersCollection setBackgroundColor:CCamViewBackgroundColor];
                [cell.contentView addSubview:_stickersCollection];
                
                [_stickersCollection setBounces:NO];
                [_stickersCollection setDataSource:self];
                [_stickersCollection setDelegate:self];
            }else{
                [_stickersCollection setHidden:NO];
            }
            if (self.stickerCollection == nil) {
                UICollectionViewFlowLayout *stickerLayout=[[UICollectionViewFlowLayout alloc] init];
                [stickerLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
                
                _stickerCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(5,5,cell.contentView.bounds.size.width-10 ,cell.contentView.bounds.size.height-44-10) collectionViewLayout:stickerLayout];
                [_stickerCollection registerClass:[HoCell class] forCellWithReuseIdentifier:@"stickerCell"];
                [_stickerCollection setBackgroundColor:CCamViewBackgroundColor];
                [cell.contentView addSubview:_stickerCollection];
                
                [_stickerCollection setBounces:NO];
                [_stickerCollection setDataSource:self];
                [_stickerCollection setDelegate:self];
                [_stickerCollection setPagingEnabled:YES];
            }else{
                [_stickerCollection setHidden:NO];
            }

        }else{
            [_stickerCollection setHidden:YES];
            [_stickersCollection setHidden:YES];
        }
    }
    
    if (collectionView == _seriesCollection || collectionView == _stickersCollection || collectionView == _charactersCollection || collectionView == _stickerCollection) {
        if (cell.label == nil) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
            [label setTextColor:[UIColor whiteColor]];
            if (collectionView == _seriesCollection) {
//                NSString * serieName =[[_serieArray objectAtIndex:indexPath.row] objectForKey:@"serie_name_cn"];
//                [label setText:serieName];
//                NSLog(@"%@",serieName);
                CCSerie *serie = (CCSerie*)[[DataHelper sharedManager].series objectAtIndex:indexPath.row];
                [label setText:serie.nameCN];
            
            }else if (collectionView == _stickersCollection){
                [label setText:[NSString stringWithFormat:@"G%ld",(long)indexPath.row]];

            }else if (collectionView == _charactersCollection){
                if ([[_charactersAndAnimations objectAtIndex:indexPath.row] isKindOfClass:[CCCharacter class]]) {
                    CCCharacter *character = [_charactersAndAnimations objectAtIndex:indexPath.row];
                    [label setText:character.nameCN];
                }else{
                    CCAnimation *animation = [_charactersAndAnimations objectAtIndex:indexPath.row];
                    [label setText:animation.clipName];
                }
                
                

            }else if (collectionView == _stickerCollection){
                [label setText:[NSString stringWithFormat:@"T%ld",(long)indexPath.row]];

            }
            [cell setBackgroundColor:CCamViewBackgroundColor];
            [label setTextAlignment:NSTextAlignmentCenter];
            [cell.contentView addSubview:label];
            cell.label = label;
        }else{
            if (collectionView == _seriesCollection) {
                CCSerie *serie = (CCSerie*)[[DataHelper sharedManager].series objectAtIndex:indexPath.row];
                [cell.label setText:serie.nameCN];
                
            }else if (collectionView == _stickersCollection){
                [cell.label setText:[NSString stringWithFormat:@"G%ld",(long)indexPath.row]];
                
            }else if (collectionView == _charactersCollection){
                if ([[_charactersAndAnimations objectAtIndex:indexPath.row] isKindOfClass:[CCCharacter class]]) {
                    CCCharacter *character = [_charactersAndAnimations objectAtIndex:indexPath.row];
                    [cell.label setText:character.nameCN];
                }else{
                    CCAnimation *animation = [_charactersAndAnimations objectAtIndex:indexPath.row];
                    [cell.label setText:animation.clipName];
                }
                
            }else if (collectionView == _stickerCollection){
                [cell.label setText:[NSString stringWithFormat:@"T%ld",(long)indexPath.row]];
                
            }
        }
    }
    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.segCollection) {
        return CGSizeMake((self.view.frame.size.width-3)/4, collectionView.bounds.size.height);
    }else if (collectionView == self.contentCollection){
        return CGSizeMake(self.view.frame.size.width-1, collectionView.bounds.size.height);
    }else if (collectionView == self.seriesCollection || collectionView == self.stickersCollection){
        return CGSizeMake(44., 44.);
    }else if (collectionView == self.charactersCollection || collectionView == self.stickerCollection){
        CGFloat size = (collectionView.bounds.size.height - 1)/2.0;
        return CGSizeMake(size,size);
    }
    
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}
#pragma mark-
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [_pageControl setCurrentPage:offset.x / bounds.size.width];
    NSLog(@"%f",offset.x / bounds.size.width);
}
- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = _scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[DataHelper sharedManager] updateSeriesInfo];
//    [self getTotalSerieInfo];
}
- (void)reloadInfo{
    [_seriesCollection reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    characters = 0;stickers = 0;
    
    _segArray = [[NSMutableArray alloc] initWithCapacity:0];
    [_segArray addObjectsFromArray:@[@"角色",@"大头贴",@"滤镜",@"擦除"]];
    
//    _serieArray = [[NSMutableArray alloc] initWithCapacity:0];
//    _characterArray = [[NSMutableArray alloc] initWithCapacity:0];

    _charactersAndAnimations = [[NSMutableArray alloc] initWithCapacity:0];
    
    UICollectionViewFlowLayout *segLayout=[[UICollectionViewFlowLayout alloc] init];
    [segLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _segCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64+self.view.frame.size.width,self.view.frame.size.width ,44) collectionViewLayout:segLayout];
    [_segCollection registerClass:[HoCell class] forCellWithReuseIdentifier:@"segCell"];
    
    [self.view addSubview:_segCollection];
    
    [_segCollection setBounces:NO];
    [_segCollection setDataSource:self];
    [_segCollection setDelegate:self];
    [_segCollection setScrollEnabled:NO];
    [_segCollection setBackgroundColor:CCamViewBackgroundColor];
//    [self collectionView:_segCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self collectionView:_segCollection didHighlightItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    UICollectionViewFlowLayout *contentLayout=[[UICollectionViewFlowLayout alloc] init];
    [contentLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _contentCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,44+64+self.view.frame.size.width,self.view.frame.size.width ,self.view.frame.size.height-44-64-self.view.frame.size.width) collectionViewLayout:contentLayout];
    [_contentCollection registerClass:[HoCell class] forCellWithReuseIdentifier:@"contentCell"];
    
    [self.view addSubview:_contentCollection];
    
    [_contentCollection setBounces:NO];
    [_contentCollection setDataSource:self];
    [_contentCollection setDelegate:self];
    [_contentCollection setScrollEnabled:NO];
    [_contentCollection setBackgroundColor:CCamViewBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadCharactersAndAnimations:(CCCharacter *)character{
    for (CCAnimation *animation in _charactersAndAnimations) {
        if ([animation.characterID isEqualToString:character.characterID]) {
            [_charactersAndAnimations removeObject:animation];
        }
    }
    for (CCCharacter*actor in _charactersAndAnimations) {
        if ([actor.characterID isEqualToString:character.characterID]) {
            [_charactersAndAnimations removeObject:actor];
        }
    }
    
    for (CCAnimation*animation in character.animations) {
        [_charactersAndAnimations insertObject:animation atIndex:0];
    }
    
    [_charactersAndAnimations addObject:character];
    [_charactersCollection reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
