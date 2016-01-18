//
//  CCAnimation.m
//  Unity-iPhone
//
//  Created by Karl on 2015/12/17.
//
//

#import "CCAnimation.h"
#import "CCCharacter.h"
#import "Constants.h"

@implementation CCAnimation

- (void)initAnimationWith:(NSDictionary *)dic{
    self.animationID = GetValidString([dic objectForKey:@"No"]);
    self.audio = GetValidString([dic objectForKey:@"animation_audio_url"]);
    self.characterID = GetValidString([dic objectForKey:@"character_id"]);
    self.clipName = GetValidString([dic objectForKey:@"animation_clip_name"]);
    self.frameFirst = GetValidString([dic objectForKey:@"first_frame"]);
    self.frameLast = GetValidString([dic objectForKey:@"last_frame"]);
    self.image = GetValidString([dic objectForKey:@"animation_image_url"]);
    self.nameCN = GetValidString([dic objectForKey:@"animation_name_cn"]);
    self.nameEN = GetValidString([dic objectForKey:@"animation_name_en"]);
    self.nameJP = GetValidString([dic objectForKey:@"animation_name_jp"]);
    self.nameZH = GetValidString([dic objectForKey:@"animation_name_zh"]);
    self.playType = GetValidString([dic objectForKey:@"animation_play_type"]);
    self.poseFace = GetValidString([dic objectForKey:@"pose_face_clip_name"]);
    self.serieID = GetValidString([dic objectForKey:@"series_id"]);
    self.type = GetValidString([dic objectForKey:@"animation_type"]);
}
@end
