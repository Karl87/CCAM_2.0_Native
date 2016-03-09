//
//  PersonBasicInfoCell.h
//  Unity-iPhone
//
//  Created by Karl on 2016/2/24.
//
//

#import <UIKit/UIKit.h>

@interface PersonBasicInfoCell : UITableViewCell
@property (nonatomic,copy) NSDictionary *info;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,strong) NSString *note;

@end
