//
//  ViewController.h
//  Hexcells
//
//  Created by Peter Zignego on 1/13/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import "SimpleAVAudioPlayer.h"
#import "LevelSelectViewController.h"
#import "Cell.h"
#import "CellBlue.h"
#import "CellGray.h"
#import "HexCell.h"
#import "LevelDatabase.h"

@interface GameViewController : UICollectionViewController

@property (nonatomic) UICollectionView *collectionView;
@property UICollectionViewFlowLayout *flowLayout;

@property NSArray *selectedLevelArray;

@property NSMutableArray *activeLevelNumber;
@property NSMutableArray *activeLevelState;

@property UILabel *remainingLabel;
@property UILabel *mistakesLabel;
@property UILabel *levelLabel;
@property NSString *levelLabelString;

@property NSInteger mistakeCount;
@property NSInteger minesCount;
@property NSInteger remainingCount;
@property NSMutableArray *updatingIndexes;
@end
