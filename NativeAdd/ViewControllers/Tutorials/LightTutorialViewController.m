//
//  LightTutorialViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/23.
//
//

#import "LightTutorialViewController.h"
#import <pop/POP.h>
#import "CCamHelper.h"
@interface LightTutorialViewController ()
@property (nonatomic,strong)NSMutableArray *tutorialImages;
@property (nonatomic,strong)UIImageView *tutorialBG;
@property (nonatomic,strong)UIImageView *tutorial;
@end

@implementation LightTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    _tutorialImages = [NSMutableArray new];
    
    NSArray *imageNames = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                            @"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"0",
                            @"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                            @"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"0",
                            @"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",
                            @"51",@"50",@"49",@"48",@"47",@"46",@"45",@"44",@"43",
                            @"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",
                            @"51",@"50",@"49",@"48",@"47",@"46",@"45",@"44",@"43",];
    
    for (int i=0; i<[imageNames count]; i++) {
        int j = [[imageNames objectAtIndex:i] intValue];
        if (j<10) {
            NSString*fileName =[NSString stringWithFormat:@"SL_0000%d",j];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"JPG"];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [_tutorialImages addObject:image];
        }else{
            NSString*fileName =[NSString stringWithFormat:@"SL_000%d",j];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"JPG"];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [_tutorialImages addObject:image];
        }
    }
    
//    for (int i=0; i<77; i++) {
//        if (i<10) {
//            NSString*fileName =[NSString stringWithFormat:@"SL_0000%d",i];
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"JPG"];
//            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//            [_tutorialImages addObject:image];
//        }else{
//            NSString*fileName =[NSString stringWithFormat:@"SL_000%d",i];
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"JPG"];
//            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//            [_tutorialImages addObject:image];
//        }
//    }
    
    _tutorialBG  = [UIImageView new];
    [_tutorialBG setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0]];
    [_tutorialBG setFrame:CGRectMake(30, -CCamViewWidth, CCamViewWidth-60, CCamViewWidth-60)];
    [_tutorialBG.layer setCornerRadius:10.0];
    [_tutorialBG.layer masksToBounds];
    [self.view addSubview:_tutorialBG];
    
    _tutorial = [UIImageView new];
    [_tutorial setBackgroundColor:[UIColor clearColor]];
    [_tutorial setContentMode:UIViewContentModeScaleAspectFit];
    [_tutorial setFrame:CGRectMake(0, 0, CCamViewWidth-60, CCamViewWidth-60)];
    [_tutorial setImage:[_tutorialImages objectAtIndex:0]];
    [_tutorialBG addSubview:_tutorial];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showTutorial];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideTutorial];
    
}
- (void)startTutorial{
    [_tutorial setAnimationImages:_tutorialImages];
    [_tutorial setAnimationDuration:[_tutorialImages count]*0.05];
    [_tutorial setAnimationRepeatCount:1000];
    [_tutorial startAnimating];
    
    [TutorialHelper sharedManager].autoShowLightTutorial = NO;
    [[TutorialHelper sharedManager] setShowLightTutorial:@"NO"];
}
- (void)endTutorial{
    [_tutorial stopAnimating];
    [[TutorialHelper sharedManager] dismissLightTutorialView];
}
- (void)dealloc{
    [_tutorialImages removeAllObjects];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTutorial{
    NSLog(@"pop animation");
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.fromValue = @(-CCamViewWidth);
    anSpring.toValue = @(self.view.center.y);
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.springBounciness = 10.0f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [self startTutorial];
        }
    }];
    [_tutorialBG pop_addAnimation:anSpring forKey:@"position"];
}
- (void)hideTutorial{
    NSLog(@"hide animation");
    
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    anSpring.fromValue = @(self.view.center.y);
    anSpring.toValue = @(CCamViewHeight+CCamViewWidth);
    anSpring.beginTime = CACurrentMediaTime();
    //    anSpring.springBounciness = 10.0f;
    anSpring.duration = 0.25f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [self endTutorial];
        }
    }];
    [_tutorialBG pop_addAnimation:anSpring forKey:@"position"];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
