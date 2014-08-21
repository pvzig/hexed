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

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSArray *selectedLevelArray;

@property (nonatomic, strong) NSMutableArray *activeLevelNumber;
@property (nonatomic, strong) NSMutableArray *activeLevelState;

@property (nonatomic, strong) UILabel *remainingLabel;
@property (nonatomic, strong) UILabel *mistakesLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) NSString *levelLabelString;

@property (nonatomic) NSInteger mistakeCount;
@property (nonatomic) NSInteger minesCount;
@property (nonatomic) NSInteger remainingCount;
@property (nonatomic, strong) NSMutableArray *updatingIndexes;
@end
