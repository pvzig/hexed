//
//  LevelSelectViewController.h
//  Hexcells
//
//  Created by Peter Zignego on 2/6/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import "SimpleAVAudioPlayer.h"
#import "GameViewController.h"
#import "Cell.h"
#import "CellBlue.h"
#import "CellGrayLocked.h"
#import "HexCell.h"
#import "LevelDatabase.h"

@interface LevelSelectViewController : UICollectionViewController

@property (nonatomic) UICollectionView *collectionView;
@property UICollectionViewFlowLayout *flowLayout;

@property NSArray *selectedLevelArray;
@property NSMutableArray *beatenLevelsArray;
@property NSMutableArray *activeLevelNumber;
@property NSMutableArray *activeLevelState;
@property NSMutableArray *updatingIndexes;


@end
