//
//  SimpleAVAudioPlayer.h
//  Hexcells
//
//  Created by Peter Zignego on 7/31/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef void (^CompletionBlock)(BOOL);

@interface AVAudioPlayerWithCompletionBlock : AVAudioPlayer

@property (nonatomic, copy) CompletionBlock completionBlock;

@end

@interface SimpleAVAudioPlayer : AVAudioPlayer <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray *players;

+(SimpleAVAudioPlayer *)shared;
+(AVAudioPlayer *) playFile:(NSString *)filename loops:(NSInteger)loops withCompletionBlock:(CompletionBlock)completion;

@end
