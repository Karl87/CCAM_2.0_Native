//
//  PushToViewController.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/4.
//
//

#import "KLViewController.h"
#import "CCCharacter.h"

@interface PushToViewController : KLViewController
- (void)reloadInfo;
- (void)reloadCharactersAndAnimations:(CCCharacter*)character;
@end


