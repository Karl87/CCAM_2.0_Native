//
//  LicensesViewController.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/3.
//
//

#import "LicensesViewController.h"
#import <SDAutoLayout/UITableView+SDAutoTableViewCellHeight.h>
#import "LicenseCell.h"
#import "Constants.h"
@interface LicensesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *licenses;
@property (nonatomic,strong) NSArray *licenseNames;
@property (nonatomic,strong) NSArray *licenseTitle;
@property (nonatomic,strong) NSArray *licenseBody;

@end

@implementation LicensesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _licenseNames = @[@"SDWebImage",
//                      @"AFNetworking",
//                      @"MJRefresh",
//                      @"MBProgressHUD",
//                      @"SDAutoLayout",
//                      @"SlackTextViewController",
//                      @"FastttCamera",
//                      @"pop"];
    
    
    
    NSString *mit = @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.";
    
    NSString *apache = @"Licensed under the Apache License, Version 2.0 (the 'License');you may not use this file except in compliance with the License.You may obtain a copy of the License at\n\n    http://www.apache.org/licenses/LICENSE-2.0\n\nUnless required by applicable law or agreed to in writing, software distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.";
    
    NSString *bsd = @"Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:\n\n    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\n\n    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\n\n    * Neither the name Facebook nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.\n\n THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.";
    
    _licenseNames = @[@"rs/SDWebImage",
                      @"AFNetworking/AFNetworking",
                      @"CoderMJLee/MJRefresh",
                      @"jdg/MBProgressHUD",
                      @"gsdios/SDAutoLayout",
                      @"slackhq/SlackTextViewController",
                      @"IFTTT/FastttCamera",
                      @"facebook/pop"];
    
    _licenseBody = @[[NSString stringWithFormat:@"Copyright (c) 2016 Olivier Poitrey rs@dailymotion.com\n\n%@",mit],
                     [NSString stringWithFormat:@"Copyright (c) 2011–2016 Alamofire Software Foundation (http://alamofire.org/)\n\n%@",mit],
                     [NSString stringWithFormat:@"Copyright (c) 2013-2015 MJRefresh (https://github.com/CoderMJLee/MJRefresh)\n\n%@",mit],
                     [NSString stringWithFormat:@"Copyright (c) 2009-2015 Matej Bukovinski\n\n%@",mit],
                     [NSString stringWithFormat:@"The MIT License (MIT)\n\nCopyright (c) 2015 GSD_iOS\n\n%@",mit],
                     [NSString stringWithFormat:@"Copyright 2014-2016 Slack Technologies, Inc.\n\n%@",mit],
                     [NSString stringWithFormat:@"Copyright (c) 2015 IFTTT Inc\n\n%@",apache],
                     [NSString stringWithFormat:@"BSD License\n\nFor Pop software\n\nCopyright (c) 2014, Facebook, Inc. All rights reserved.\n\n%@",bsd]];
    
    _licenses = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_licenses registerClass:[LicenseCell class] forCellReuseIdentifier:@"licenseCell"];
    [self.view addSubview:_licenses];
    [_licenses setBackgroundColor:CCamViewBackgroundColor];
    [_licenses setSeparatorColor:CCamViewBackgroundColor];
    [_licenses setDelegate:self];
    [_licenses setDataSource:self];
    if (self.hidesBottomBarWhenPushed) {
        [_licenses setContentInset:UIEdgeInsetsMake(0, 0, 64, 0)];
        
    }else{
        [_licenses setContentInset:UIEdgeInsetsMake(0, 0, 64+49, 0)];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _licenseBody.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"licenseCell";
    LicenseCell *cell = [[LicenseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.license = [_licenseBody objectAtIndex:indexPath.section];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id license = [_licenseBody objectAtIndex:indexPath.section];
    return [_licenses cellHeightForIndexPath:indexPath model:license keyPath:@"license" cellClass:[LicenseCell class] contentViewWidth:CCamViewWidth];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *identifier = @"header";
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    [view setFrame:CGRectMake(0, 0, CCamViewWidth, 30)];
    
    UILabel *lab = [UILabel new];
    [lab setFrame:CGRectMake(10, 0, CCamViewWidth-20, 30)];
    [view addSubview:lab];
    [lab setText:[_licenseNames objectAtIndex:section]];
    [lab setTextColor:CCamGrayTextColor];
    [lab setFont:[UIFont boldSystemFontOfSize:17.0]];
    
    return view;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = CCamViewBackgroundColor;
}
@end
