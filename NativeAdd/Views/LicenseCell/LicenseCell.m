//
//  LicenseCell.m
//  Unity-iPhone
//
//  Created by Karl on 2016/3/3.
//
//

#import "LicenseCell.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
@interface LicenseCell()

@property (nonatomic,strong) UILabel *licenseLab;
@end
@implementation LicenseCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpLicenseCell];
        
    }
    return self;
}
- (void)setUpLicenseCell{
    
    _licenseLab = [UILabel new];
    [_licenseLab setBackgroundColor:[UIColor clearColor]];
    [_licenseLab setTextAlignment:NSTextAlignmentLeft];
    [_licenseLab setTextColor:[UIColor darkGrayColor]];
    [_licenseLab setFont:[UIFont systemFontOfSize:13.0]];
    
    [self.contentView addSubview:_licenseLab];
    
    _licenseLab.sd_layout
    .leftSpaceToView(self.contentView,10)
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:_licenseLab bottomMargin:10.0];
}
- (void)setLicense:(id)license{
    _license = license;
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [_licenseLab setText:[NSString stringWithFormat:@"%@",_license]];
    _licenseLab.sd_layout.maxHeightIs(MAXFLOAT);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
