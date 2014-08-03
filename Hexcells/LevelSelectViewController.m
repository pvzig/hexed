//
//  LevelSelectViewController.m
//  Hexcells
//
//  Created by Peter Zignego on 2/6/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.
//

#import "LevelSelectViewController.h"

@implementation LevelSelectViewController

-(void)viewDidAppear:(BOOL)animated {
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self configureCollectionView];
    [self loadLevel];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.beatenLevelsArray = [defaults objectForKey:@"beatenLevels"];
    if (!self.beatenLevelsArray) {
        self.beatenLevelsArray = [[NSMutableArray alloc] init];
        [self.beatenLevelsArray addObject:@(1)];
        [self.beatenLevelsArray addObject:@(2)];
        [defaults setObject:self.beatenLevelsArray forKey:@"beatenLevels"];
        [defaults synchronize];
    }
}
-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)configureCollectionView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    self.collectionView.contentSize = CGSizeMake(2048, 1024);
    self.collectionView.frame = CGRectMake(0, 0, 2048, 1024);
}

-(void)registerCellClasses {
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"orange"];
    [self.collectionView registerClass:[CellBlue class] forCellWithReuseIdentifier:@"blue"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"emptyCell"];
    [self.collectionView registerClass:[CellGrayLocked class] forCellWithReuseIdentifier:@"grayLocked"];
}

-(void)levelTransition{
    UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2048, 1024)];
    gray.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    [self.view addSubview:gray];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        gray.alpha = 0;
    }
        completion:^(BOOL finished){
            if (finished) {
                [UIView setAnimationsEnabled:NO];
                [self.collectionView reloadItemsAtIndexPaths:self.updatingIndexes];
                [UIView setAnimationsEnabled:YES];
                [gray removeFromSuperview];
            }
        }];
}

-(void)loadLevel {
    self.selectedLevelArray = [[NSArray alloc] initWithArray:[[LevelDatabase database] loadLevel:@"levelselect"]];

    self.updatingIndexes = [[NSMutableArray alloc] init];
    self.activeLevelNumber = [[NSMutableArray alloc] init];
    self.activeLevelState = [[NSMutableArray alloc] init];
    
    //Loop through the sections and rows to find which indexes need to be updated for this level
    for (NSInteger s = 0; s < 21; s++){
        for (NSInteger r = 0; r < 15; r++){
            NSInteger threeFifteenIndex = s * 15 + r;
            HexCell *info = [self.selectedLevelArray objectAtIndex:threeFifteenIndex];
            NSInteger hexNumber = info.hexNumber;
            NSInteger hexState = info.hexState;
            //Array of numbers for adjacent 'mines' to any given hex at any given index
            [self.activeLevelNumber addObject:@(hexNumber)];
            //Array to track the state of the hexes - orange, blue, clear
            [self.activeLevelState addObject:@(hexState)];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:r inSection:s];
            if (hexState > 0){
                [self.updatingIndexes addObject:indexPath];
            }
        }
    }
    [self levelTransition];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 21;
}

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 15;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout  *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(57.74, 48.5);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        //top, left, bottom, right
        return UIEdgeInsetsMake(0, 70, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self registerCellClasses];
    NSInteger threeFifteenIndex = indexPath.section * 15 + indexPath.row;
    NSNumber *state = [self.activeLevelState objectAtIndex:threeFifteenIndex];
    NSNumber *number = [self.activeLevelNumber objectAtIndex:threeFifteenIndex];
    NSInteger stateInt = [state integerValue];
    NSInteger numberInt = [number integerValue];
    //Orange cells
    if (stateInt > 0 && ![self.beatenLevelsArray containsObject:number] && numberInt <= 16){
        Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"orange" forIndexPath:indexPath];
        NSInteger horizontalDisplacement = indexPath.section * 15 + 15;
        cell.frame = CGRectMake(cell.frame.origin.x-horizontalDisplacement, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        if (indexPath.section % 2 == 0){
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - cell.frame.size.height/2, cell.frame.size.width, cell.frame.size.height);
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell numbered:numberInt cell:cell index:indexPath];
        return cell;
    }
    //Blue cells
    if ([self.beatenLevelsArray containsObject:number]){
        CellBlue *cell = [cv dequeueReusableCellWithReuseIdentifier:@"blue" forIndexPath:indexPath];
        NSInteger horizontalDisplacement = indexPath.section * 15 + 15;
        cell.frame = CGRectMake(cell.frame.origin.x-horizontalDisplacement, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        if (indexPath.section % 2 == 0){
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - cell.frame.size.height/2, cell.frame.size.width, cell.frame.size.height);
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell numbered:numberInt cell:cell index:indexPath];
        return cell;
    }
    //Gray cells
    if (numberInt > 16){
        CellGrayLocked *cell = [cv dequeueReusableCellWithReuseIdentifier:@"grayLocked" forIndexPath:indexPath];
        NSInteger horizontalDisplacement = indexPath.section * 15 + 15;
        cell.frame = CGRectMake(cell.frame.origin.x-horizontalDisplacement, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        if (indexPath.section % 2 == 0){
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - cell.frame.size.height/2, cell.frame.size.width, cell.frame.size.height);
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    //Hide empty cells
    else {
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"emptyCell" forIndexPath:indexPath];
        cell.hidden = TRUE;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [SimpleAVAudioPlayer playFile:@"mark.aif" loops:0 withCompletionBlock:^(BOOL finished) {}];
    NSInteger threeFifteenIndex = indexPath.section * 15 + indexPath.row;
    NSNumber *numberSelected = [self.activeLevelNumber objectAtIndex:threeFifteenIndex];
    NSInteger numberSelectedInt = [numberSelected integerValue];
    
    if (numberSelectedInt >= 11 && numberSelectedInt <= 16) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:numberSelectedInt forKey:@"selectedLevel"];
    [defaults synchronize];

    UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2048, 1024)];
    gray.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    gray.alpha = 0;
    [self.view addSubview:gray];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        gray.alpha = 1;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle: nil];
                             GameViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"gvc"];
                             [self.navigationController pushViewController:vc animated:NO];
                         }}];
    }
    return;
}

@end