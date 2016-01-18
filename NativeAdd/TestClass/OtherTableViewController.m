//
//  OtherTableViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/4.
//
//

#import "OtherTableViewController.h"
#import "TestDownloadTableViewCell.h"
#import "DownloadHelper.h"
@interface OtherTableViewController ()<UITableViewDataSource,UITableViewDelegate>


@end

@implementation OtherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*2/3, self.view.frame.size.width, self.view.frame.size.height/3)];
    [self.view addSubview:table];
    [table setDataSource:self];
    [table setDelegate:self];
    self.table = table;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[DownloadHelper sharedManager] testDownloadUIChange];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [DownloadHelper sharedManager].other = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"testCell";
    TestDownloadTableViewCell *cell = [[TestDownloadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"exit";
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        TestDownloadTableViewCell * cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        
        [cell.progress setProgress:(float)indexPath.row/100 animated:YES];
        
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
