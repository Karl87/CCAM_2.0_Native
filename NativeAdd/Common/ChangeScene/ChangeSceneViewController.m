//
//  ChangeSceneViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/22.
//
//

#import "ChangeSceneViewController.h"
#import <pop/POP.h>
#import "iOSBindingManager.h"
#import "CCamHelper.h"

@interface ChangeSceneViewController ()

@end

@implementation ChangeSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    
    UIImageView *logo = [UIImageView new];
    [logo setFrame:CGRectMake(0, 0, 200, 200)];
    [self.view addSubview:logo];
    [logo setBackgroundColor:[UIColor clearColor]];
    [logo setCenter:self.view.center];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    NSString*language = [[SettingHelper sharedManager] getCurrentLanguage];
    if ([language hasPrefix:@"zh-Hans"]) {
        [logo setImage:[UIImage imageNamed:@"launchNoteCn"]];
    }else{
        [logo setImage:[UIImage imageNamed:@"launchNoteZh"]];
    }
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    anSpring.fromValue = [UIColor colorWithWhite:0.0 alpha:0.0];
    anSpring.toValue = [UIColor colorWithWhite:0.0 alpha:1.0];
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.duration = 0.25f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [self performSelector:@selector(hideTransition) withObject:nil afterDelay:0.25];
        }
    }];
    [self.view pop_addAnimation:anSpring forKey:@"color"];
}
- (void)hideTransition{
    POPBasicAnimation *anSpring = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    anSpring.fromValue = [UIColor colorWithWhite:0.0 alpha:1.0];
    anSpring.toValue = [UIColor colorWithWhite:0.0 alpha:0.0];
    anSpring.beginTime = CACurrentMediaTime();
    anSpring.duration = 0.25f;
    [anSpring setCompletionBlock:^(POPAnimation *anim,BOOL finish){
        if(finish) {
            NSLog(@"!");
            [[iOSBindingManager sharedManager] hideChangeSceneTransition];
        }
    }];
    [self.view pop_addAnimation:anSpring forKey:@"color"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
