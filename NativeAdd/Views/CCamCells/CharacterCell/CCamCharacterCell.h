//
//  CCamCharacterCell.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/21.
//
//

#import <UIKit/UIKit.h>
#import "CCCharacter.h"
#import <M13ProgressSuite/M13ProgressViewBorderedBar.h>

@interface CCamCharacterCell : UICollectionViewCell
@property (nonatomic,strong) CCCharacter *character;
@property (nonatomic,strong) UIImageView *characterImage;
@property (nonatomic,strong) UIImageView *stateImage;
@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) M13ProgressViewBorderedBar *downloadProgress;

- (void)layoutCharacterCell;
@end
