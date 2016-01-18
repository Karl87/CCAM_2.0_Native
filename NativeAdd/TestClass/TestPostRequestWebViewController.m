//
//  TestPostRequestWebViewController.m
//  CCamNativeKit
//
//  Created by Karl on 2015/11/18.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "TestPostRequestWebViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TestPostRequestWebViewController ()<CLLocationManagerDelegate>

@property (nonatomic,strong) UIWebView *web;

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) UIWindow *testWindow;
@end

@implementation TestPostRequestWebViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:web];
    _web = web;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn setFrame:CGRectMake(0, 0, 88, 88)];
    [btn setCenter:self.view.center];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(locate) forControlEvents:UIControlEventTouchUpInside];
}
- (void)locate{
    if([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        self.locationManager.delegate = self;
        ;
        [self.locationManager startUpdatingLocation];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }else {
        NSLog(@"Can not launch location servies");
    }
    
}
#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            NSLog(@"%lu",(unsigned long)array.count);
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSLog(@"%@",placemark.name);
//            NSString *city = placemark.locality;
//            if (!city) {
//                city = placemark.administrativeArea;
//            }
//            NSLog(@"%@",city);
//            self.title = placemark.name;
            
            [self postInfoToWebWithInfo:placemark.name];
        }else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
        }else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
        [manager stopUpdatingLocation];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}
- (void)postInfoToWebWithInfo:(NSString*)info{
    NSURL *url = [NSURL URLWithString:@"http://www.c-cam.cc/index.php/Api/Login/ttest.html"];
    NSData * data = [[NSString stringWithFormat: @"aaa=%@",info] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [_web loadRequest:request];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
     if (error.code == kCLErrorDenied) {
         NSLog(@"user did not allow user location servies");
     }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
@end
