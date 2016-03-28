//
//  ImagePickerViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/4.
//
//

#import "KLImagePickerViewController.h"
#import "PickPhotoCell.h"
#import "AlbumCell.h"

#import <FastttCamera/FastttCamera.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ShowImageViewController.h"
#import "iOSBindingManager.h"
#import <pop/Pop.h>
#import "CCamViewController.h"

#import "CCamHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface KLImagePickerViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,FastttCameraDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL captureRunning;
    BOOL fitSize;
}
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, strong) ALAssetsGroup *album;

@property (nonatomic,strong) UIScrollView *albumBG;

@property (nonatomic,strong) UIView *albumNavi;
@property (nonatomic,strong) UIButton *albumNaviChoose;
@property (nonatomic,strong) UIButton *albumNaviClose;
@property (nonatomic,strong) UIButton *albumNaviContinue;

@property (nonatomic,strong) UIScrollView *albumImgBG;
@property (nonatomic,strong) UIImageView *albumImg;
@property (nonatomic,strong) UIButton *albumImgBtn;

@property (nonatomic,strong) UIView *albumToolBar;
@property (nonatomic,strong) UIButton *albumMoveBtn;
@property (nonatomic,strong) UIButton *albumImgRotateBtn;
@property (nonatomic,strong) UIButton *albumImgFitSizeBtn;

@property (nonatomic,strong) UITableView *albumCollection;
@property (nonatomic,strong) UICollectionView *photoCollection;

@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic,strong) NSMutableArray *albums;

@property (nonatomic, strong) FastttCamera *fastCamera;

@property (nonatomic,strong) UIView * captureBG;
@property (nonatomic,strong) UIView * captureButtonsBG;
@property (nonatomic,strong) UIButton *captureDeviceBtn;
@property (nonatomic,strong) UIButton *captureFlashBtn;
@property (nonatomic,strong) UIButton *showAlbumBtn;
@property (nonatomic,strong) UIButton *captureShupBtn;
@property (nonatomic,strong) UIButton *captureBtn;
@property (nonatomic,strong) UIImageView *captureShup;
@property (nonatomic,strong) UIView *captureEffect;
@property (nonatomic,assign) BOOL *autoLoadWhenDidAppear;
@end

@implementation KLImagePickerViewController

- (void)openCamera{
    if (_captureBG.hidden) {
        _captureBG.hidden = NO;
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue =[NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width, 0, _captureBG.frame.size.width, _captureBG.frame.size.height)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        anim.beginTime = CACurrentMediaTime();
        anim.duration = 0.25f;
        [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
            if(finish) {
                NSLog(@"!");
            }
        }];
        [_captureBG pop_addAnimation:anim forKey:@"position"];
    }
    
    if (!_fastCamera) {
        _fastCamera = [FastttCamera new];
        self.fastCamera.delegate = self;
        self.fastCamera.maxScaledDimension = 600.f;
        
        [self fastttAddChildViewController:self.fastCamera];
        [self.fastCamera.view setFrame:self.albumImgBG.frame];
        [self.fastCamera setCameraDevice:FastttCameraDeviceRear];
        [self.fastCamera setCameraFlashMode:FastttCameraFlashModeOff];
        [self.fastCamera setCameraTorchMode:FastttCameraTorchModeOff];
        
        if (!_captureShup) {
            _captureShup = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _fastCamera.view.frame.size.width, _fastCamera.view.frame.size.height)];
            [_captureShup setImage:[UIImage imageNamed:@"captureShup"]];
            [_captureShup setBackgroundColor:[UIColor clearColor]];
            [_captureShup setUserInteractionEnabled:NO];
            [_fastCamera.view addSubview:_captureShup];
            
        }
        
        if (!_captureEffect) {
            _captureEffect = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _fastCamera.view.frame.size.width, _fastCamera.view.frame.size.height)];
            [_captureEffect setBackgroundColor:[UIColor whiteColor]];
            [_captureEffect setHidden:YES];
            [_captureEffect setUserInteractionEnabled:NO];
            [_fastCamera.view addSubview:_captureEffect];
            
        }
        
    }else{
        
        if (self.fastCamera.view.hidden) {
            self.fastCamera.view.hidden = NO;
            [self.fastCamera startRunning];
        }
    }
}
- (void)setCaptureShupState{
    if (_captureShup) {
        _captureShup.hidden = !_captureShup.hidden;
    }
}
- (void)cameraController:(id<FastttCameraInterface>)cameraController didFinishCapturingImage:(FastttCapturedImage *)capturedImage
{
    NSLog(@"A photo was taken!");
    [self.fastCamera stopRunning];
    UIImageWriteToSavedPhotosAlbum(capturedImage.rotatedPreviewImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
//    [[iOSBindingManager sharedManager] saveImageToAlbum:capturedImage.rotatedPreviewImage];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = Babel(@"保存照片至系统相册");
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    hud.mode = MBProgressHUDModeText;
    if (error) {
        hud.labelText = Babel(@"保存照片失败");
        [hud hide:YES afterDelay:1.0];
        [self.fastCamera startRunning];
    }else{
        hud.labelText = Babel(@"保存照片成功");
        [hud hide:YES afterDelay:1.0];
        [self backToAlbum];
    }
}
- (void)getAlbumsData{
    [self.albums removeAllObjects];
    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:self.assetsFilter];
            if (group.numberOfAssets >0) {
                if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue]==ALAssetsGroupSavedPhotos){
                    [self.albums insertObject:group atIndex:0];
                    self.album = (ALAssetsGroup*)[self.albums objectAtIndex:0];
                    [_albumNaviChoose setTitle:[self.album valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
                    [self getPhotosWithAlbums:self.album];
                } else if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue]==ALAssetsGroupPhotoStream && self.albums.count>0){
                    [self.albums insertObject:group atIndex:1];
                } else {
                    [self.albums addObject:group];
                }
                NSLog(@"%ld",(unsigned long)self.albums.count);
            }
        }
        [_albumCollection reloadData];
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        //没权限
        
    };
    //显示的相册
    NSUInteger type = ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream |
    ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
    ALAssetsGroupFaces  ;
    
    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
    
}
- (void)getPhotosWithAlbums:(ALAssetsGroup*)album{
    [self.photos removeAllObjects];
    [self.photos addObject:[UIImage imageNamed:@"cameraPlaceholder"]];
    
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop) {
        if (asset){
            [self.photos insertObject:asset atIndex:1];
        }else if (self.photos.count > 0){
            NSLog(@"wow,images count is %lu",(unsigned long)self.photos.count);
            [_photoCollection reloadData];
            ALAsset* asset = (ALAsset*)[self.photos objectAtIndex:1];
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            UIImage *contentImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
            
            [_albumImg setImage:contentImage];
            [self resetAlbumChoosedImage];
        }
    };
    [self.album enumerateAssetsUsingBlock:resultsBlock];
    
    ALAsset* asset = (ALAsset*)[self.photos objectAtIndex:1];

    if ([asset isKindOfClass:[UIImage class]]) {
        [_showAlbumBtn setImage:(UIImage*)asset forState:UIControlStateNormal];
    }else{
        [_showAlbumBtn setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail] forState:UIControlStateNormal];
    }
    
}
#pragma mark - uicollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"call camera!");
        [self openCamera];
    }else{
        NSLog(@"change pic!");
        ALAsset* asset = (ALAsset*)[self.photos objectAtIndex:indexPath.row];
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        UIImage *contentImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
        
        [_albumImg setImage:contentImage];
        [self resetAlbumChoosedImage];
        [_albumBG setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifer ;
    
    if (indexPath.row == 0) {
        cellIdentifer= @"capturecell";
    }else{
        cellIdentifer= @"photocell";
    }
    
    PickPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
    [cell setBackgroundColor:CCamRedColor];
    
    if (cell.photoImage == nil) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height)];
        if (indexPath.row == 0) {
            [img setFrame:CGRectMake(cell.contentView.frame.size.width/3, cell.contentView.frame.size.height/3, cell.contentView.frame.size.width/3, cell.contentView.frame.size.height/3)];
        }
        [img setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:img];
        cell.clipsToBounds = YES;
        cell.photoImage = img;
    }
    
    
    ALAsset* asset = (ALAsset*)[self.photos objectAtIndex:indexPath.row];
    
    
    if ([asset isKindOfClass:[UIImage class]]) {
        [cell.photoImage setImage:(UIImage*)asset];
    }else{
        [cell.photoImage setImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
    }
    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat wh = (collectionView.bounds.size.width - 4)/3.0;
    
    return CGSizeMake(wh, wh);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}
#pragma mark - ALAssetsLibrary
- (ALAssetsLibrary *)assetsLibrary {
    if (!_assetsLibrary) {
        static dispatch_once_t pred = 0;
        static ALAssetsLibrary *library = nil;
        dispatch_once(&pred, ^{
            library = [[ALAssetsLibrary alloc] init];
        });
        _assetsLibrary = library;
    }
    return _assetsLibrary;
}
#pragma mark - getter/setter
- (NSMutableArray *)albums {
    if (!_albums) {
        _albums = [[NSMutableArray alloc] init];
    }
    return _albums;
}
- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}
#pragma mark - getcropimage
- (void)showCroppedImage{
    
//    ShowImageViewController *show =[[ShowImageViewController alloc] init];
    
    if (fitSize) {
        [[iOSBindingManager sharedManager] saveCroppedImageWith:[self normalizedImage:[self getMixImage:_albumImg.image color:_albumImg.backgroundColor]]];
    }else{
        [[iOSBindingManager sharedManager] saveCroppedImageWith:[self normalizedImage:[self getCroppedImageWith:_albumImg.image]]];
    }
    
    NSString *photoPath = [NSString stringWithFormat:@"file://%@/Choosed.jpg",CCamDocPath];
    [[FileHelper sharedManager] addSkipBackupAttributeToItemAtPath:[NSString stringWithFormat:@"%@/Choosed.jpg",CCamDocPath]];
    NSLog(@"Check Path : %@",photoPath);
    UnitySendMessage(UnityController.UTF8String, "SelectAPicture", photoPath.UTF8String);
//    [self presentViewController:show animated:YES completion:nil];
    
    CCamViewController *vc = [[CCamViewController alloc] init];
    [DataHelper sharedManager].ccamVC = vc;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)exitPicker{
    
//    UnitySendMessage(UnityController.UTF8String,"CallHomeScene","");

    [[iOSBindingManager sharedManager] showChangeSceneTransition];
    [self performSelector:@selector(removeImagePickerView) withObject:nil afterDelay:0.25];
}

- (void)removeImagePickerView{
    [self.navigationController removeFromParentViewController];
    [self.navigationController.view removeFromSuperview];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_autoLoadWhenDidAppear) {
        [self getAlbumsData];
        _autoLoadWhenDidAppear = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _autoLoadWhenDidAppear = YES;
    fitSize = NO;
    
    _assetsFilter = [ALAssetsFilter allPhotos];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    
    //init albumBG
    _albumBG = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_albumBG setBounces:NO];
    [_albumBG setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 2*CCamThinNaviHeight+self.view.frame.size.width*4/5)];
    [_albumBG setBackgroundColor:[UIColor blackColor]];
    [_albumBG setPagingEnabled:YES];
    [self.view addSubview:_albumBG];
    [_albumBG setDelegate:self];
    
    
    //init albumNavi
    _albumNavi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.albumBG.contentSize.width, CCamThinNaviHeight)];
    [_albumNavi setBackgroundColor:CCamCameraNaviColor];
    [self.albumBG addSubview:_albumNavi];
    //init naviClose
    _albumNaviClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_albumNaviClose setShowsTouchWhenHighlighted:YES];
    [_albumNaviClose setTintColor:[UIColor whiteColor]];
    [_albumNaviClose setImage:[[UIImage imageNamed:@"albumClose"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_albumNaviClose sizeToFit];
    [_albumNaviClose setFrame:CGRectMake(0, 0, _albumNaviClose.frame.size.width+30, _albumNavi.frame.size.height)];
    [_albumNaviClose setCenter:CGPointMake(_albumNaviClose.frame.size.width/2, _albumNavi.frame.size.height/2)];
    [_albumNaviClose addTarget:self action:@selector(exitPicker) forControlEvents:UIControlEventTouchUpInside];
    [_albumNavi addSubview:_albumNaviClose];
    //init naviContinue
    _albumNaviContinue = [UIButton buttonWithType:UIButtonTypeCustom];
    [_albumNaviContinue setShowsTouchWhenHighlighted:YES];
    [_albumNaviContinue setTitle:Babel(@"下一步") forState:UIControlStateNormal];
    [_albumNaviContinue.titleLabel setFont:[UIFont systemFontOfSize:14.]];
    [_albumNaviContinue setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_albumNaviContinue sizeToFit];
    [_albumNaviContinue setFrame:CGRectMake(0, 0, _albumNaviContinue.frame.size.width+24, _albumNaviContinue.frame.size.height+2)];
    [_albumNaviContinue setCenter:CGPointMake(_albumNavi.frame.size.width-15-_albumNaviContinue.frame.size.width/2, _albumNavi.frame.size.height/2)];
    [_albumNaviContinue.layer setCornerRadius:_albumNaviContinue.frame.size.height/2];    [_albumNaviContinue setBackgroundColor:[UIColor whiteColor]];
    [_albumNaviContinue setTintColor:CCamRedColor];
    [_albumNaviContinue addTarget:self action:@selector(showCroppedImage) forControlEvents:UIControlEventTouchUpInside];
    [_albumNavi addSubview:_albumNaviContinue];
    
    //init naviChoose
    _albumNaviChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    [_albumNaviChoose setImage:[[UIImage imageNamed:@"albumChoose"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_albumNaviChoose setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [_albumNaviChoose setTintColor:[UIColor whiteColor]];
    [_albumNaviChoose setTitle:@"" forState:UIControlStateNormal];
    [_albumNaviChoose.titleLabel setFont:[UIFont boldSystemFontOfSize:17.]];
    [_albumNaviChoose setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_albumNaviChoose setFrame:CGRectMake(0, 0, 200, CCamThinNaviHeight)];
    [_albumNaviChoose setCenter:CGPointMake(_albumNavi.frame.size.width/2, _albumNavi.frame.size.height/2)];
    [_albumNaviChoose addTarget:self action:@selector(showAlbums) forControlEvents:UIControlEventTouchUpInside];
    [_albumNavi addSubview:_albumNaviChoose];
    
    //init album tool bar
    _albumToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, CCamThinNaviHeight+_albumBG.contentSize.width, _albumBG.contentSize.width, CCamThinNaviHeight)];
    [_albumToolBar setBackgroundColor:[UIColor redColor]];
    [_albumBG addSubview:_albumToolBar];
    
    _albumMoveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_albumMoveBtn setImage:[[UIImage imageNamed:@"cameraBarmove"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_albumMoveBtn setTintColor:CCamRedColor];
    [_albumMoveBtn setBackgroundColor:[UIColor whiteColor]];
    [_albumMoveBtn setFrame:CGRectMake(0, 0, _albumToolBar.frame.size.width, CCamThinNaviHeight)];
    [_albumMoveBtn setCenter:CGPointMake(_albumToolBar.frame.size.width/2, _albumToolBar.frame.size.height/2)];
    [_albumToolBar addSubview:_albumMoveBtn];
    [_albumMoveBtn addTarget:self action:@selector(poppop) forControlEvents:UIControlEventTouchUpInside];
    
    _albumImgRotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_albumImgRotateBtn setImage:[[UIImage imageNamed:@"camera90Degree"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_albumImgRotateBtn setTintColor:CCamRedColor];
    [_albumImgRotateBtn setBackgroundColor:[UIColor whiteColor]];
    [_albumImgRotateBtn setFrame:CGRectMake(0, 0, CCamThinNaviHeight, CCamThinNaviHeight)];
    [_albumImgRotateBtn setCenter:CGPointMake(22 + 15, _albumToolBar.frame.size.height/2)];
    [_albumToolBar addSubview:_albumImgRotateBtn];
    [_albumImgRotateBtn addTarget:self action:@selector(rotateImage) forControlEvents:UIControlEventTouchUpInside];
    
    
    _albumImgFitSizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_albumImgFitSizeBtn setImage:[[UIImage imageNamed:@"cameraFitsize"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_albumImgFitSizeBtn setTintColor:CCamRedColor];
    [_albumImgFitSizeBtn setBackgroundColor:[UIColor whiteColor]];
    [_albumImgFitSizeBtn setFrame:CGRectMake(0, 0, CCamThinNaviHeight, CCamThinNaviHeight)];
    [_albumImgFitSizeBtn setCenter:CGPointMake(_albumToolBar.frame.size.width-22-15, _albumToolBar.frame.size.height/2)];
    [_albumToolBar addSubview:_albumImgFitSizeBtn];
    [_albumImgFitSizeBtn addTarget:self action:@selector(changeImageToFitSize) forControlEvents:UIControlEventTouchUpInside];
    
    _albumImgBG = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CCamThinNaviHeight, self.view.frame.size.width, self.view.frame.size.width)];
    [_albumImgBG setMaximumZoomScale:2.0];
    [_albumImgBG setMinimumZoomScale:1.0];
    [_albumBG addSubview:_albumImgBG];
    [_albumImgBG setDelegate:self];
    
    _albumImg = [[UIImageView alloc]init];
    [_albumImg setContentMode:UIViewContentModeScaleAspectFit];
    [_albumImgBG addSubview:_albumImg];
    
    _albumImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_albumImgBtn setBackgroundColor:[UIColor clearColor]];
    [_albumImgBtn setFrame:CGRectMake(0, 0, _albumImgBG.frame.size.width, _albumImgBG.frame.size.height)];
    [_albumImgBG addSubview:_albumImgBtn];
    [_albumImgBtn addTarget:self action:@selector(changeFitImageBackgroundColor) forControlEvents:UIControlEventTouchUpInside];
    [_albumImgBtn setHidden:YES];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _photoCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CCamThinNaviHeight+CCamThinNaviHeight+self.view.frame.size.width, self.view.frame.size.width, _albumBG.contentSize.height-CCamThinNaviHeight-CCamThinNaviHeight-self.view.frame.size.width) collectionViewLayout:flowLayout];
    [_photoCollection registerClass:[PickPhotoCell class] forCellWithReuseIdentifier:@"capturecell"];
    [_photoCollection registerClass:[PickPhotoCell class] forCellWithReuseIdentifier:@"photocell"];
    
    [_photoCollection setBackgroundColor:[UIColor whiteColor]];
    [_albumBG addSubview:_photoCollection];
    
    [_photoCollection setContentInset:UIEdgeInsetsMake(0, 0, _albumBG.contentSize.height-self.view.frame.size.height, 0)];
    [_photoCollection setBounces:NO];
    [_photoCollection setDataSource:self];
    [_photoCollection setDelegate:self];
    
    
    _captureBG = [[UIView alloc] initWithFrame:self.view.frame];
    [_captureBG setBackgroundColor:CCamSegmentColor];
    [self.view addSubview:_captureBG];
    [_captureBG setHidden:YES];
    
    
    BOOL isPad = NO;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        isPad = YES;
    }
    
    if (isPad) {
        _captureButtonsBG = [[UIView alloc] initWithFrame:CGRectMake(0, CCamThinNaviHeight+CCamViewWidth, CCamViewWidth, 44)];

    }else{
        _captureButtonsBG = [[UIView alloc] initWithFrame:CGRectMake(0, CCamThinNaviHeight+CCamViewWidth, CCamViewWidth, CCamThinNaviHeight)];
    }
    
    [_captureButtonsBG setBackgroundColor:CCamSegmentColor];
    [_captureBG addSubview:_captureButtonsBG];
    
    NSLog(@"%@",[NSValue valueWithCGRect:_captureButtonsBG.frame]);
    
    _captureDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_captureDeviceBtn setShowsTouchWhenHighlighted:YES];
//    [_captureDeviceBtn setTitle:@"Device" forState:UIControlStateNormal];
    [_captureDeviceBtn setImage:[UIImage imageNamed:@"captureDeviceIcon"] forState:UIControlStateNormal];
    [_captureDeviceBtn sizeToFit];
    [_captureDeviceBtn setCenter:CGPointMake(_captureButtonsBG.frame.size.width/2, _captureButtonsBG.frame.size.height/2)];
    [_captureButtonsBG addSubview:_captureDeviceBtn];
    [_captureDeviceBtn addTarget:self action:@selector(switchCameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _captureFlashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_captureFlashBtn setShowsTouchWhenHighlighted:YES];
    [_captureFlashBtn setImage:[UIImage imageNamed:@"captureFlashOffIcon"] forState:UIControlStateNormal];
//    [_captureFlashBtn setTitle:@"Flash Off" forState:UIControlStateNormal];
    [_captureFlashBtn sizeToFit];
    [_captureFlashBtn setCenter:CGPointMake(30+_captureFlashBtn.frame.size.width/2, _captureButtonsBG.frame.size.height/2)];
    [_captureButtonsBG addSubview:_captureFlashBtn];
    [_captureFlashBtn addTarget:self action:@selector(flashButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    _captureShupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_captureShupBtn setShowsTouchWhenHighlighted:YES];
    [_captureShupBtn setImage:[UIImage imageNamed:@"captureShupIcon"] forState:UIControlStateNormal];
    [_captureShupBtn sizeToFit];
    [_captureShupBtn setCenter:CGPointMake(_captureButtonsBG.frame.size.width-30-_captureShupBtn.frame.size.width/2, _captureButtonsBG.frame.size.height/2)];
    [_captureButtonsBG addSubview:_captureShupBtn];
    [_captureShupBtn addTarget:self action:@selector(setCaptureShupState) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *captureButView;
    if (isPad) {
        captureButView= [[UIView alloc] initWithFrame:CGRectMake(0, 100+CCamViewWidth, CCamViewWidth, CCamViewHeight-CCamViewWidth-100)];
    }else{
        captureButView= [[UIView alloc] initWithFrame:CGRectMake(0, 88+CCamViewWidth, CCamViewWidth, CCamViewHeight-CCamViewWidth-88)];
    }
    [captureButView setBackgroundColor:[UIColor whiteColor]];
    [_captureBG addSubview:captureButView];
    
    
    _captureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_captureBtn setBackgroundImage:[[UIImage imageNamed:@"captureIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_captureBtn setTintColor:CCamRedColor];
//    [_captureBtn setBackgroundColor:[UIColor whiteColor]];
    [_captureBtn setFrame:CGRectMake(0, 0, 88, 88)];
    [_captureBtn setCenter:CGPointMake(captureButView.frame.size.width/2, captureButView.frame.size.height/2)];
    [_captureBtn.layer setCornerRadius:_captureBtn.frame.size.height/2];
    [_captureBtn.layer setMasksToBounds:YES];
    [_captureBtn addTarget:self action:@selector(takeCapture) forControlEvents:UIControlEventTouchUpInside];
    [captureButView addSubview:_captureBtn];
    
    NSLog(@"%@",[NSValue valueWithCGRect:_captureBtn.frame]);

    
    
    _showAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showAlbumBtn setFrame:CGRectMake(0, 0, 66, 66)];
    [_showAlbumBtn setCenter:CGPointMake(captureButView.frame.size.width/6,captureButView.frame.size.height/2)];
    [captureButView addSubview:_showAlbumBtn];
    [_showAlbumBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    _showAlbumBtn.clipsToBounds = YES;
    [_showAlbumBtn.layer setBorderColor:CCamSegmentColor.CGColor];
    [_showAlbumBtn.layer setBorderWidth:1.0];
    [_showAlbumBtn.layer setCornerRadius:_showAlbumBtn.frame.size.height/2];
    [_showAlbumBtn.layer setMasksToBounds:YES];
    [_showAlbumBtn addTarget:self action:@selector(backToAlbum) forControlEvents:UIControlEventTouchUpInside];
    
    _albumCollection = [[UITableView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    [_albumCollection setDelegate:self];
    [_albumCollection setDataSource:self];
    [_albumCollection setHidden:YES];
    [_albumCollection setBounces:NO];
    [_albumCollection setBackgroundColor:CCamViewBackgroundColor];
    [_albumBG addSubview:_albumCollection];
    
    [self.albumBG addSubview:_albumNavi];
}
- (void)changeImageToFitSize{
    
    fitSize = !fitSize;
    if (!fitSize) {
        NSLog(@"turn to no fitsize");
        [self resetAlbumChoosedImage];
    }else{
        NSLog(@"turn to fitsize");
        [_albumImgBG setContentSize:_albumImgBG.frame.size];
        [_albumImg setFrame:CGRectMake(0, 0, _albumImgBG.frame.size.width, _albumImgBG.frame.size.height)];
        [_albumImg setBackgroundColor:[UIColor whiteColor]];
        [_albumImgBG setContentOffset:CGPointMake(0, 0)];
        [_albumImgBG setScrollEnabled:NO];
        [_albumImgBG setMaximumZoomScale:1.0];
        [_albumImgFitSizeBtn setTitle:@"NoFit" forState:UIControlStateNormal];
        [_albumImgBtn setHidden:NO];
    }
    
}
- (void)changeFitImageBackgroundColor{
    if (_albumImg.backgroundColor == [UIColor whiteColor]) {
        _albumImg.backgroundColor = [UIColor blackColor];
    }else{
        _albumImg.backgroundColor = [UIColor whiteColor];
    }
}
- (void)showAlbums{
    [_albumNaviChoose setEnabled:NO];
    if (_albumCollection.hidden == YES) {
        [_albumCollection setHidden:NO];
        [_albumBG setScrollEnabled:NO];
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue =[NSValue valueWithCGRect:_albumCollection.frame];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, CCamThinNaviHeight, self.view.frame.size.width, self.view.frame.size.height-CCamThinNaviHeight)];
        anim.beginTime = CACurrentMediaTime();
        anim.duration = 0.2;
//        anim.springBounciness = 10.0f;
        [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
            if(finish) {
                NSLog(@"!");
                [_albumNaviChoose setEnabled:YES];
            }
        }];
        [self.albumCollection pop_addAnimation:anim forKey:@"position"];
    }else{
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue =[NSValue valueWithCGRect:_albumCollection.frame];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-64)];
        anim.beginTime = CACurrentMediaTime();
        anim.duration = 0.2;
//        anim.springBounciness = 10.0f;
        [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
            if(finish) {
                NSLog(@"!");
                [_albumCollection setHidden:YES];
                [_albumBG setScrollEnabled:YES];
                [_albumNaviChoose setEnabled:YES];
            }
        }];
        [self.albumCollection pop_addAnimation:anim forKey:@"position"];
    }
}
- (void)backToAlbum{
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.fromValue =[NSValue valueWithCGRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(self.view.frame.size.width, 0, _captureBG.frame.size.width, _captureBG.frame.size.height)];
    anim.beginTime = CACurrentMediaTime();
    anim.springBounciness = 10.0f;
    [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            
            [self.fastCamera.view setHidden:YES];
            [self.captureBG setHidden:YES];
            [self getAlbumsData];

        }
    }];
    [_captureBG pop_addAnimation:anim forKey:@"position"];
}
- (void)takeCapture{
    
    _captureEffect.hidden = NO;
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.fromValue =@(1.0);
    anim.toValue = @(0.0);
    anim.beginTime = CACurrentMediaTime();
    anim.duration = 0.25;
    [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [_captureEffect setHidden:YES];
        }
    }];
    [_captureEffect pop_addAnimation:anim forKey:@"position"];
    
    [self.fastCamera takePicture];
}
- (UIImage *)normalizedImage:(UIImage*)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}
- (void)rotateImage{
    switch (_albumImg.image.imageOrientation) {
        case UIImageOrientationUp:
            [_albumImg setImage:[self normalizedImage:[UIImage imageWithCGImage:_albumImg.image.CGImage scale:1 orientation:UIImageOrientationRight]]];
            
            break;
        case UIImageOrientationRight:
            [_albumImg setImage:[self normalizedImage:[UIImage imageWithCGImage:_albumImg.image.CGImage scale:1 orientation:UIImageOrientationDown]]];
            
            break;
        case UIImageOrientationDown:
            [_albumImg setImage:[self normalizedImage:[UIImage imageWithCGImage:_albumImg.image.CGImage scale:1 orientation:UIImageOrientationLeft]]];
            
            break;
        case UIImageOrientationLeft:
            [_albumImg setImage:[self normalizedImage:[UIImage imageWithCGImage:_albumImg.image.CGImage scale:1 orientation:UIImageOrientationUp]]];
            
            break;
            
        default:
            [_albumImg setImage:[self normalizedImage:[UIImage imageWithCGImage:_albumImg.image.CGImage scale:1 orientation:UIImageOrientationUp]]];
            
            break;
    }
    if (fitSize) {
        
        return;
    }
    
    [self resetAlbumChoosedImage];
}
- (void)switchCameraButtonPressed
{
    NSLog(@"switch camera button pressed");
    
    FastttCameraDevice cameraDevice;
    switch (self.fastCamera.cameraDevice) {
        case FastttCameraDeviceFront:
            cameraDevice = FastttCameraDeviceRear;
            break;
        case FastttCameraDeviceRear:
        default:
            cameraDevice = FastttCameraDeviceFront;
            break;
    }
    if ([FastttCamera isCameraDeviceAvailable:cameraDevice]) {
        [self.fastCamera setCameraDevice:cameraDevice];
        if (![self.fastCamera isFlashAvailableForCurrentDevice]) {
            [_captureFlashBtn setTitle:@"Flash Off" forState:UIControlStateNormal];
        }
    }
}
- (void)flashButtonPressed
{
    NSLog(@"flash button pressed");
    
    FastttCameraFlashMode flashMode;
    NSString *flashTitle;
    switch (self.fastCamera.cameraFlashMode) {
        case FastttCameraFlashModeOn:
            flashMode = FastttCameraFlashModeOff;
            flashTitle = @"captureFlashOffIcon";
            break;
        case FastttCameraFlashModeOff:
            flashMode = FastttCameraFlashModeOn;
            flashTitle = @"captureFlashOnIcon";
            break;
        default:
            
            break;
    }
    if ([self.fastCamera isFlashAvailableForCurrentDevice]) {
        [self.fastCamera setCameraFlashMode:flashMode];
        [_captureFlashBtn setImage:[UIImage imageNamed:flashTitle] forState:UIControlStateNormal];

    }
}
- (void)resetAlbumChoosedImage{
    
//    if (!_albumImg.image) {
//        return;
//    }
    NSLog(@"%ld",(long)_albumImg.image.imageOrientation);
//    UIImage * newImage = [self normalizedImage:[UIImage imageWithCGImage:_albumImg.image.CGImage scale:1 orientation:_albumImg.image.imageOrientation]];
    
    if (_albumImg.image.size.height > _albumImg.image.size.width) {
        [_albumImgBG setContentSize:CGSizeMake(_albumImgBG.frame.size.width, _albumImg.image.size.height * _albumImgBG.frame.size.width/_albumImg.image.size.width)];
        [_albumImg setFrame:CGRectMake(0, 0, _albumImgBG.frame.size.width,_albumImg.image.size.height * _albumImgBG.frame.size.width/_albumImg.image.size.width)];
        
    }else if (_albumImg.image.size.height < _albumImg.image.size.width){
        [_albumImgBG setContentSize:CGSizeMake(_albumImg.image.size.width * _albumImgBG.frame.size.height/_albumImg.image.size.height, _albumImgBG.frame.size.height)];
        [_albumImg setFrame:CGRectMake(0, 0, _albumImg.image.size.width * _albumImgBG.frame.size.height/_albumImg.image.size.height,_albumImgBG.frame.size.height)];
        
    }else{
        [_albumImgBG setContentSize:CGSizeMake(_albumImgBG.frame.size.width, _albumImgBG.frame.size.height)];
        [_albumImg setFrame:CGRectMake(0, 0, _albumImgBG.frame.size.width,_albumImgBG.frame.size.height)];
        
    }
    
    fitSize = NO;
    [_albumImgBG setScrollEnabled:YES];
    [_albumImgBG setMaximumZoomScale:2.0];
    [_albumImgFitSizeBtn setTitle:@"Fit" forState:UIControlStateNormal];
    [_albumImgBtn setHidden:YES];
}
static CGRect TWScaleRect(CGRect rect, CGFloat scale)
{
    return CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
}

- (UIImage *) getCroppedImageWith:(UIImage*)image{
    
    CGFloat sizeScale;
    if (image.size.width>image.size.height) {
        sizeScale= image.size.height / _albumImg.frame.size.height;

    }else{
        sizeScale= image.size.width / _albumImg.frame.size.width;

    }
    sizeScale *= _albumImgBG.zoomScale;
    CGRect visibleRect = [_albumImgBG convertRect:_albumImgBG.bounds toView:_albumImg];
    visibleRect = TWScaleRect(visibleRect, sizeScale);
    CGImageRef ref = CGImageCreateWithImageInRect([_albumImg.image CGImage], visibleRect);//crop
    UIImage* cropped =  [[UIImage alloc] initWithCGImage:ref scale:_albumImg.image.scale orientation:_albumImg.image.imageOrientation] ;
    
    CGImageRelease(ref);
    ref = NULL;
    
    return cropped;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.album = (ALAssetsGroup*)[self.albums objectAtIndex:indexPath.row];
    [_albumNaviChoose setTitle:[self.album valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
    [self getPhotosWithAlbums:self.album];
    [self showAlbums];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albums.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"albumCell";
    AlbumCell *cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    if (cell.albumImage == nil) {
        cell.albumImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 88, 88)];
        cell.albumImage.clipsToBounds = YES;
        [cell.albumImage setContentMode:UIViewContentModeScaleAspectFill];
        [cell.contentView addSubview:cell.albumImage];
    }
    
    if (cell.albumName == nil) {
        cell.albumName = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, cell.contentView.frame.size.width-100, 88)];
        [cell.contentView addSubview:cell.albumName];
    }
    
    ALAssetsGroup *group = (ALAssetsGroup*)[self.albums objectAtIndex:indexPath.row];
    
    cell.albumName.text = [NSString stringWithFormat:@"%@(%ld)",[group valueForProperty:ALAssetsGroupPropertyName],(long)[group numberOfAssets]];
    
    CGImageRef posterImage = group.posterImage;
    [cell.albumImage setImage:[UIImage imageWithCGImage:posterImage scale:1 orientation:UIImageOrientationUp]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (void) poppop{
    if (_albumBG.contentOffset.y == 0) {
        [_albumBG setContentOffset:CGPointMake(_albumBG.contentOffset.x, CCamThinNaviHeight + self.view.frame.size.width*4/5) animated:YES];
        [_photoCollection setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
    }else{
        [_albumBG setContentOffset:CGPointMake(_albumBG.contentOffset.x, 0) animated:YES];
        [_photoCollection setContentInset:UIEdgeInsetsMake(0, 0, _albumBG.contentSize.height-self.view.frame.size.height, 0)];
    }
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _albumImg;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _albumImgBG) {
        [_albumBG setScrollEnabled:NO];
    }else if (scrollView == _albumBG){
//        if (_albumBG.contentOffset.y>0) {
//            
//            if (_albumBG.contentOffset.y<_albumBG.contentSize.height) {
//                [_photoCollection setContentInset:UIEdgeInsetsMake(0, 0, _albumBG.contentSize.height-self.view.frame.size.height-_albumBG.contentOffset.y, 0)];
//            }else if (_albumBG.contentOffset.y==_albumBG.contentSize.height){
//                [_photoCollection setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//            }
//        }
    }
}
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    if (scrollView == self.bg) {
//        [self.bg setScrollEnabled:YES];
//    }
//}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    if (scrollView == self.mid) {
    [_albumBG setScrollEnabled:YES];
    //    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_albumBG setScrollEnabled:YES];
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (UIImage *)getMixImage:(UIImage *)image color:(UIColor*)color{
    
    CGSize size;
    
    if (image.size.width>image.size.height) {
        size = CGSizeMake(image.size.width, image.size.width);
        UIGraphicsBeginImageContext(size);
        [[self createImageWithColor:color] drawInRect:CGRectMake(0, 0, size.width, size.height)];
        [image drawInRect:CGRectMake(0, (image.size.width-image.size.height)/2, image.size.width, image.size.height)];
        UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }else if (image.size.height>image.size.width){
        size = CGSizeMake(image.size.height, image.size.height);
        UIGraphicsBeginImageContext(size);
        [[self createImageWithColor:color] drawInRect:CGRectMake(0, 0, size.width, size.height)];
        [image drawInRect:CGRectMake((image.size.height-image.size.width)/2,0 , image.size.width, image.size.height)];
        UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultImage;
    }
    return image;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ALAssetsLibrary disableSharedPhotoStreamsSupport];
    [self.navigationController setNavigationBarHidden:YES];
}
@end
