//
//  LevelDatabase.m
//  Hexcells
//
//  Created by Peter Zignego on 1/15/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

#import "LevelDatabase.h"
#import "HexCell.h"

@implementation LevelDatabase

static LevelDatabase *_database;

+(LevelDatabase*)database {
    if (_database == nil) {
        _database = [[LevelDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"Hexcells"
                                                             ofType:@"sqlite3"];
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

//Query strings: levelselect or level1, level2, etc
-(NSArray *)loadLevel:(NSString*)string {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"%@%@", @"SELECT HEXINDEX, HEXNUMBER, HEXSTATE FROM ", string];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)
        == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSInteger hexIndex = sqlite3_column_int(statement, 0);
            NSInteger hexNumber = sqlite3_column_int(statement, 1);
            NSInteger hexState = sqlite3_column_int(statement, 2);
            HexCell *info = [[HexCell alloc] initWithUniqueId:hexIndex hexNumber:hexNumber hexState:hexState];
            [retval addObject:info];
        }
        sqlite3_finalize(statement);
    }
    return retval;
}

@end
