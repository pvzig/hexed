//
//  SimpleAVAudioPlayer.m
//  Hexcells
//
//  Created by Peter Zignego on 7/31/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import "SimpleAVAudioPlayer.h"

@implementation AVAudioPlayerWithCompletionBlock

@end

@implementation SimpleAVAudioPlayer

static SimpleAVAudioPlayer *sharedInstance = nil;

+(void)initialize {
    if (sharedInstance == nil)
        sharedInstance = [[self alloc] init];
}

+(SimpleAVAudioPlayer *)shared {
    return sharedInstance;
}

-(id)init {
    if (sharedInstance == nil) {
        self = [super init];
        if (self) {
            self.players = [NSMutableArray new];
        }
    }
    return self;
}


-(AVAudioPlayer *)playFile:(NSString *)filename loops:(NSInteger)loops withCompletionBlock:(CompletionBlock)completion {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    if(!filePath) {
        return nil;
    }
    NSError *error = nil;
    NSURL *fileURL = [NSURL fileURLWithPath:filePath isDirectory:NO];
    AVAudioPlayerWithCompletionBlock *player = [[AVAudioPlayerWithCompletionBlock alloc] initWithContentsOfURL:fileURL error:&error];
    player.numberOfLoops = loops;
    // Retain and play
    if (player) {
        [self.players addObject:player];
        player.completionBlock = completion;
        player.delegate = self;
        [player play];
        return player;
    }
    else {
        return nil;
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayerWithCompletionBlock *)player successfully:(BOOL)completed {
    if (player.completionBlock) {
        player.completionBlock (completed);
    }
    [self.players removeObject:player];
    player.delegate = nil;
    player = nil;
}

+(AVAudioPlayer *) playFile:(NSString *)filename loops:(NSInteger)loops withCompletionBlock:(CompletionBlock)completion {
    return [[SimpleAVAudioPlayer shared] playFile:filename loops:loops withCompletionBlock:completion];
}

@end
