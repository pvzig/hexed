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

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray *selectedLevelArray;
@property (nonatomic, strong) NSMutableArray *beatenLevelsArray;
@property (nonatomic, strong) NSMutableArray *activeLevelNumber;
@property (nonatomic, strong) NSMutableArray *activeLevelState;
@property (nonatomic, strong) NSMutableArray *updatingIndexes;


@end
