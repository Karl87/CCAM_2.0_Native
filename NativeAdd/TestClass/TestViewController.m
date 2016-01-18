//
//  TestViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/19.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test.jpg"]];
    [image setFrame:self.view.frame];
    [image setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:image];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.navigationController.navigationItem]
    self.title = self.vcTitle;
}
@end
