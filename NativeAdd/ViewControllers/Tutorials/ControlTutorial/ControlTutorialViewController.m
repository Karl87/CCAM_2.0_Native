//
//  ControlTutorialViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/29.
//
//

#import "ControlTutorialViewController.h"
#import <pop/POP.h>
#import "CCamHelper.h"
@interface ControlTutorialViewController ()
@property (nonatomic,strong)NSMutableArray *tutorialImages;
@property (nonatomic,strong)UIImageView *tutorialBG;
@property (nonatomic,strong)UIImageView *tutorial;
@end

@implementation ControlTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    
    _tutorialImages = [NSMutableArray new];
    
    NSArray *imageNames = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                            @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",
                            @"18",@"17",@"16",@"15",@"14",@"13",@"12",@"11",@"10",
                            @"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1",@"0",
                            @"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",
                            @"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60",@"61",@"62",
                            @"62",@"61",@"60",@"59",@"58",@"57",@"56",@"55",
                            @"54",@"53",@"52",@"51",@"50",@"49",@"48",@"47",@"46",@"45",
                            @"90",@"91",@"92",@"93",@"94",@"95",@"96",@"97",@"98",
                            @"98",@"97",@"96",@"95",@"94",@"93",@"92",@"91",@"90",
                            @"115",@"116",@"117",@"118",@"119",@"120",@"121",@"122",@"123",
                            @"124",@"125",@"126",@"127",@"128",
                            @"128",@"127",@"126",@"125",@"124",
                            @"123",@"122",@"121",@"120",@"119",@"118",@"117",@"116",@"115"];
    
    for (int i=0; i<[imageNames count]; i++) {
        int j = [[imageNames objectAtIndex:i] intValue];
//        if (j<10) {
            NSString*fileName =[NSString stringWithFormat:@"SR_%d",j];
            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [_tutorialImages addObject:image];
//        }
//        if (j>99){
//            NSString*fileName =[NSString stringWithFormat:@"SR_00%d",j];
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
//            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//            [_tutorialImages addObject:image];
//        }
//        if (j>9&&j<100){
//            NSString*fileName =[NSString stringWithFormat:@"SR_000%d",j];
//            NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
//            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//            [_tutorialImages addObject:image];
//        }
    }

    
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
    
    [TutorialHelper sharedManager].autoShowControlTutorial = NO;
    [[TutorialHelper sharedManager] setShowControlTutorial:@"NO"];
}
- (void)endTutorial{
    [_tutorial stopAnimating];
    [[TutorialHelper sharedManager] dismissControlTutorialView];
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
