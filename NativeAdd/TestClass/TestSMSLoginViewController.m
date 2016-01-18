//
//  TestSMSLoginViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/12/1.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "TestSMSLoginViewController.h"
#import "KLSMSAreaViewController.h"
#import <SMS_SDK/SMSSDK.h>

@interface TestSMSLoginViewController ()<KLSMSAreaViewControllerDelegate>

@end

@implementation TestSMSLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIButton *smsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [smsBtn setBackgroundColor:CCamGoldColor];
    [smsBtn setTitle:@"GetSMS" forState:UIControlStateNormal];
    [smsBtn sizeToFit];
    [smsBtn setCenter:CGPointMake(15 + smsBtn.frame.size.width/2, 80+ smsBtn.frame.size.height/2)];
    [smsBtn addTarget:self action:@selector(getSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: smsBtn];
    
    UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [areaBtn setBackgroundColor:CCamGoldColor];
    [areaBtn setTitle:@"GetArea" forState:UIControlStateNormal];
    [areaBtn sizeToFit];
    [areaBtn setCenter:CGPointMake(15 + smsBtn.frame.size.width/2, 90+ smsBtn.frame.size.height/2*3)];
    [areaBtn addTarget:self action:@selector(getArea) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: areaBtn];
    
    [SMSSDK registerApp:SMSAppKey withSecret:SMSAppSecret];
}
- (void)getSMS{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:@"18612481003" zone:@"886" customIdentifier:nil result:^(NSError* error){
        if (!error) {
            NSLog(@"sms sent success! check it out!");
        }else{
            NSLog(@"sms sent failed!");
        }
    }];
}
- (void)getArea{
    KLSMSAreaViewController *area = [[KLSMSAreaViewController alloc] init];
//    [self presentViewController:area animated:YES completion:nil];
    area.delegate = self;
    [self.navigationController pushViewController:area animated:YES];
}
- (void)setSecondData:(SMSSDKCountryAndAreaCode *)data{
    NSLog(@"choose area is %@",data.areaCode);
}

@end
