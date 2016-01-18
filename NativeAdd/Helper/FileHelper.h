//
//  FileHelper.h
//  Unity-iPhone
//
//  Created by Karl on 2015/12/22.
//
//

#import <Foundation/Foundation.h>
#import "CCCharacter.h"
#import "CCSticker.h"

@interface FileHelper : NSObject

@property (nonatomic,strong) NSFileManager *fileManager;

+ (FileHelper*)sharedManager;
- (BOOL)checkCharacterExist:(CCCharacter *)character;
- (BOOL)checkCharacterUpdate:(CCCharacter *)character;
- (void)checkCharacterDirectory:(CCCharacter *)character;
- (NSString *)getCharacterFilePath:(CCCharacter*)character;

- (BOOL)checkStickerExist:(CCSticker *)sticker;
- (NSString *)getStickerFilePath:(CCSticker *)sticker;
@end
