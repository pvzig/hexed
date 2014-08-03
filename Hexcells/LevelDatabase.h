//
//  LevelDatabase.h
//  Hexcells
//
//  Created by Peter Zignego on 1/15/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import <sqlite3.h>

@interface LevelDatabase : NSObject
{
    sqlite3 *_database;
}

+(LevelDatabase*)database;

-(NSArray *)loadLevel:(NSString*)string;

@end
