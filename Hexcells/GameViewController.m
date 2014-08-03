//
//  ViewController.m
//  Hexcells
//
//  Created by Peter Zignego on 1/13/14.
//  Copyright (c) 2014 Launch Software. All rights reserved.

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

-(void)viewDidLoad {
    self.updatingIndexes = [[NSMutableArray alloc] init];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self configureCollectionView];
    [self registerCellClasses];
    [self loadLevel:[self levelString]];
    [self addOverlays];
    [self fadeInTransition];
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
    [self.collectionView registerClass:[CellGray class] forCellWithReuseIdentifier:@"gray"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"emptyCell"];
}

-(NSString*)levelString {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger levelNumber = [defaults integerForKey:@"selectedLevel"];
    switch (levelNumber) {
        case 11:
        {
            self.levelLabelString = @"LEVEL 1-1";
            return @"level1";
            break;
        }
        case 12:
        {
            self.levelLabelString = @"LEVEL 1-2";
            return @"level2";
            break;
        }
        case 13:
        {
            self.levelLabelString = @"LEVEL 1-3";
            return @"level3";
            break;
        }
        case 14:
        {
            self.levelLabelString = @"LEVEL 1-4";
            return @"level4";
            break;
        }
        case 15:
        {
            self.levelLabelString = @"LEVEL 1-5";
            return @"level5";
            break;
        }
        case 16:
        {
            self.levelLabelString = @"LEVEL 1-6";
            return @"level6";
            break;
        }
        default:
            return @"level1";
    }
}

-(void)fadeInTransition {
    UIView *transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2048, 1024)];
    transitionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    [self.view addSubview:transitionView];
    [UIView animateWithDuration:1.00 delay:0.00 options:UIViewAnimationOptionCurveEaseOut animations:^{
        transitionView.alpha = 0.00;
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [UIView setAnimationsEnabled:NO];
                             [self.collectionView reloadItemsAtIndexPaths:self.updatingIndexes];
                             [UIView setAnimationsEnabled:YES];
                             [transitionView removeFromSuperview];
                         }}];
}

//Fade out fade in
-(void)levelTransition {
    UIView *transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2048, 1024)];
    transitionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    [self.view addSubview:transitionView];
    transitionView.alpha = 0;
    [UIView animateWithDuration:1.00 delay:0.00 options:UIViewAnimationOptionCurveEaseOut animations:^{
            transitionView.alpha = 1.00;
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [UIView setAnimationsEnabled:NO];
                             [self.collectionView reloadItemsAtIndexPaths:self.updatingIndexes];
                             [UIView setAnimationsEnabled:YES];
                             [UIView animateWithDuration:1.00 delay:0.00 options:UIViewAnimationOptionCurveEaseOut animations:^{
                                 transitionView.alpha = 0.00;
                             }
                                              completion:^(BOOL finished){
                                                  [transitionView removeFromSuperview];
                                              }];
                         }
                     }];
}

-(void)loadLevel:(NSString*)level {
    self.selectedLevelArray = [[NSArray alloc] initWithArray:[[LevelDatabase database] loadLevel:level]];
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
            if (hexState > 0 && ![self.updatingIndexes containsObject:indexPath]){
                [self.updatingIndexes addObject:indexPath];
            }
        }
    }
    [self initialMinesCount];
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

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger threeFifteenIndex = indexPath.section * 15 + indexPath.row;
    NSNumber *state = [self.activeLevelState objectAtIndex:threeFifteenIndex];
    NSNumber *number = [self.activeLevelNumber objectAtIndex:threeFifteenIndex];
    NSInteger stateInt = [state integerValue];
    NSInteger numberInt = [number integerValue];
    //Orange cells
    if (stateInt==1) {
        Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"orange" forIndexPath:indexPath];
        NSInteger horizontalDisplacement = indexPath.section * 15 + 15;
        cell.frame = CGRectMake(cell.frame.origin.x-horizontalDisplacement, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        if (indexPath.section % 2 == 0){
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - cell.frame.size.height/2, cell.frame.size.width, cell.frame.size.height);
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    //Blue cells
    if (stateInt==2) {
        CellBlue *cell = [cv dequeueReusableCellWithReuseIdentifier:@"blue" forIndexPath:indexPath];
        NSInteger horizontalDisplacement = indexPath.section * 15 + 15;
        cell.frame = CGRectMake(cell.frame.origin.x-horizontalDisplacement, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        if (indexPath.section % 2 == 0){
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - cell.frame.size.height/2, cell.frame.size.width, cell.frame.size.height);
        }
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    //Gray cells
    if (stateInt==3) {
        CellGray *cell = [cv dequeueReusableCellWithReuseIdentifier:@"gray" forIndexPath:indexPath];
        NSInteger horizontalDisplacement = indexPath.section * 15 + 15;
        cell.frame = CGRectMake(cell.frame.origin.x-horizontalDisplacement, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        if (indexPath.section % 2 == 0){
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - cell.frame.size.height/2, cell.frame.size.width, cell.frame.size.height);
        }
        cell.backgroundColor = [UIColor clearColor];
        [cell numbered:numberInt cell:cell index:indexPath];
        return cell;
    }
    //Hide empty cells
    else {
        UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"emptyCell" forIndexPath:indexPath];
        cell.hidden = TRUE;
        return cell;
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        //top, left, bottom, right
        return UIEdgeInsetsMake(0, 70, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger threeFifteenIndex = indexPath.section * 15 + indexPath.row;
    NSNumber *stateSelected = [self.activeLevelState objectAtIndex:threeFifteenIndex];
    NSNumber *numberSelected = [self.activeLevelNumber objectAtIndex:threeFifteenIndex];
    NSInteger stateSelectedInt = [stateSelected integerValue];
    NSInteger numberSelectedInt = [numberSelected integerValue];
    
    //Mines
    if (numberSelectedInt==1000) {
        //Orange
        if (stateSelectedInt==1) {
            //Make blue
            [SimpleAVAudioPlayer playFile:@"mark.aif" loops:0 withCompletionBlock:^(BOOL finished) {}];
            Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell performSelectionAnimations:cell view:self.view];
            [self.collectionView performBatchUpdates:^{
                NSNumber *two = [NSNumber numberWithInteger:2];
                [self.activeLevelState setObject:two atIndexedSubscript:threeFifteenIndex];
            } completion:^(BOOL finished){
                if (finished) {
                    [self updateCellatIndex:indexPath];
                    [self updateRemainingCount];
                    [self checkForClear];
                }
            }];
            return;
        }
        // Mistake
        if (stateSelectedInt==2) {
            [SimpleAVAudioPlayer playFile:@"wrong.aif" loops:0 withCompletionBlock:^(BOOL finished) {}];
            [self updateMistakesCount];
            return;
        }
    }
    
    //Numbers
    if (numberSelectedInt<1000) {
        //Orange
        if (stateSelectedInt==1) {
            //Make blue
            [SimpleAVAudioPlayer playFile:@"mark.aif" loops:0 withCompletionBlock:^(BOOL finished) {}];
            Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell performSelectionAnimations:cell view:self.view];
            [self.collectionView performBatchUpdates:^{
            NSNumber *two = [NSNumber numberWithInteger:2];
            [self.activeLevelState setObject:two atIndexedSubscript:threeFifteenIndex];
            } completion:^(BOOL finished){
                if (finished) {
                    [self updateCellatIndex:indexPath];
                    [self updateRemainingCount];
                    [self checkForClear];
                }
            }];
            return;
        }
        //Blue
        if (stateSelectedInt==2) {
            //Shatter
            [SimpleAVAudioPlayer playFile:@"break.aif" loops:0 withCompletionBlock:^(BOOL finished) {}];
            CellBlue *cell = (CellBlue *)[collectionView cellForItemAtIndexPath:indexPath];
            [cell performShatterAnimations:cell view:self.view];
            //Make gray
            [self.collectionView performBatchUpdates:^{
                NSNumber *three = [NSNumber numberWithInteger:3];
                [self.activeLevelState setObject:three atIndexedSubscript:threeFifteenIndex];
            } completion:^(BOOL finished){
                if (finished) {
                    [self updateCellatIndex:indexPath];
                    [self updateRemainingCount];
                    [self checkForClear];
                }
            }];
            return;
        }
    }
}

-(void)updateCellatIndex:(NSIndexPath*)index {
    [UIView setAnimationsEnabled:NO];
    [self.collectionView reloadItemsAtIndexPaths:@[index]];
    [UIView setAnimationsEnabled:YES];
}

-(void)initialMinesCount {
    self.minesCount = 0;
    for (NSInteger i=0; i < 315; i++){
        if ([[self.activeLevelNumber objectAtIndex:i] integerValue] == 1000) {
            self.minesCount += 1;
        }
    }
    self.remainingCount = self.minesCount;
    self.remainingLabel.text = [@(self.remainingCount) stringValue];
}

-(void)updateRemainingCount {
    NSInteger currentMinesCount = 0;
    for (NSInteger i=0; i < 315; i++){
        NSNumber *state = [self.activeLevelState objectAtIndex:i];
        if ([state integerValue] == 2){
            currentMinesCount += 1;
        }
    }
    self.remainingCount = self.minesCount - currentMinesCount;
    self.remainingLabel.text = [@(self.remainingCount) stringValue];
}

-(void)updateMistakesCount {
    self.mistakeCount += 1;
    self.mistakesLabel.text = [@(self.mistakeCount) stringValue];
}

-(void)checkForClear {
    NSInteger correctMines = 0;
    for (NSInteger i=0; i < 315; i++) {
        NSInteger number = [[self.activeLevelNumber objectAtIndex:i] integerValue];
        NSInteger state = [[self.activeLevelState objectAtIndex:i] integerValue];
        //Found an orange cell, no clear
        if (state == 1){
            break;
        }
        //A mine is marked correctly
        if (state == 2 && number == 1000) {
            correctMines += 1;
        }
        //All actual mines are marked and there are no incorrectly marked mines
        if (correctMines == self.minesCount && self.remainingCount == 0){
            [self levelClear];
            break;
        }
    }
}

-(void)levelClear {
    [SimpleAVAudioPlayer playFile:@"complete.aif" loops:0 withCompletionBlock:^(BOOL finished) {}];
    self.mistakeCount = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *beatenLevels = [[defaults objectForKey:@"beatenLevels"] mutableCopy];
    NSInteger levelNumber = [defaults integerForKey:@"selectedLevel"];
    if (![beatenLevels containsObject:@(levelNumber)]) {
        [beatenLevels addObject:@(levelNumber)];
        [defaults setObject:beatenLevels forKey:@"beatenLevels"];
        [defaults synchronize];
    }
    if (levelNumber < 16) {
        [defaults setInteger:levelNumber+1 forKey:@"selectedLevel"];
        [defaults synchronize];
        [self loadLevel:[self levelString]];
        self.levelLabel.text = self.levelLabelString;
        [self levelTransition];
    }
    else {
        [self goToMenu];
    }
}

//OVERLAYS
-(void)goToMenu {
    UIView *gray = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2048, 1024)];
    gray.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    gray.alpha = 0;
    [self.view addSubview:gray];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        gray.alpha = 1;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.navigationController popToRootViewControllerAnimated:NO];
                         }}];
}

-(void)addOverlays {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL havePlayed = [defaults boolForKey:@"havePlayed"];
    if (havePlayed == false) {
        [self instructionsOverlay];
        [defaults setBool:true forKey:@"havePlayed"];
        [defaults synchronize];
    }
    [self levelOverlay];
    [self menuButtonOverlay];
    [self remainingOverlay];
    [self mistakesOverlay];
}

-(void)menuButtonOverlay {
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(-135, 65, 330, 65)];
    [menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    menuButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:72];
    [menuButton setTitleColor:[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1] forState:UIControlStateNormal];
    [menuButton setTitleColor:[UIColor colorWithRed:0.26 green:0.65 blue:0.91 alpha:1] forState:UIControlStateHighlighted];
    [self.view addSubview:menuButton];
    menuButton.transform = CGAffineTransformMakeRotation(M_PI/2);
    [menuButton addTarget:self action:@selector(goToMenu) forControlEvents:UIControlEventTouchUpInside];
}

-(void)levelOverlay {
    self.levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(-135, 768 - 200, 330, 65)];
    self.levelLabel.text = self.levelLabelString;
    self.levelLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:72];
    self.levelLabel.textColor = [UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:1];
    self.levelLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.levelLabel];
    self.levelLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
}

-(void)mistakesOverlay {
    UIView *mistakesOverlayView = [[UIView alloc] initWithFrame:CGRectMake(1024-190, 15, 175, 60)];
    mistakesOverlayView.backgroundColor = [UIColor colorWithRed:0.26 green:0.65 blue:0.91 alpha:1];
    mistakesOverlayView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    mistakesOverlayView.layer.masksToBounds = NO;
    mistakesOverlayView.layer.shadowOffset = CGSizeMake(-5, 5);
    mistakesOverlayView.layer.shadowRadius = 2.0;
    mistakesOverlayView.layer.shadowOpacity = 0.2;
    
    UILabel *mistakesTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20, 0, 175, 20)];
    mistakesTextLabel.text = @"MISTAKES";
    mistakesTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    mistakesTextLabel.textColor = [UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1];
    mistakesTextLabel.textAlignment = NSTextAlignmentRight;
    
    self.mistakesLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20, 18, 175, 40)];
    self.mistakesLabel.text = [@(self.mistakeCount) stringValue];
    self.mistakesLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:46.0];
    self.mistakesLabel.textColor = [UIColor whiteColor];
    self.mistakesLabel.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:mistakesOverlayView];
    [mistakesOverlayView addSubview:self.mistakesLabel];
    [mistakesOverlayView addSubview:mistakesTextLabel];
}


-(void)remainingOverlay {
    UIView *remaningOverlayView = [[UIView alloc] initWithFrame:CGRectMake(1024-190, 75+10, 175, 60)];
    remaningOverlayView.backgroundColor = [UIColor colorWithRed:0.26 green:0.65 blue:0.91 alpha:1];
    remaningOverlayView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    remaningOverlayView.layer.masksToBounds = NO;
    remaningOverlayView.layer.shadowOffset = CGSizeMake(-5, 5);
    remaningOverlayView.layer.shadowRadius = 2.0;
    remaningOverlayView.layer.shadowOpacity = 0.2;
    
    UILabel *remainingTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20, 0, 175, 20)];
    remainingTextLabel.text = @"REMAINING";
    remainingTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    remainingTextLabel.textColor = [UIColor colorWithRed:0.88 green:0.87 blue:0.86 alpha:1];
    remainingTextLabel.textAlignment = NSTextAlignmentRight;
    
    self.remainingLabel = [[UILabel alloc] initWithFrame:CGRectMake(-20, 18, 175, 40)];
    self.remainingLabel.text = [@(self.remainingCount) stringValue];
    self.remainingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:46];
    self.remainingLabel.textColor = [UIColor whiteColor];
    self.remainingLabel.textAlignment = NSTextAlignmentRight;
    
    [self.view addSubview:remaningOverlayView];
    [remaningOverlayView addSubview:self.remainingLabel];
    [remaningOverlayView addSubview:remainingTextLabel];
}

-(void)instructionsOverlay {
    NSString *instructions = @"Remove orange hexes to reveal the pattern underneath.\n\nThe number in an empty hex tells you how many adjacent hexes are part of the pattern. \n\nTap a hex once to mark it as part of the pattern. Tap again to destroy hexes that aren’t part of the pattern.";
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"How To Play Hexcells"
                                                      message:instructions
                                                     delegate:self
                                            cancelButtonTitle:@"Ok!"
                                            otherButtonTitles:nil];
    [message show];
}

@end
