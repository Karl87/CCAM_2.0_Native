//
//  ViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/4.
//
//

#import "ViewController.h"
#import "PushToViewController.h"
#import "OtherTableViewController.h"
#import "KLImagePickerViewController.h"
#import <pop/POP.h>
#import "KLTabBarController.h"
//#import "DownloadHelper.h"
#import "TestLoginViewController.h"
#import "KLNavigationController.h"
#import "CCamHelper.h"

#import "CCamViewController.h"

#define SmallFrame CGRectMake(0, 64+self.view.frame.size.width, self.view.frame.size.width, self.view.frame.size.height-64-self.view.frame.size.width)


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    // Do any additional setup after loading the view.
    
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CCamViewWidth, 64)];
    [naviBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:naviBar];
    
    UITableView *table = [[UITableView alloc] initWithFrame:SmallFrame];
    [self.view addSubview:table];
    [table setDataSource:self];
    [table setDelegate:self];
    self.table = table;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"testCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (indexPath.row ==0) {
        cell.textLabel.text = @"CCamViewController";
    }else if (indexPath.row ==1) {
        cell.textLabel.text = @"Push to other";
    }else if (indexPath.row ==2) {
        cell.textLabel.text = @"1/3 Screen";
    }else if (indexPath.row ==3) {
        cell.textLabel.text = @"2/3 Screen";
    }else if (indexPath.row ==4) {
        cell.textLabel.text = @"Full Screen";
    }else if (indexPath.row ==5) {
        cell.textLabel.text = @"Other table";
    }else if (indexPath.row ==6) {
        cell.textLabel.text = @"ImagePicker";
    }else if (indexPath.row ==7) {
        cell.textLabel.text = @"Launch Native";
    }else if (indexPath.row ==8) {
        cell.textLabel.text = @"Login View";
    }else if (indexPath.row ==9) {
        cell.textLabel.text = @"ChangePhoto";
    }else if (indexPath.row ==10) {
        cell.textLabel.text = @"UpdateSeriesInfo";
    }else if(indexPath.row ==11){
        cell.textLabel.text = @"GetLocalSeriesInfo";
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    
    if (indexPath.row == 2) {
        cell.selected = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected" message:[NSString stringWithFormat:@"U selected cell %ld",(long)indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        CCamViewController *vc = [[CCamViewController alloc] init];
        [[DataHelper sharedManager] setCcamVC:vc];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
//        PushToViewController *push = [[PushToViewController alloc] init];
//        [DataHelper sharedManager].vc = push;
//        [self.navigationController pushViewController:push animated:YES];
    }else if (indexPath.row ==2){
        
        if(self.table.frame.origin.y == self.view.frame.size.height *2 /3 ){
            return;
        }
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue =[NSValue valueWithCGRect:self.table.frame];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, self.view.frame.size.height*2/3, self.view.frame.size.width, self.view.frame.size.height/3)];
        anim.beginTime = CACurrentMediaTime();
        anim.springBounciness = 10.0f;
        [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
            if(finish) {
                NSLog(@"!");
            }
        }];
        [self.table pop_addAnimation:anim forKey:@"position"];
    }else if (indexPath.row == 3){
        
        if(self.table.frame.origin.y == self.view.frame.size.height/3 ){
            return;
        }
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue =[NSValue valueWithCGRect:self.table.frame];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, self.view.frame.size.height/3, self.view.frame.size.width, self.view.frame.size.height*2/3)];
        anim.beginTime = CACurrentMediaTime();
        anim.springBounciness = 10.0f;
        [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
            if(finish) {
                NSLog(@"!");
            }
        }];
        [self.table pop_addAnimation:anim forKey:@"position"];
    }else if(indexPath.row == 4){
        
        if(self.table.frame.origin.y == 0 ){
            return;
        }
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue =[NSValue valueWithCGRect:self.table.frame];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        anim.beginTime = CACurrentMediaTime();
        anim.springBounciness = 10.0f;
        [anim setCompletionBlock:^(POPAnimation *anim,BOOL finish){
            if(finish) {
                NSLog(@"!");
            }
        }];
        [self.table pop_addAnimation:anim forKey:@"position"];
    }else if(indexPath.row == 5){
        OtherTableViewController *other = [[OtherTableViewController alloc] init];
//        [DownloadHelper sharedManager].other = other;
        [self.navigationController pushViewController:other animated:NO];
    }else if (indexPath.row == 6){
        KLImagePickerViewController *picker = [[KLImagePickerViewController alloc] init];
        [self.navigationController pushViewController:picker animated:YES];
    }else if (indexPath.row == 7){
        KLTabBarController *tab = [[KLTabBarController alloc] init];
        [self presentViewController:tab animated:YES completion:nil]
        ;
    }else if (indexPath.row ==8) {
        TestLoginViewController *login = [[TestLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }else if (indexPath.row ==9) {
        NSString *photoPath = [NSString stringWithFormat:@"file:///%@/Choosed.jpg",CCamDocPath];
        NSLog(@"Check Path : %@",photoPath);
        UnitySendMessage(UnityController.UTF8String, "SelectAPicture", photoPath.UTF8String);

//        TestNetwork *network = [[TestNetwork alloc] init];
//        network.setNavigationBar = YES;
////        KLNavigationController *navi = [[KLNavigationController alloc] initWithRootViewController:network];
//        [self.navigationController pushViewController:network animated:YES];
    }else if (indexPath.row == 10){
        [[DataHelper sharedManager] updateSeriesInfo];
    }else if (indexPath.row == 11){
        [[DataHelper sharedManager] getLocalSeriesInfo];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
