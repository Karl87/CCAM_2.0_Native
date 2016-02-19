//
//  FileHelper.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/22.
//
//

#import "FileHelper.h"
#import "Constants.h"

@implementation FileHelper
+ (FileHelper*)sharedManager
{
    static dispatch_once_t pred;
    static FileHelper *_sharedInstance = nil;
    
    dispatch_once( &pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}
- (NSString *)getCharacterFilePath:(CCCharacter *)character{
    NSString *filePath = [NSString stringWithFormat:@"%@/CharacterCamera/S%@C%@/%@.assetbundle",CCamDocPath,character.serieID,character.characterID,character.version];
    return filePath;
}
- (BOOL)checkCharacterExist:(CCCharacter *)character{
    
    NSString *filePath = [NSString stringWithFormat:@"%@/CharacterCamera/S%@C%@/%@.assetbundle",CCamDocPath,character.serieID,character.characterID,character.version];
    
    if ([_fileManager fileExistsAtPath:filePath isDirectory:NO]) {
        return YES;
    }
    
    return NO;
}
- (BOOL)checkCharacterUpdate:(CCCharacter *)character{
    
    NSString* dirPath = [NSString stringWithFormat:@"%@/CharacterCamera/S%@C%@",CCamDocPath,character.serieID,character.characterID];
    if ([self getFilenamelistOfType:@"assetbundle" fromDirPath:dirPath].count>0) {
        return YES;
    }
    return NO;
}
- (void)checkCharacterDirectory:(CCCharacter *)character{
    NSString* dirPath = [NSString stringWithFormat:@"%@/CharacterCamera/S%@C%@",CCamDocPath,character.serieID,character.characterID];
    if (![_fileManager fileExistsAtPath:dirPath isDirectory:YES]) {
        [_fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
- (NSString *)checkStickDirectory{
    NSString* dirPath = [NSString stringWithFormat:@"%@/CharacterCamera/Sticker",CCamDocPath];
    BOOL isDir;
    if (![_fileManager fileExistsAtPath:dirPath isDirectory:&isDir] &&isDir) {
        [_fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dirPath;
}
- (NSString *)getStickerFilePath:(CCSticker *)sticker{
    NSArray *urlArray = [sticker.image_Res componentsSeparatedByString:@"/"];
    NSString *fileName = [urlArray lastObject];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@%@",[self checkStickDirectory],sticker.stickersetID,fileName];

    return filePath;
}

- (BOOL)checkStickerExist:(CCSticker *)sticker{
    
    NSArray *urlArray = [sticker.image_Res componentsSeparatedByString:@"/"];
    NSString *fileName = [urlArray lastObject];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@%@",[self checkStickDirectory],sticker.stickersetID,fileName];
    NSLog(@"贴纸文件检查：%@",filePath);
    if ([_fileManager fileExistsAtPath:filePath isDirectory:NO]) {
        return YES;
    }
    
    return NO;

}

#pragma mark - 
- (NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:0];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}
- (BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}
@end
