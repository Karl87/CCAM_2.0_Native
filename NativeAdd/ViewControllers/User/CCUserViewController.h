//
//  CCUserViewController.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/14.
//
//

#import "KLViewController.h"

@interface CCUserViewController : KLViewController
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,assign) BOOL showSetting;
@property (nonatomic,strong) NSMutableArray *reloadIndexs;
@property (nonatomic,assign) BOOL needUpdate;
- (void)returnTopPosition;
- (void)reloadInfo;
@end
