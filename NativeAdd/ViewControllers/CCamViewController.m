//
//  CCamViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import "CCamViewController.h"
#import "CCamHelper.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "CCSerie.h"
#import "CCCharacter.h"
#import "CCAnimation.h"

#import "CCamSegmentCell.h"
#import "CCamSegmentContentCell.h"
#import "CCamSerieCell.h"
#import "CCamSerieContentCell.h"
#import "CCamCharacterCell.h"
#import "CCamAnimationCell.h"
#import "CCStickerSetCell.h"
#import "CCStickerSetContentCell.h"
#import "CCamFilterCell.h"

#import "CCamSubmitViewController.h"
#import <pop/POP.h>
#import "CCamCircleView.h"
#import "EFCircularSlider.h"
#import "WCCircularSlider.h"

@interface CCamCollectionView : UICollectionView
@property (assign) CCamCollectionViewType type;
@end

@interface CCamViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CCamCircleViewDelegat>

@property (nonatomic,assign) BOOL allowShowEraseTutorial;
@property (nonatomic,assign) BOOL allowSelectTargetSerie;

@property (nonatomic,strong) NSMutableArray *segments;
@property (nonatomic,strong) NSMutableArray *segmentsShow;
@property (nonatomic,strong) NSMutableArray *filters;

@property (nonatomic,strong) NSMutableDictionary *currentAnimationInfo;
@property (nonatomic,strong) NSArray *currentPoses;
@property (nonatomic,strong) NSArray *currentFaces;

@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UIScrollView *navigationView;
@property (nonatomic,strong) UIScrollView *navigationSurface;
@property (nonatomic,strong) UILabel *navigationTitle;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *nextButton;

@property (nonatomic,assign) NSInteger eraseType;
@property (nonatomic,assign) float eraseSize;

@property (nonatomic,strong) UIScrollView *animationControl;
@property (nonatomic,strong) UIScrollView *lightControl;
@property (nonatomic,strong) CCamCircleView *lightCircle;
@property (nonatomic,strong) CCamCircleView *poseCircle;
@property (nonatomic,strong) CCamCircleView *headCircle;
//@property (nonatomic,strong) UIView *headCircleMask;
@property (nonatomic,strong) CCamCircleView *faceCircle;
@property (nonatomic,strong) UIButton * lastPoseBtn;
@property (nonatomic,strong) UIButton * nextPoseBtn;
@property (nonatomic,strong) UIButton * currentPoseBtn;
@property (nonatomic,strong) UIButton * lastFaceBtn;
@property (nonatomic,strong) UIButton * nextFaceBtn;
@property (nonatomic,strong) UIButton * currentFaceBtn;
@property (nonatomic,strong) WCCircularSlider *lightSlider;
@property (nonatomic,strong) WCCircularSlider *shadowSlider;

@property (nonatomic,strong) UISegmentedControl *eraseSeg;

@end

@implementation CCamViewController

- (id)init{
    if (self = [super init]) {
        [self segments];
        [self segmentsShow];
        _allowSelectTargetSerie = YES;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _allowShowEraseTutorial = YES;
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setNavigationView];

    NSString *filterString = @"None|Memory|Movie|Nature|Vintage|Negative|Fall|Relax|Gothic|Pink|Young|Beauty|Sweet|Dusk|Inkwell|Japan";
    NSArray *filterArray = [filterString componentsSeparatedByString:@"|"];
    _filters = [[NSMutableArray alloc] initWithCapacity:0];
    [_filters removeAllObjects];
    [_filters addObjectsFromArray:filterArray];
    NSLog(@"%@",_filters);
    
    [self setSegmentCollection:[self getCollectionWith:CCamSegmentCollectionView]];
    [self setSegmentContentCollection:[self getCollectionWith:CCamSegmentContentCollectionView]];
    
    [self setLightControlView];
    [self setAnimationControlView];

}

- (void)setAnimationControlView{
    if (!_animationControl) {
        _animationControl = [[UIScrollView alloc] init];
//        CCamThinNaviHeight+CCamViewWidth
        [_animationControl setFrame:CGRectMake(0, CCamViewHeight, CCamViewWidth, CCamViewHeight-CCamThinNaviHeight-CCamViewWidth)];
        [_animationControl setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_animationControl];
        
        UIView *animationControlBar = [[UIView alloc] initWithFrame:CGRectMake(0, _animationControl.bounds.size.height-CCamThinNaviHeight, CCamViewWidth, CCamThinNaviHeight)];
        [animationControlBar setBackgroundColor:CCamViewBackgroundColor];
        [_animationControl addSubview:animationControlBar];
        
//        UIButton *animationControlLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [animationControlLeftBtn setImage:[[UIImage imageNamed:@"albumClose"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//        [animationControlLeftBtn setTintColor:CCamRedColor];
//        [animationControlLeftBtn sizeToFit];
//        [animationControlBar addSubview:animationControlLeftBtn];
//        [animationControlLeftBtn setCenter:CGPointMake(10+animationControlLeftBtn.bounds.size.width/2, animationControlBar.bounds.size.height/2)];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, animationControlBar.bounds.size.width, animationControlBar.bounds.size.height)];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setText:Babel(@"动作表情调节")];
        [title setTextColor:CCamGrayTextColor];
        [title setFont:[UIFont boldSystemFontOfSize:17.0]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [animationControlBar addSubview:title];
        
        UIButton *animationControlRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [animationControlRightBtn setImage:[[UIImage imageNamed:@"controlOK"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [animationControlRightBtn setTintColor:CCamRedColor];
        [animationControlRightBtn sizeToFit];
        [animationControlBar addSubview:animationControlRightBtn];
        [animationControlRightBtn setCenter:CGPointMake(animationControlBar.bounds.size.width-10-animationControlRightBtn.bounds.size.width/2, animationControlBar.bounds.size.height/2)];
        [animationControlRightBtn addTarget:self action:@selector(SetAnimationControlDisappear) forControlEvents:UIControlEventTouchUpInside];
    }
//    if (!_poseCircle) {
//        _poseCircle = [[CCamCircleView alloc] initWithFrame:CGRectMake(0, 0, _animationControl.bounds.size.width/2*0.8,_animationControl.bounds.size.width/2*0.8)];
//        [_poseCircle setCenter:CGPointMake(_animationControl.bounds.size.width*0.25, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2)];
//        [_poseCircle.circleBG setImage:[UIImage imageNamed:@"poseCircle"]];
//        [_animationControl addSubview:_poseCircle];
//        [_poseCircle setDelegate:self];
//    }
    
    if (!_lastPoseBtn && !_nextPoseBtn && !_currentPoseBtn) {
        _currentPoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_currentPoseBtn setImage:[[UIImage imageNamed:@"poseIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_currentPoseBtn setTintColor:CCamRedColor];
        [_currentPoseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [_currentPoseBtn setFrame:CGRectMake(0, 0, 100, 40)];
        [_currentPoseBtn setCenter:CGPointMake(_animationControl.bounds.size.width*0.25, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_currentPoseBtn.layer setCornerRadius:_currentPoseBtn.bounds.size.height/2];
        [_currentPoseBtn.layer setMasksToBounds:YES];
        [_currentPoseBtn.layer setBorderColor:CCamRedColor.CGColor];
        [_currentPoseBtn.layer setBorderWidth:1.0];
        [_currentPoseBtn setBackgroundColor:[UIColor whiteColor]];
        [_currentPoseBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [_currentPoseBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
        [_animationControl addSubview:_currentPoseBtn];
        
        _lastPoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastPoseBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [_lastPoseBtn setCenter:CGPointMake(_currentPoseBtn.center.x-5-(_currentPoseBtn.bounds.size.width+_lastPoseBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_lastPoseBtn setBackgroundColor:[UIColor clearColor]];
        [_lastPoseBtn setImage:[[UIImage imageNamed:@"lastIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_lastPoseBtn setTintColor:CCamRedColor];
        [_lastPoseBtn addTarget:self action:@selector(changeLastPose) forControlEvents:UIControlEventTouchUpInside];
        [_animationControl addSubview:_lastPoseBtn];
        
        _nextPoseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextPoseBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [_nextPoseBtn setCenter:CGPointMake(_currentPoseBtn.center.x+5+(_currentPoseBtn.bounds.size.width+_nextPoseBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_nextPoseBtn setBackgroundColor:[UIColor clearColor]];
        [_nextPoseBtn setImage:[[UIImage imageNamed:@"nextIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_nextPoseBtn setTintColor:CCamRedColor];        [_nextPoseBtn addTarget:self action:@selector(changeNextPose) forControlEvents:UIControlEventTouchUpInside];
        [_animationControl addSubview:_nextPoseBtn];

    }
    
    if (!_lastFaceBtn && !_nextFaceBtn && !_currentFaceBtn) {
        _currentFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_currentFaceBtn setImage:[[UIImage imageNamed:@"lookIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_currentFaceBtn setTintColor:CCamRedColor];
        [_currentFaceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [_currentFaceBtn setFrame:CGRectMake(0, 0, 100, 40)];
        [_currentFaceBtn setCenter:CGPointMake(_animationControl.bounds.size.width*0.25, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
        [_currentFaceBtn.layer setCornerRadius:_currentFaceBtn.bounds.size.height/2];
        [_currentFaceBtn.layer setMasksToBounds:YES];
        [_currentFaceBtn.layer setBorderWidth:1.0];
        [_currentFaceBtn.layer setBorderColor:CCamRedColor.CGColor];
        [_currentFaceBtn setBackgroundColor:[UIColor whiteColor]];
        [_currentFaceBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [_currentFaceBtn setTitleColor:CCamRedColor forState:UIControlStateNormal];
        [_animationControl addSubview:_currentFaceBtn];
        
        _lastFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastFaceBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [_lastFaceBtn setCenter:CGPointMake(_currentFaceBtn.center.x-5-(_currentFaceBtn.bounds.size.width+_lastFaceBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
        [_lastFaceBtn setBackgroundColor:[UIColor clearColor]];
        [_lastFaceBtn setImage:[[UIImage imageNamed:@"lastIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_lastFaceBtn setTintColor:CCamRedColor];
        [_lastFaceBtn setContentMode:UIViewContentModeScaleAspectFit];
        [_lastFaceBtn addTarget:self action:@selector(changeLastFace) forControlEvents:UIControlEventTouchUpInside];
        [_animationControl addSubview:_lastFaceBtn];
        
        _nextFaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextFaceBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [_nextFaceBtn setCenter:CGPointMake(_currentFaceBtn.center.x+5+(_currentFaceBtn.bounds.size.width+_nextFaceBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
        [_nextFaceBtn setBackgroundColor:[UIColor clearColor]];
        [_nextFaceBtn setImage:[[UIImage imageNamed:@"nextIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_nextFaceBtn setTintColor:CCamRedColor];        [_animationControl addSubview:_nextFaceBtn];
        [_nextFaceBtn addTarget:self action:@selector(changeNextFace) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    if (!_headCircle) {
        
        BOOL isPad = NO;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            isPad = YES;
        }
        
        if (isPad) {
            _headCircle = [[CCamCircleView alloc] initWithFrame:CGRectMake(0, 0, (_animationControl.bounds.size.height-CCamThinNaviHeight)-10,(_animationControl.bounds.size.height-CCamThinNaviHeight)-10)];
            [_headCircle setCenter:CGPointMake(_animationControl.bounds.size.width*0.75, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2)];
        }else{
            _headCircle = [[CCamCircleView alloc] initWithFrame:CGRectMake(0, 0, _animationControl.bounds.size.width/2*0.8,_lightControl.bounds.size.width/2*0.8)];
            [_headCircle setCenter:CGPointMake(_animationControl.bounds.size.width*0.75, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2)];
        }
        
        [_headCircle.circleBG setImage:[UIImage imageNamed:@"headCircle"]];
        [_animationControl addSubview:_headCircle];
        [_headCircle setDelegate:self];
        
//        _headCircleMask = [[UIView alloc] initWithFrame:_headCircle.frame];
//        [_headCircleMask.layer setMasksToBounds:YES];
//        [_headCircleMask.layer setCornerRadius:_headCircleMask.frame.size.height/2];
//        [_headCircleMask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
//        [_animationControl addSubview:_headCircleMask];
//        [_headCircleMask setHidden:YES];
    }
}
- (void)SetAnimationControlAppear{
    [self SetLightControlDisappear];
    CGRect frame =CGRectMake(0, CCamThinNaviHeight+CCamViewWidth, CCamViewWidth, CCamViewHeight-CCamThinNaviHeight-CCamViewWidth);
    POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    ani.fromValue =[NSValue valueWithCGRect:_animationControl.frame];
    ani.toValue = [NSValue valueWithCGRect:frame];
    ani.beginTime = CACurrentMediaTime();
    ani.duration = 0.25f;
    [_animationControl pop_addAnimation:ani forKey:@"position"];
    [_navigationSurface setHidden:NO];
}
- (void)setAnimationInfo:(NSString *)info{
    NSError *error;
    NSDictionary *infoDic =[NSJSONSerialization JSONObjectWithData:[info dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (!_currentAnimationInfo) {
        _currentAnimationInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [_currentAnimationInfo removeAllObjects];
    [_currentAnimationInfo addEntriesFromDictionary:infoDic];
    _currentPoses = [infoDic objectForKey:@"mPoseList"];
    _currentFaces = [infoDic objectForKey:@"mFaceList"];
    
    if ([_currentFaces count]<2) {
        [_lastFaceBtn setHidden:YES];
        [_nextFaceBtn setHidden:YES];
    }else{
        [_nextFaceBtn setHidden:NO];
        [_lastFaceBtn setHidden:NO];
    }
    if ([_currentPoses count]<2) {
        [_lastPoseBtn setHidden:YES];
        [_nextPoseBtn setHidden:YES];
    }else{
        [_lastPoseBtn setHidden:NO];
        [_nextPoseBtn setHidden:NO];
    }
    
    NSString *poseTitle = [[_currentAnimationInfo objectForKey:@"mSelectPose"] stringByReplacingOccurrencesOfString:@"pose" withString:Babel(@"动作")];
    NSString *lookTitle = [[_currentAnimationInfo objectForKey:@"mSelectFace"] stringByReplacingOccurrencesOfString:@"face" withString:Babel(@"表情")];
    
    [_currentPoseBtn setTitle:poseTitle forState:UIControlStateNormal];
    if ([[infoDic objectForKey:@"mSelectFace"] isEqualToString:@""]) {
        [_currentAnimationInfo setObject:@"face1" forKey:@"mSelectFace"];
    }
    [_currentFaceBtn setTitle:lookTitle forState:UIControlStateNormal];
}

- (void)changeNextPose{
    NSInteger index = [_currentPoses indexOfObject:[_currentAnimationInfo objectForKey:@"mSelectPose"]];
    index ++;
    if (index == [_currentPoses count]) {
        index = 0;
    }
    [_currentAnimationInfo setObject:[_currentPoses objectAtIndex:index] forKey:@"mSelectPose"];
    
    NSString *btnTitle = [[_currentAnimationInfo objectForKey:@"mSelectPose"] stringByReplacingOccurrencesOfString:@"pose" withString:Babel(@"动作")];
    
    [_currentPoseBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self changePoseOrFace:[_currentAnimationInfo objectForKey:@"mSelectPose"]];

}
- (void)changeLastPose{
    NSInteger index = [_currentPoses indexOfObject:[_currentAnimationInfo objectForKey:@"mSelectPose"]];
    index --;
    if (index <0) {
        index = [_currentPoses count]-1;
    }
    [_currentAnimationInfo setObject:[_currentPoses objectAtIndex:index] forKey:@"mSelectPose"];
    
    NSString *btnTitle = [[_currentAnimationInfo objectForKey:@"mSelectPose"] stringByReplacingOccurrencesOfString:@"pose" withString:Babel(@"动作")];
    
    [_currentPoseBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self changePoseOrFace:[_currentAnimationInfo objectForKey:@"mSelectPose"]];

}
- (void)changeNextFace{
    NSInteger index = [_currentFaces indexOfObject:[_currentAnimationInfo objectForKey:@"mSelectFace"]];
    index ++;
    if (index == [_currentFaces count]) {
        index = 0;
    }
    [_currentAnimationInfo setObject:[_currentFaces objectAtIndex:index] forKey:@"mSelectFace"];
    
    NSString *btnTitle = [[_currentAnimationInfo objectForKey:@"mSelectFace"] stringByReplacingOccurrencesOfString:@"face" withString:Babel(@"表情")];
    
    [_currentFaceBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self changePoseOrFace:[_currentAnimationInfo objectForKey:@"mSelectFace"]];

}
- (void)changeLastFace{
    NSInteger index = [_currentFaces indexOfObject:[_currentAnimationInfo objectForKey:@"mSelectFace"]];
    index --;
    if (index <0) {
        index = [_currentFaces count]-1;
    }
    [_currentAnimationInfo setObject:[_currentFaces objectAtIndex:index] forKey:@"mSelectFace"];
    
    NSString *btnTitle = [[_currentAnimationInfo objectForKey:@"mSelectFace"] stringByReplacingOccurrencesOfString:@"face" withString:Babel(@"表情")];
    
    [_currentFaceBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self changePoseOrFace:[_currentAnimationInfo objectForKey:@"mSelectFace"]];
}
- (void)changePoseOrFace:(NSString*)info{
    UnitySendMessage(UnityController.UTF8String, "ChangeCharacterAnimation", info.UTF8String);
}
- (void)SetAnimationControlDisappear{
    CGRect frame =CGRectMake(0, CCamViewHeight, CCamViewWidth, CCamViewHeight-CCamThinNaviHeight-CCamViewWidth);
    POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    ani.fromValue =[NSValue valueWithCGRect:_animationControl.frame];
    ani.toValue = [NSValue valueWithCGRect:frame];
    ani.beginTime = CACurrentMediaTime();
    ani.duration = 0.25f;
    [_animationControl pop_addAnimation:ani forKey:@"position"];
    [_navigationSurface setHidden:YES];
}
- (void)setHeadDirectionAvilable:(BOOL)avilable X:(CGFloat)x andY:(CGFloat)y{
    if (avilable) {
//        [_headCircleMask setHidden:YES];
        [_headCircle setHidden:NO];
        [_headCircle setUserInteractionEnabled:YES];
        [_headCircle.circlePoint setUserInteractionEnabled:YES];
        [_headCircle.circlePoint setCenter:CGPointMake(_headCircle.bounds.size.width/2+x*0.9*0.5*_headCircle.bounds.size.width, _headCircle.bounds.size.height/2+y*0.9*0.5*_headCircle.bounds.size.height)];
        
        [_currentPoseBtn setCenter:CGPointMake(_animationControl.bounds.size.width*0.25, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_lastPoseBtn setCenter:CGPointMake(_currentPoseBtn.center.x-5-(_currentPoseBtn.bounds.size.width+_lastPoseBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_nextPoseBtn setCenter:CGPointMake(_currentPoseBtn.center.x+5+(_currentPoseBtn.bounds.size.width+_nextPoseBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_currentFaceBtn setCenter:CGPointMake(_animationControl.bounds.size.width*0.25, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
        [_lastFaceBtn setCenter:CGPointMake(_currentFaceBtn.center.x-5-(_currentFaceBtn.bounds.size.width+_lastFaceBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
        [_nextFaceBtn setCenter:CGPointMake(_currentFaceBtn.center.x+5+(_currentFaceBtn.bounds.size.width+_nextFaceBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
        
    }else{
        [_headCircle setHidden:YES];
        [_headCircle setUserInteractionEnabled:NO];
        [_headCircle.circlePoint setUserInteractionEnabled:NO];
        [_headCircle.circlePoint setCenter:CGPointMake(_headCircle.bounds.size.width/2, _headCircle.bounds.size.height/2)];
        
        [_currentPoseBtn setCenter:CGPointMake(_animationControl.bounds.size.width/2, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_lastPoseBtn setCenter:CGPointMake(_currentPoseBtn.center.x-5-(_currentPoseBtn.bounds.size.width+_lastPoseBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_nextPoseBtn setCenter:CGPointMake(_currentPoseBtn.center.x+5+(_currentPoseBtn.bounds.size.width+_nextPoseBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2-30)];
        [_currentFaceBtn setCenter:CGPointMake(_animationControl.bounds.size.width/2, (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
        [_lastFaceBtn setCenter:CGPointMake(_currentFaceBtn.center.x-5-(_currentFaceBtn.bounds.size.width+_lastFaceBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
        [_nextFaceBtn setCenter:CGPointMake(_currentFaceBtn.center.x+5+(_currentFaceBtn.bounds.size.width+_nextFaceBtn.bounds.size.width)/2,  (_animationControl.bounds.size.height-CCamThinNaviHeight)/2+30)];
    }
}
- (void)SetLightControlAppear{
    [self SetAnimationControlDisappear];
    CGRect frame =CGRectMake(0, CCamThinNaviHeight+CCamViewWidth, CCamViewWidth, CCamViewHeight-CCamThinNaviHeight-CCamViewWidth);
    POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    ani.fromValue =[NSValue valueWithCGRect:_animationControl.frame];
    ani.toValue = [NSValue valueWithCGRect:frame];
    ani.beginTime = CACurrentMediaTime();
    ani.duration = 0.25f;
    [ani setCompletionBlock:^(POPAnimation *ani, BOOL finish) {
        if (finish) {
            if ([TutorialHelper sharedManager].autoShowLightTutorial) {
                [[TutorialHelper sharedManager] callLightTutorialView];
            }

        }
    }];
    [_lightControl pop_addAnimation:ani forKey:@"position"];
    [_navigationSurface setHidden:NO];
}
- (void)setLightDirectionX:(CGFloat)x andY:(CGFloat)y{
    [_lightCircle.circlePoint setCenter:CGPointMake(_lightCircle.bounds.size.width/2+x*0.9*0.5*_lightCircle.bounds.size.width, _lightCircle.bounds.size.height/2+y*0.9*0.5*_lightCircle.bounds.size.height)];
}
- (void)setLightStrength:(CGFloat)strength{
    [_lightSlider setProgress:strength];
}
- (void)setShadowStrength:(CGFloat)strength{
    [_shadowSlider setProgress:strength];
}
- (void)SetLightControlDisappear{
    CGRect frame =CGRectMake(0, CCamViewHeight, CCamViewWidth, CCamViewHeight-CCamThinNaviHeight-CCamViewWidth);
    POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    ani.fromValue =[NSValue valueWithCGRect:_lightControl.frame];
    ani.toValue = [NSValue valueWithCGRect:frame];
    ani.beginTime = CACurrentMediaTime();
    ani.duration = 0.25f;
    [_lightControl pop_addAnimation:ani forKey:@"position"];
    [_navigationSurface setHidden:YES];
}
- (void)setLightControlView{
    if (!_lightControl) {
        _lightControl = [[UIScrollView alloc] init];
        [_lightControl setFrame:CGRectMake(0, CCamViewHeight, CCamViewWidth, CCamViewHeight-CCamThinNaviHeight-CCamViewWidth)];
        [_lightControl setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_lightControl];
        
        UIView *lightControlBar = [[UIView alloc] initWithFrame:CGRectMake(0, _lightControl.bounds.size.height-CCamThinNaviHeight, CCamViewWidth, CCamThinNaviHeight)];
        [lightControlBar setBackgroundColor:CCamViewBackgroundColor];
        [_lightControl addSubview:lightControlBar];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lightControlBar.bounds.size.width, lightControlBar.bounds.size.height)];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setText:Babel(@"灯光阴影调节")];
        [title setTextColor:CCamGrayTextColor];
        [title setFont:[UIFont boldSystemFontOfSize:17.0]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [lightControlBar addSubview:title];
        
        UIButton *lightControlRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lightControlRightBtn setImage:[[UIImage imageNamed:@"controlOK"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [lightControlRightBtn setTintColor:CCamRedColor];
        [lightControlRightBtn sizeToFit];
        [lightControlBar addSubview:lightControlRightBtn];
        [lightControlRightBtn setCenter:CGPointMake(lightControlBar.bounds.size.width-10-lightControlRightBtn.bounds.size.width/2, lightControlBar.bounds.size.height/2)];
        [lightControlRightBtn addTarget:self action:@selector(SetLightControlDisappear) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *lightHelp = [UIButton new];
        [lightHelp setImage:[[UIImage imageNamed:@"helpIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [lightHelp setTintColor:CCamRedColor];
        [lightHelp setFrame:CGRectMake(0, 0, 44, 44)];
        [lightHelp setCenter:CGPointMake(_lightControl.bounds.size.width-22,22)];
        [_lightControl addSubview:lightHelp];
        [lightHelp addTarget:self action:@selector(callLightTutorial) forControlEvents:UIControlEventTouchUpInside];
    }
    
    BOOL isPad = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        isPad = YES;
    }

    
    if (!_lightCircle) {
        
        if (isPad) {
            _lightCircle = [[CCamCircleView alloc] initWithFrame:CGRectMake(0, 0, (_lightControl.bounds.size.height-CCamThinNaviHeight)-10,(_lightControl.bounds.size.height-CCamThinNaviHeight)-10)];
            [_lightCircle setCenter:CGPointMake(_lightControl.bounds.size.width*0.75, (_lightControl.bounds.size.height-CCamThinNaviHeight)/2)];
        }else{
            _lightCircle = [[CCamCircleView alloc] initWithFrame:CGRectMake(0, 0, _lightControl.bounds.size.width/2*0.8,_lightControl.bounds.size.width/2*0.8)];
            [_lightCircle setCenter:CGPointMake(_lightControl.bounds.size.width*0.75, (_lightControl.bounds.size.height-CCamThinNaviHeight)/2)];
        }
        [_lightCircle.circleBG setImage:[UIImage imageNamed:@"lightCircle"]];
        [_lightControl addSubview:_lightCircle];
        [_lightCircle setDelegate:self];
    }
    
    if (!_lightSlider) {

        _lightSlider = [[WCCircularSlider alloc] init];
        [_lightSlider setBackgroundColor:[UIColor clearColor]];
        
        if (isPad) {
            [_lightSlider setFrame:CGRectMake(0, 0, (_lightControl.bounds.size.height-CCamThinNaviHeight)-10,(_lightControl.bounds.size.height-CCamThinNaviHeight)-10)];
            [_lightSlider setCenter:CGPointMake(_lightControl.bounds.size.width*0.25, (_lightControl.bounds.size.height-CCamThinNaviHeight)/2)];
        }else{
            [_lightSlider setFrame:CGRectMake(0, 0, _lightControl.bounds.size.width/2*0.8,_lightControl.bounds.size.width/2*0.8)];
            [_lightSlider setCenter:CGPointMake(_lightControl.bounds.size.width*0.25, (_lightControl.bounds.size.height-CCamThinNaviHeight)/2)];
        }
        
        
        [_lightSlider setStartAngle:-90];
        [_lightSlider setCutoutAngle:60];
        [_lightSlider setProgress:0.5];
        [_lightSlider setLineWidth:5];
        [_lightSlider setGuideLineColor:CCamBackgoundGrayColor];
        [_lightSlider setTintColor:CCamRedColor];
        [_lightSlider addTarget:self action:@selector(lightStrengthChanged:) forControlEvents:UIControlEventValueChanged];
        [_lightControl addSubview:_lightSlider];
        UILabel *lightSliderTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [lightSliderTitle setUserInteractionEnabled:NO];
        [lightSliderTitle setCenter:CGPointMake(_lightSlider.center.x, _lightSlider.center.y+_lightSlider.bounds.size.height/2-15)];
        [lightSliderTitle setTextAlignment:NSTextAlignmentCenter];
        [lightSliderTitle setText:Babel(@"灯光强度")];
        [lightSliderTitle setTextColor:CCamGrayTextColor];
        [lightSliderTitle setFont:[UIFont boldSystemFontOfSize:11.0]];
        [lightSliderTitle setBackgroundColor:[UIColor clearColor]];
        [_lightControl addSubview:lightSliderTitle];
    }
    
    if (!_shadowSlider) {

        _shadowSlider = [[WCCircularSlider alloc] init];
        [_shadowSlider setBackgroundColor:[UIColor clearColor]];
        if (isPad) {
            [_shadowSlider setFrame:CGRectMake(0, 0, (_lightControl.bounds.size.height-CCamThinNaviHeight)-40,(_lightControl.bounds.size.height-CCamThinNaviHeight)-40)];
            [_shadowSlider setCenter:CGPointMake(_lightControl.bounds.size.width*0.25, (_lightControl.bounds.size.height-CCamThinNaviHeight)/2)];
        }else{
            [_shadowSlider setFrame:CGRectMake(0, 0, _lightControl.bounds.size.width/3*0.8,_lightControl.bounds.size.width/3*0.8)];
            [_shadowSlider setCenter:CGPointMake(_lightControl.bounds.size.width*0.25, (_lightControl.bounds.size.height-CCamThinNaviHeight)/2)];
        }
        
        
        [_shadowSlider setStartAngle:-90];
        [_shadowSlider setCutoutAngle:90];
        [_shadowSlider setProgress:0.0];
        [_shadowSlider setLineWidth:5];
        [_shadowSlider setGuideLineColor:CCamBackgoundGrayColor];
        [_shadowSlider setTintColor:CCamRedColor];
        [_shadowSlider addTarget:self action:@selector(ShadowStrengthChanged:) forControlEvents:UIControlEventValueChanged];
        [_lightControl addSubview:_shadowSlider];
        UILabel *shadowSliderTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 20)];
        [shadowSliderTitle setUserInteractionEnabled:NO];
        [shadowSliderTitle setCenter:CGPointMake(_shadowSlider.center.x, _shadowSlider.center.y+_shadowSlider.bounds.size.height/2-15)];
        [shadowSliderTitle setTextAlignment:NSTextAlignmentCenter];
        [shadowSliderTitle setText:Babel(@"阴影强度")];
        [shadowSliderTitle setTextColor:CCamGrayTextColor];
        [shadowSliderTitle setFont:[UIFont boldSystemFontOfSize:11.0]];
        [shadowSliderTitle setBackgroundColor:[UIColor clearColor]];
        [_lightControl addSubview:shadowSliderTitle];
    }
}
- (void)lightStrengthChanged:(WCCircularSlider*)slider{
    NSString *strength = [NSString stringWithFormat:@"%f",slider.progress];
    UnitySendMessage(UnityController.UTF8String, "OnSliderChangeLightIntensity", strength.UTF8String);
}
- (void)ShadowStrengthChanged:(WCCircularSlider*)slider{
    NSString *strength = [NSString stringWithFormat:@"%f",slider.progress];
    UnitySendMessage(UnityController.UTF8String, "ChangeShadowIntensity", strength.UTF8String);
}
- (void)pointValueChanged:(CCamCircleView *)circle{
    if (circle == _lightCircle) {
      
        NSString *direction = [NSString stringWithFormat:@"%f|%f",2*circle.x/circle.bounds.size.width/0.9,2*circle.y/circle.bounds.size.height/0.9];
        UnitySendMessage(UnityController.UTF8String, "ShadowPickerValueChanged", direction.UTF8String);

    }else if (circle == _headCircle){
        NSString *direction = [NSString stringWithFormat:@"%f|%f",2*circle.x/circle.bounds.size.width/0.9,2*circle.y/circle.bounds.size.height/0.9];
        UnitySendMessage(UnityController.UTF8String, "SetLookScreenPosStr", direction.UTF8String);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [UnityGetGLView() touchesBegan:touches withEvent:event];
}
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [UnityGetGLView() touchesMoved:touches withEvent:event];
}
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [super touchesCancelled:touches withEvent:event];
//    [UnityGetGLView() touchesCancelled:touches withEvent:event];
//}
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesEnded:touches withEvent:event];
//    [UnityGetGLView() touchesEnded:touches withEvent:event];
//}


#pragma mark - getter / setter

- (NSMutableArray *)segments{
    _segments = [[NSMutableArray alloc] initWithObjects:@"3D角色",@"贴纸",@"滤镜",@"擦除", nil];
    return _segments;
}
- (NSMutableArray *)segmentsShow{
    _segmentsShow = [[NSMutableArray alloc] initWithObjects:Babel(@"3D角色"),Babel(@"贴纸"),Babel(@"滤镜"),Babel(@"擦除"), nil];
    return _segmentsShow;
}
- (void)backToAlbum{
    [DataHelper sharedManager].ccamVC = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view setMultipleTouchEnabled:YES];
//    [self.view setUserInteractionEnabled:NO];
    
    NSString *userGroup = [NSString stringWithFormat:@"ug%@",[[AuthorizeHelper sharedManager] getUserGroup]];//测试
    NSString *version = [[SettingHelper sharedManager] getSettingAttributeWithKey:CCamSettingTagInfoVersion];
    NSString *versionGroup = @"";
    if (![version isEqualToString:@""]) {
        versionGroup = [[version componentsSeparatedByString:@"_"] objectAtIndex:3];
    }
    
    if ([userGroup isEqualToString:versionGroup]) {
        if ([DataHelper sharedManager].series.count == 0) {
            [[DataHelper sharedManager] getLocalSeriesInfo];
            [[DataHelper sharedManager] updateSeriesInfo];
        }
        if ([DataHelper sharedManager].stickerSets.count == 0) {
            [[DataHelper sharedManager] getLocalStickerSetsInfo];
            [[DataHelper sharedManager] updateStickerSetsInfo];
        }
    }else{
        [[DataHelper sharedManager] updateSeriesInfo];
        [[DataHelper sharedManager] updateStickerSetsInfo];
    }
    
    
    
    POPBasicAnimation *ani = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    ani.fromValue = [NSNumber numberWithFloat:1.0];
    ani.toValue = [NSNumber numberWithFloat:0.0];
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani.duration = 0.25;
    [_bgView pop_addAnimation:ani forKey:@"alphaAnimation"];
    [self scrollToTargetSerie];
}
- (UIView *)setNavigationView{
    
    _bgView = [[UIView alloc] initWithFrame:self.view.frame];
    [_bgView setBackgroundColor:[UIColor blackColor]];
    [_bgView setUserInteractionEnabled:NO];
    [self.view addSubview:_bgView];
    
    _navigationView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamThinNaviHeight)];
    [_navigationView setBackgroundColor:CCamSegmentColor];
    [self.view addSubview:_navigationView];
    
    _navigationSurface = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, CCamThinNaviHeight)];
    [_navigationSurface setBackgroundColor:CCamSegmentColor];
    [self.view addSubview:_navigationSurface];
    [_navigationSurface setHidden:YES];
    
    _navigationTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _navigationView.frame.size.width, CCamThinNaviHeight)];
    [_navigationView addSubview:_navigationTitle];
    [_navigationTitle setBackgroundColor:CCamSegmentColor];
    [_navigationTitle setText:Babel(@"3D角色")];
    [_navigationTitle setTextAlignment:NSTextAlignmentCenter];
    [_navigationTitle setTextColor:[UIColor whiteColor]];
    [_navigationTitle setFont:[UIFont boldSystemFontOfSize:17.0]];
    
    
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setShowsTouchWhenHighlighted:YES];
    [_backButton setImage:[[UIImage imageNamed:@"backButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_backButton sizeToFit];
    [_backButton setFrame:CGRectMake(0, 0, _backButton.frame.size.width+30, _navigationView.frame.size.height)];
    [_backButton setCenter:CGPointMake(_backButton.frame.size.width/2, _navigationView.frame.size.height/2)];
    [_backButton setTintColor:[UIColor whiteColor]];
    [_backButton addTarget:self action:@selector(backToAlbum) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:_backButton];
        
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setShowsTouchWhenHighlighted:YES];
    [_nextButton setTitle:Babel(@"下一步") forState:UIControlStateNormal];
    [_nextButton setBackgroundColor:[UIColor whiteColor]];
    [_nextButton setTitleColor:CCamRedColor forState:UIControlStateNormal];
    [_nextButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
    [_nextButton sizeToFit];
    [_nextButton setFrame:CGRectMake(0, 0, _nextButton.frame.size.width+24, _nextButton.frame.size.height+2)];
    [_nextButton setCenter:CGPointMake(_navigationView.frame.size.width-15-_nextButton.frame.size.width/2, _navigationView.frame.size.height/2)];
    [_nextButton.layer setCornerRadius:_nextButton.frame.size.height/2];
    [_nextButton addTarget:self action:@selector(goToSubmit) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:_nextButton];
    
    return _navigationView;
}
- (void)hideEverything{
    [[iOSBindingManager sharedManager] editRemoveNativeSurface];
}
- (void)goToSubmit{
            UnitySendMessage("_plantFormInteractions", "OnClickTabBtn", "none");
    [self performSelector:@selector(delayToSubmit) withObject:nil afterDelay:0.1f];
}

- (void)delayToSubmit{
    UnitySendMessage(UnityController.UTF8String, "OnClickConfirmToCaptureImage", "");
    UnitySendMessage("_plantFormInteractions", "OnClickTabBtn", "none");
    CCamSubmitViewController *submit = [[CCamSubmitViewController alloc] init];
    [self.navigationController pushViewController:submit animated:YES];
}
- (UICollectionView *)getCollectionWith:(CCamCollectionViewType)type{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.tag = type;
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    switch (type) {
        case CCamSegmentCollectionView:
            [collectionView setFrame:CGRectMake(0, CCamThinNaviHeight+CCamViewWidth, CCamViewWidth, CCamThinSegHeight)];
            [collectionView setBackgroundColor:CCamSegmentColor];
            [collectionView registerClass:[CCamSegmentCell class] forCellWithReuseIdentifier:@"segmentCell"];
            [collectionView setScrollEnabled:NO];[collectionView setBounces:NO];
            [self.view addSubview:collectionView];
            return collectionView;
            break;
        case CCamSegmentContentCollectionView:
            [collectionView setFrame:CGRectMake(0, CCamThinNaviHeight+CCamViewWidth+CCamThinSegHeight, CCamViewWidth, CCamViewHeight-CCamViewWidth-CCamThinSegHeight-CCamThinNaviHeight)];
            [collectionView registerClass:[CCamSegmentContentCell class] forCellWithReuseIdentifier:@"segmentContentCell_Characters"];
            [collectionView registerClass:[CCamSegmentContentCell class] forCellWithReuseIdentifier:@"segmentContentCell_Stickers"];
            [collectionView registerClass:[CCamSegmentContentCell class] forCellWithReuseIdentifier:@"segmentContentCell_Filters"];
            [collectionView registerClass:[CCamSegmentContentCell class] forCellWithReuseIdentifier:@"segmentContentCell_Erase"];
            [collectionView setScrollEnabled:NO];[collectionView setBounces:NO];
            [self.view addSubview:collectionView];
            return collectionView;
            break;
        case CCamSerieCollectionView:
            [collectionView setBackgroundColor:[UIColor whiteColor]];
            [collectionView registerClass:[CCamSerieCell class] forCellWithReuseIdentifier:@"serieCell"];
            [collectionView setBounces:NO];
            return collectionView;
            break;
        case CCamSerieContentCollectionView:
            [collectionView setBackgroundColor:CCamExLightGrayColor];
            [collectionView registerClass:[CCamSerieContentCell class] forCellWithReuseIdentifier:@"serieContentCell"];
            [collectionView setBounces:NO];
            [collectionView setPagingEnabled:YES];
            return collectionView;
            break;
        case CCamCharacterCollectionView:
            [collectionView setBackgroundColor:CCamExLightGrayColor];
            [collectionView registerClass:[CCamCharacterCell class] forCellWithReuseIdentifier:@"characterCell"];
            [collectionView setBounces:NO];
            return collectionView;
            break;
        case CCamStickerSetCollectionView:
            [collectionView setBackgroundColor:[UIColor whiteColor]];
            [collectionView registerClass:[CCStickerSetCell class] forCellWithReuseIdentifier:@"stickerSetCell"];
            [collectionView setBounces:NO];
            return collectionView;
            break;
        case CCamStickerSetContentCollectionView:
            [collectionView setBackgroundColor:CCamExLightGrayColor];
            [collectionView registerClass:[CCStickerSetContentCell class] forCellWithReuseIdentifier:@"stickerSetContentCell"];
            [collectionView setBounces:NO];
            [collectionView setPagingEnabled:YES];
            return collectionView;
            break;
        case CCamFilterCollectionView:
            [collectionView setBackgroundColor:[UIColor whiteColor]];
            [collectionView registerClass:[CCamFilterCell class] forCellWithReuseIdentifier:@"filterCell"];
            [collectionView setBounces:NO];
            return collectionView;
            break;
        default:
            return nil;
            break;
    }
}


#pragma mark - UICollectionView delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == CCamSegmentCollectionView) {
        return CGSizeMake (collectionView.bounds.size.width/4, collectionView.bounds.size.height);
    }else if (collectionView.tag == CCamSegmentContentCollectionView){
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
    }else if (collectionView.tag == CCamSerieCollectionView || collectionView.tag == CCamStickerSetCollectionView) {
        return CGSizeMake(collectionView.bounds.size.height*1.5, collectionView.bounds.size.height);
    }else if (collectionView.tag == CCamSerieContentCollectionView || collectionView.tag == CCamStickerSetContentCollectionView) {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
    }else if (collectionView.tag == CCamCharacterCollectionView) {
        return CGSizeMake(collectionView.bounds.size.height/2-4, collectionView.bounds.size.height/2-4);
    }else if (collectionView.tag == CCamFilterCollectionView){
        return CGSizeMake(collectionView.bounds.size.height, collectionView.bounds.size.height);
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
    if (collectionView.tag == CCamSegmentCollectionView) {
        return [_segments count];
    }else if (collectionView.tag == CCamSegmentContentCollectionView){
        return [_segments count];
    }else if (collectionView.tag == CCamSerieCollectionView||collectionView.tag == CCamSerieContentCollectionView){
        return [[DataHelper sharedManager].series count];
    }else if (collectionView.tag == CCamStickerSetCollectionView||collectionView.tag == CCamStickerSetContentCollectionView){
        return [[DataHelper sharedManager].stickerSets count];
    }else if (collectionView.tag == CCamFilterCollectionView){
        return [_filters count];
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     static NSString *cellIdentifer;
    
    if (collectionView.tag == CCamSegmentCollectionView) {
        cellIdentifer = @"segmentCell";
        CCamSegmentCell *segCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
        [segCell.titleLabel setText:[_segmentsShow objectAtIndex:indexPath.row]];
        if (indexPath.row == 0) {
            _characterTitleShaker = segCell.shaker;
        }
        return segCell;
    }else if (collectionView.tag == CCamSegmentContentCollectionView){
        CCamSegmentContentCell *segContentCell;
        if (indexPath.row ==0) {
            cellIdentifer = @"segmentContentCell_Characters";
            segContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
            if (segContentCell.callSeriesButton == nil) {
                segContentCell.callSeriesButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [segContentCell.callSeriesButton setBackgroundColor:CCamRedColor];
                [segContentCell.callSeriesButton setTintColor:[UIColor whiteColor]];
                [segContentCell.callSeriesButton setImage:[[UIImage imageNamed:@"plusButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [segContentCell.callSeriesButton setFrame:CGRectMake(0, segContentCell.frame.size.height-CCamThinSerieHeight, CCamThinSerieHeight*1.5, CCamThinSerieHeight)];
                [segContentCell.callSeriesButton addTarget:self action:@selector(updateSeries) forControlEvents:UIControlEventTouchUpInside];
                [segContentCell.contentView addSubview:segContentCell.callSeriesButton];
            }
            if (segContentCell.serieCollection == nil) {
                segContentCell.serieCollection = [self getCollectionWith:CCamSerieCollectionView];
                [segContentCell.serieCollection setFrame:CGRectMake(CCamThinSerieHeight*1.5, segContentCell.frame.size.height-CCamThinSerieHeight, segContentCell.frame.size.width-CCamThinSerieHeight*1.5, CCamThinSerieHeight)];
                [segContentCell.contentView addSubview:segContentCell.serieCollection];
                _serieCollection = segContentCell.serieCollection;
            }
            if (segContentCell.serieContentCollection == nil) {
                segContentCell.serieContentCollection = [self getCollectionWith:CCamSerieContentCollectionView];
                [segContentCell.serieContentCollection setFrame:CGRectMake(0, 0, segContentCell.frame.size.width, segContentCell.frame.size.height- CCamThinSerieHeight)];
                [segContentCell.contentView addSubview:segContentCell.serieContentCollection];
                _serieContentCollection = segContentCell.serieContentCollection;
            }

        }else if (indexPath.row ==1) {
            cellIdentifer = @"segmentContentCell_Stickers";
            segContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
            if (segContentCell.callSeriesButton == nil) {
                segContentCell.callSeriesButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [segContentCell.callSeriesButton setBackgroundColor:CCamRedColor];
                [segContentCell.callSeriesButton setTintColor:[UIColor whiteColor]];
                [segContentCell.callSeriesButton setImage:[[UIImage imageNamed:@"plusButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [segContentCell.callSeriesButton setFrame:CGRectMake(0, segContentCell.frame.size.height-CCamThinSerieHeight, CCamThinSerieHeight*1.5, CCamThinSerieHeight)];
                [segContentCell.callSeriesButton addTarget:self action:@selector(updateStickerSets) forControlEvents:UIControlEventTouchUpInside];
                [segContentCell.contentView addSubview:segContentCell.callSeriesButton];
            }
            if (segContentCell.stickerSetCollection == nil) {
                segContentCell.stickerSetCollection = [self getCollectionWith:CCamStickerSetCollectionView];
                [segContentCell.stickerSetCollection setFrame:CGRectMake(CCamThinSerieHeight*1.5, segContentCell.frame.size.height-CCamThinSerieHeight, segContentCell.frame.size.width-CCamThinSerieHeight*1.5, CCamThinSerieHeight)];
                [segContentCell.contentView addSubview:segContentCell.stickerSetCollection];
                _stickerSetCollection = segContentCell.stickerSetCollection;
            }
            if (segContentCell.stickerSetContentCollection == nil) {
                segContentCell.stickerSetContentCollection = [self getCollectionWith:CCamStickerSetContentCollectionView];
                [segContentCell.stickerSetContentCollection setFrame:CGRectMake(0, 0, segContentCell.frame.size.width, segContentCell.frame.size.height- CCamThinSerieHeight)];
                [segContentCell.contentView addSubview:segContentCell.stickerSetContentCollection];
                _stickerSetContentCollection = segContentCell.stickerSetContentCollection;
            }

            
        }else if (indexPath.row ==2) {
            cellIdentifer = @"segmentContentCell_Filters";
            segContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
            if (segContentCell.filterCollection == nil) {
                segContentCell.filterCollection = [self getCollectionWith:CCamFilterCollectionView];
                [segContentCell.filterCollection setFrame:CGRectMake(10, segContentCell.bounds.size.height/2, CCamViewWidth-20, segContentCell.bounds.size.height/3)];
                [segContentCell.contentView addSubview:segContentCell.filterCollection];
                _filterCollection = segContentCell.filterCollection;
            
                segContentCell.filterSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, segContentCell.bounds.size.width/2, CCamThinSerieHeight)];
                [segContentCell.filterSlider setMinimumValue:0];
                [segContentCell.filterSlider setMaximumValue:1];
                [segContentCell.filterSlider setMinimumTrackTintColor:CCamGrayTextColor];
                [segContentCell.filterSlider setMaximumTrackTintColor:CCamGrayTextColor];
                [segContentCell.filterSlider setThumbTintColor:CCamRedColor];
                
                [segContentCell.filterSlider setCenter:CGPointMake(segContentCell.bounds.size.width/2, segContentCell.bounds.size.height/4)];
                [segContentCell.filterSlider addTarget:self action:@selector(getFilterSliderValue:) forControlEvents:UIControlEventValueChanged];
                [segContentCell.contentView addSubview:segContentCell.filterSlider];
                [segContentCell.filterSlider setValue:0.5 animated:YES];
                
            }
            
        }else if (indexPath.row ==3) {
            cellIdentifer = @"segmentContentCell_Erase";
            segContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
            
            BOOL isPad = NO;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                isPad = YES;
            }
            
            if (segContentCell.eraseView == nil) {
                segContentCell.eraseView = [[UIView alloc] initWithFrame:CGRectMake(0, segContentCell.bounds.size.height-CCamThinSerieHeight, segContentCell.bounds.size.width, CCamThinSerieHeight)];
                [segContentCell.eraseView setBackgroundColor:CCamBackgoundGrayColor];
                [segContentCell.contentView addSubview:segContentCell.eraseView];
                
                segContentCell.eraserResetButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [segContentCell.eraserResetButton setBackgroundColor:CCamRedColor];
                [segContentCell.eraserResetButton setTitle:Babel(@"重置") forState:UIControlStateNormal];
                [segContentCell.eraserResetButton.titleLabel setFont:[UIFont systemFontOfSize:14.]];
                [segContentCell.eraserResetButton setFrame:CGRectMake(15, 15, 50, 30)];
                [segContentCell.eraserResetButton setCenter:CGPointMake(40, segContentCell.eraseView.frame.size.height/2)];
                [segContentCell.eraserResetButton.layer setCornerRadius:15];
                [segContentCell.eraserResetButton.layer setMasksToBounds:YES];
                [segContentCell.eraserResetButton addTarget:self action:@selector(resetEraseImage) forControlEvents:UIControlEventTouchUpInside];
                [segContentCell.eraseView addSubview:segContentCell.eraserResetButton];
                
//                segContentCell.eraseTranLabel = [[UILabel alloc] init];
//                [segContentCell.eraseTranLabel setText:@"半透明"];
//                [segContentCell.eraseTranLabel setBackgroundColor:CCamBackgoundGrayColor];
//                [segContentCell.eraseTranLabel setTextColor:CCamGrayTextColor];
//                [segContentCell.eraseTranLabel setFont:[UIFont systemFontOfSize:14.0]];
//                [segContentCell.eraseTranLabel sizeToFit];
//                [segContentCell.eraseTranLabel setCenter:CGPointMake(30+segContentCell.eraseTranLabel.frame.size.width/2, segContentCell.eraseView.frame.size.height/2)];
//                [segContentCell.eraseView addSubview:segContentCell.eraseTranLabel];
//                
//                segContentCell.eraseTranSwitch = [[UISwitch alloc] init];
//                [segContentCell.eraseTranSwitch sizeToFit];
//                [segContentCell.eraseTranSwitch setCenter:CGPointMake(40+segContentCell.eraseTranLabel.frame.size.width+segContentCell.eraseTranSwitch.frame.size.width/2, segContentCell.eraseView.frame.size.height/2)];
//                [segContentCell.eraseTranSwitch setOnTintColor:CCamRedColor];
//                [segContentCell.eraseTranSwitch addTarget:self action:@selector(getEraseTranAppear:) forControlEvents:UIControlEventValueChanged];
//                [segContentCell.eraseView addSubview:segContentCell.eraseTranSwitch];
                
                segContentCell.eraseZoneSwitch = [[UISwitch alloc] init];
                [segContentCell.eraseZoneSwitch sizeToFit];
                [segContentCell.eraseZoneSwitch setCenter:CGPointMake(segContentCell.eraseView.frame.size.width-30-segContentCell.eraseZoneSwitch.frame.size.width/2, segContentCell.eraseView.frame.size.height/2)];
                [segContentCell.eraseZoneSwitch setOnTintColor:CCamRedColor];
                [segContentCell.eraseZoneSwitch addTarget:self action:@selector(getEraseZoneAppear:) forControlEvents:UIControlEventValueChanged];
                [segContentCell.eraseView addSubview:segContentCell.eraseZoneSwitch];
                
                segContentCell.eraseZoneLabel = [[UILabel alloc] init];
                [segContentCell.eraseZoneLabel setText:Babel(@"擦除区域")];
                [segContentCell.eraseZoneLabel setBackgroundColor:CCamBackgoundGrayColor];
                [segContentCell.eraseZoneLabel setTextColor:CCamGrayTextColor];
                [segContentCell.eraseZoneLabel setFont:[UIFont systemFontOfSize:14.0]];
                [segContentCell.eraseZoneLabel sizeToFit];
                [segContentCell.eraseZoneLabel setCenter:CGPointMake(segContentCell.eraseView.frame.size.width-40-segContentCell.eraseZoneSwitch.frame.size.width-segContentCell.eraseZoneLabel.frame.size.width/2, segContentCell.eraseView.frame.size.height/2)];
                [segContentCell.eraseView addSubview:segContentCell.eraseZoneLabel];
                
                NSArray *segAry = @[Babel(@"擦除"),Babel(@"恢复")];
                UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:segAry];
                
                if(isPad){
                    [seg setFrame:CGRectMake(0, 0, 140, CCamThinSerieHeight)];
                    [seg setCenter:CGPointMake(90 , (segContentCell.bounds.size.height-CCamThinSerieHeight)/2)];
                }else{
                    [seg setFrame:CGRectMake(0, 0, 200, CCamThinSerieHeight)];
                    [seg setCenter:CGPointMake(segContentCell.bounds.size.width/2 , segContentCell.bounds.size.height/2-44)];
                }
                
                
                [seg setSelectedSegmentIndex:0];
                [seg setTintColor:CCamRedColor];
                [seg setImage:[UIImage imageNamed:@"eraseButton"] forSegmentAtIndex:0];
                [seg setTitle:Babel(@"擦除") forSegmentAtIndex:0];
                [seg setImage:[UIImage imageNamed:@"unEraseButton"] forSegmentAtIndex:1];
                [seg setTitle:Babel(@"恢复") forSegmentAtIndex:1];
                [segContentCell.contentView addSubview:seg];
                
                self.eraseType = 1;
                
                [seg addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
                
                _eraseSeg = seg;
                
                UIView *sliderBG;
                
                if (isPad) {
                    sliderBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, segContentCell.bounds.size.width/2-30, 2)];
                    [sliderBG setCenter:CGPointMake(segContentCell.bounds.size.width-(sliderBG.bounds.size.width)/2-60, (segContentCell.bounds.size.height-CCamThinSerieHeight)/2)];
                }else{
                    sliderBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, segContentCell.bounds.size.width/2-30, 2)];
                    [sliderBG setCenter:CGPointMake(segContentCell.bounds.size.width/2, segContentCell.bounds.size.height-2*CCamThinSerieHeight)];
                }
                
                [sliderBG setBackgroundColor:CCamSwitchNormalColor];
                
                [segContentCell.contentView addSubview:sliderBG];
                
                for (int i = 0; i<5; i++) {
                    UIImageView *dot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7+i*3, 7+i*3)];
                    if (isPad) {
                        [dot setCenter:CGPointMake(sliderBG.frame.origin.x+i*sliderBG.bounds.size.width/4, sliderBG.center.y)];
                    }else{
                        [dot setCenter:CGPointMake(segContentCell.bounds.size.width/2-sliderBG.bounds.size.width/2+i*sliderBG.bounds.size.width/4, sliderBG.center.y)];
                    }
                    [dot setBackgroundColor:[UIColor whiteColor]];
                    [dot setImage:[[UIImage imageNamed:@"eraseDot"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                    [dot setTintColor:CCamSwitchNormalColor];
                    [segContentCell.contentView addSubview:dot];
                }
                
                segContentCell.eraseBrushSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, segContentCell.bounds.size.width/2, CCamThinSerieHeight)];
                [segContentCell.eraseBrushSlider setMinimumValue:0];
                [segContentCell.eraseBrushSlider setMaximumValue:4];
                [segContentCell.eraseBrushSlider setContinuous:NO];
                [segContentCell.eraseBrushSlider setMinimumTrackTintColor:[UIColor clearColor]];
                [segContentCell.eraseBrushSlider setMaximumTrackTintColor:[UIColor clearColor]];
                [segContentCell.eraseBrushSlider setThumbTintColor:CCamRedColor];
                
                [segContentCell.eraseBrushSlider setCenter:sliderBG.center];
                [segContentCell.eraseBrushSlider addTarget:self action:@selector(getSliderValue:) forControlEvents:UIControlEventValueChanged];
                [segContentCell.contentView addSubview:segContentCell.eraseBrushSlider];
                [segContentCell.eraseBrushSlider setValue:2 animated:YES];
                
                segContentCell.eraseHelpButton = [UIButton new];
                [segContentCell.eraseHelpButton setImage:[[UIImage imageNamed:@"helpIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                [segContentCell.eraseHelpButton setTintColor:CCamRedColor];
                [segContentCell.eraseHelpButton setFrame:CGRectMake(0, 0, 44, 44)];
                [segContentCell.eraseHelpButton setCenter:CGPointMake(sliderBG.center.x+sliderBG.frame.size.width/2+30, sliderBG.center.y)];
                [segContentCell.contentView addSubview:segContentCell.eraseHelpButton];
                [segContentCell.eraseHelpButton addTarget:self action:@selector(callEraseTutorial) forControlEvents:UIControlEventTouchUpInside];
                
                self.eraseSize = 2.0;
                [self setEraseOptions];
            }
            segContentCell.eraseTranSwitch.on = NO;
            segContentCell.eraseZoneSwitch.on = NO;
        }
        
        return segContentCell;
    }else if (collectionView.tag == CCamSerieCollectionView) {
        cellIdentifer = @"serieCell";
        CCamSerieCell *serieCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
        serieCell.serie = [[DataHelper sharedManager].series objectAtIndex:indexPath.row];
        
        [serieCell.serieImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,serieCell.serie.image_Mini]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL){
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            animation.fromValue = [NSNumber numberWithFloat:0.0];
            animation.toValue = [NSNumber numberWithFloat:1.0];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.duration = 0.15;
            [serieCell.serieImage pop_addAnimation:animation forKey:@"alphaAnimation"];
        }];
        
        return serieCell;
    }else if (collectionView.tag == CCamSerieContentCollectionView){
        cellIdentifer = @"serieContentCell";
        CCamSerieContentCell *serieContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
        serieContentCell.serie = [[DataHelper sharedManager].series objectAtIndex:indexPath.row];
        
        [serieContentCell reloadCharacters];
        
        CCCharacter *character = [serieContentCell.characterInfos firstObject];
        serieContentCell.surfaceView.tag = 7000+[character.characterID intValue];
        
        if (serieContentCell.countObj.number == 0) {
            [serieContentCell.surfaceView setHidden:NO];
//            [serieContentCell.surfaceView.surfaceBG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,serieContentCell.serie.image_Inner]] placeholderImage:nil];
            [serieContentCell.surfaceView.surfaceImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,serieContentCell.serie.image_Mini]] placeholderImage:nil];
//            SDWebImageManager *manager = [SDWebImageManager sharedManager];
//            [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,serieContentCell.serie.image_Mini]]
//                                  options:0
//                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                                     // progression tracking code
//                                 }
//                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                                    if (image) {
//                                        [serieContentCell.surfaceView.surfaceButton setImage:image forState:UIControlStateNormal];
//                                    }
//                                }];
            if ([[DownloadHelper sharedManager].downloadInfos objectForKey:[NSString stringWithFormat:@"Character%@",character.characterID]]) {
                NSString *progress =[[DownloadHelper sharedManager].downloadInfos objectForKey:[NSString stringWithFormat:@"Character%@",character.characterID]];
                [serieContentCell.surfaceView.surfaceProgress setProgress:[progress floatValue] animated:NO];
                [serieContentCell.surfaceView.surfaceProgress setHidden:NO];
                [serieContentCell.surfaceView.surfaceButton setEnabled:NO];
//                [serieContentCell.surfaceView.surfaceButton setHidden:YES];
            }else{
                [serieContentCell.surfaceView.surfaceProgress setProgress:0.0 animated:NO];
                [serieContentCell.surfaceView.surfaceProgress setHidden:YES];
//                [serieContentCell.surfaceView.surfaceButton setHidden:NO];
                [serieContentCell.surfaceView.surfaceButton setEnabled:YES];

            }
            
        }else{
            [serieContentCell.surfaceView setHidden:YES];
        }
        
        return serieContentCell;
    }else if (collectionView.tag == CCamStickerSetCollectionView) {
        cellIdentifer = @"stickerSetCell";
        CCStickerSetCell *stickerSetCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
        stickerSetCell.stickerSet = [[DataHelper sharedManager].stickerSets objectAtIndex:indexPath.row];
        
        [stickerSetCell.stickerSetImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CCamHost,stickerSetCell.stickerSet.image_Mini]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL){
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            animation.fromValue = [NSNumber numberWithFloat:0.0];
            animation.toValue = [NSNumber numberWithFloat:1.0];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.duration = 0.15;
            [stickerSetCell.stickerSetImage pop_addAnimation:animation forKey:@"alphaAnimation"];
        }];
        
        return stickerSetCell;
    }else if (collectionView.tag == CCamStickerSetContentCollectionView){
        cellIdentifer = @"stickerSetContentCell";
        CCStickerSetContentCell *sticksetContentCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
        sticksetContentCell.stickerSet = [[DataHelper sharedManager].stickerSets objectAtIndex:indexPath.row];
        
        [sticksetContentCell reloadStickers];
        
        return sticksetContentCell;
    }else if (collectionView.tag == CCamFilterCollectionView){
        cellIdentifer = @"filterCell";
        CCamFilterCell *filterCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifer forIndexPath:indexPath];
        [filterCell layoutFilterCell];
        [filterCell.filterLabel setText:[_filters objectAtIndex:indexPath.row]];
        if (indexPath.row == 0) {
            [filterCell.filterLabel setTextColor:CCamGrayTextColor];
        }else{
            [filterCell.filterLabel setTextColor:[UIColor whiteColor]];
        }
        [filterCell.filterImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[_filters objectAtIndex:indexPath.row]]]];
        return filterCell;
    }


    return nil;
}
- (void)resetEraseImage{
    NSString *photoPath = [NSString stringWithFormat:@"file://%@/Choosed.jpg",CCamDocPath];
    NSLog(@"Check Path : %@",photoPath);
    UnitySendMessage(UnityController.UTF8String, "SelectAPicture", photoPath.UTF8String);
}
- (void)getEraseZoneAppear:(id)sender{
    UISwitch *s = (UISwitch*)sender;
    if (s.on) {
        UnitySendMessage(UnityController.UTF8String, "ShowEraseRect", "true");
    }else{
        UnitySendMessage(UnityController.UTF8String, "ShowEraseRect", "false");
    }
}
- (void)getEraseTranAppear:(id)sender{
    UISwitch *s = (UISwitch*)sender;
    if (s.on) {
        UnitySendMessage(UnityController.UTF8String, "EraseOpacity", "true");
    }else{
        UnitySendMessage(UnityController.UTF8String, "EraseOpacity", "false");
    }
}
- (void)getFilterSliderValue:(id)sender{
    UISlider *slider = (UISlider*)sender;
    NSString* value = [NSString stringWithFormat:@"%f",slider.value];
    UnitySendMessage(UnityController.UTF8String, "OnFilterSliderChange", value.UTF8String);
}
- (void)getSliderValue:(id)sender{
    UISlider *slider = (UISlider*)sender;
    if (slider.value<0.5) {
        [slider setValue:0 animated:YES];
    }else if (slider.value>0.5&&slider.value<1.5){
        [slider setValue:1 animated:YES];
    }else if (slider.value>1.5&&slider.value<2.5){
        [slider setValue:2 animated:YES];
    }else if (slider.value>2.5&&slider.value<3.5){
        [slider setValue:3 animated:YES];
    }else if (slider.value>3.5){
        [slider setValue:4 animated:YES];
    }
    self.eraseSize = slider.value;
    [self setEraseOptions];
}
-(void)setEraseOptions{
    
    NSString *eraseStr = [NSString stringWithFormat:@"%ld|%d",(long)_eraseType,(int)_eraseSize];
    NSLog(@"%@",eraseStr);
    UnitySendMessage("_plantFormInteractions", "EraseSet", eraseStr.UTF8String);
}
-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    self.eraseType = Index+1;
    NSLog(@"%ld,",(long)self.eraseType);
    [self setEraseOptions];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == CCamSerieCollectionView){
    [_serieCollection scrollRectToVisible:CGRectMake(_serieCollection.bounds.size.height*1.5*indexPath.row, 0, _serieCollection.bounds.size.height*1.5,  _serieCollection.bounds.size.height) animated:YES];
    [_serieContentCollection scrollRectToVisible:CGRectMake(_serieContentCollection.bounds.size.width*indexPath.row, 0, _serieContentCollection.bounds.size.width,  _serieContentCollection.bounds.size.height) animated:NO];
    }else if (collectionView.tag == CCamSegmentCollectionView) {
        
        if (indexPath.row != 3) {
            
            UnitySendMessage(UnityController.UTF8String, "ShowEraseRect", "false");
            UnitySendMessage(UnityController.UTF8String, "EraseOpacity", "false");
        }
        NSString *note = [_segments objectAtIndex:indexPath.row];
        NSString *title = [_segmentsShow objectAtIndex:indexPath.row];
        [_navigationTitle setText:title];
        [_segmentContentCollection setContentOffset:CGPointMake(CCamViewWidth*indexPath.row, 0) animated:YES];
        UnitySendMessage("_plantFormInteractions", "OnClickTabBtn", note.UTF8String);
       
        if (indexPath.row == 3) {
            if ([TutorialHelper sharedManager].autoShowEraserTutorial) {
                [[TutorialHelper sharedManager] callEraseTutorialView];
            }
            if (_eraseSeg) {
                [_eraseSeg setSelectedSegmentIndex:0];
            }
        }
        
    }else if (collectionView.tag == CCamFilterCollectionView){
        [_filterCollection scrollRectToVisible:CGRectMake(_filterCollection.bounds.size.height*indexPath.row, 0, _filterCollection.bounds.size.height,  _filterCollection.bounds.size.height) animated:YES];
        NSString* filter = [_filters objectAtIndex:indexPath.row];
        UnitySendMessage(UnityController.UTF8String, "OnSelectFilter", filter.UTF8String);
    }else if (collectionView.tag == CCamStickerSetCollectionView) {
        [_stickerSetCollection scrollRectToVisible:CGRectMake(_stickerSetCollection.bounds.size.height*1.5*indexPath.row, 0, _stickerSetCollection.bounds.size.height*1.5,  _serieCollection.bounds.size.height) animated:YES];
        [_stickerSetContentCollection scrollRectToVisible:CGRectMake(_stickerSetContentCollection.bounds.size.width*indexPath.row, 0, _stickerSetContentCollection.bounds.size.width,  _stickerSetContentCollection.bounds.size.height) animated:NO];
    }
}
#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _serieContentCollection) {
        int i = scrollView.contentOffset.x/scrollView.bounds.size.width;
        [_serieCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:_serieCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }else if (scrollView == _stickerSetContentCollection){
        int i = scrollView.contentOffset.x/scrollView.bounds.size.width;
        [_stickerSetCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:_stickerSetCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
    }
}
#pragma mark - updateData 
-(void)updateSerieCollection{

    [_serieCollection reloadData];
    [_serieContentCollection reloadData];

    [self performSelector:@selector(scrollToTargetSerie) withObject:nil afterDelay:0.1];
}
-(void)updateStickerSetCollection{
    
    [_stickerSetCollection reloadData];
    [_stickerSetContentCollection reloadData];
    
}
- (void)scrollToTargetSerie{
    [_segmentCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:_segmentCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [_filterCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:_filterCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    if (_allowSelectTargetSerie) {
        NSInteger serieID = [[[DataHelper sharedManager] getTargetSerie] integerValue];
        NSLog(@"%ld",serieID);
        if (serieID == -1) {
//            [_serieCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//            [self collectionView:_serieCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        }else{
            for (int i = 0; i<[DataHelper sharedManager].series.count; i++) {
                CCSerie *serie = [[DataHelper sharedManager].series objectAtIndex:i];
                if (serieID == [serie.serieID integerValue]) {
                    [_serieCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                    [self collectionView:_serieCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                    [[DataHelper sharedManager] setTargetSerie:@"-1"];
                    _allowSelectTargetSerie = NO;
                    return;
                }
            }
        }
    }else{
//        [_serieCollection selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//        [self collectionView:_serieCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
}
#pragma mark - update data
- (void)updateSeries{
    [[DataHelper sharedManager] updateSeriesInfo];
}
- (void)updateStickerSets{
    [[DataHelper sharedManager] updateStickerSetsInfo];
}
#pragma mark - 
- (void)callEraseTutorial{
    [[TutorialHelper sharedManager] callEraseTutorialView];
}
- (void)callLightTutorial{
    [[TutorialHelper sharedManager] callLightTutorialView];
}
@end
