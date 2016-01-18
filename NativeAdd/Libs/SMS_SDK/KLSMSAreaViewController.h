//
//  KLSMSAreaViewController.h
//  CCamNativeKit
//
//  Created by Karl on 2015/12/1.
//  Copyright © 2015年 i-craftsmen ltd. All rights reserved.
//

#import "KLViewController.h"
#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>

@protocol  KLSMSAreaViewControllerDelegate;

@interface KLSMSAreaViewController : KLViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIAlertViewDelegate>{
    
    UITableView *table;
    UISearchBar *search;
    NSDictionary *allNames;
    NSMutableDictionary *names;
    NSMutableArray  *keys;
    
    BOOL    isSearching;
}
@property (nonatomic, strong)  UITableView *table;
@property (nonatomic, strong)  UISearchBar *search;
@property (nonatomic, strong) NSDictionary *allNames;
@property (nonatomic, strong) NSMutableDictionary *names;
@property (nonatomic, strong) NSMutableArray *keys;

@property (nonatomic, strong) id<KLSMSAreaViewControllerDelegate> delegate;
@property(nonatomic,strong)  UIToolbar* toolBar;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;
-(void)setAreaArray:(NSMutableArray*)array;
@end

@protocol KLSMSAreaViewControllerDelegate <NSObject>
- (void)setSecondData:(SMSSDKCountryAndAreaCode *)data;
@end