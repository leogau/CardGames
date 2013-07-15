//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Leo Gau on 7/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *scoreTextView;
@property (nonatomic) SEL sortSelector;
@end

@implementation GameResultViewController
@synthesize sortSelector = _sortSelector;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - Accessors

- (SEL)sortSelector
{
    if (!_sortSelector) {
        _sortSelector = @selector(compareScoreToGameResult:);
    }
    
    return _sortSelector;
}

- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
}

#pragma mark - Private

- (void)updateUI
{
    NSMutableString *displayText = [[NSMutableString alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    for (GameResult *result in [[GameResult allGameResults] sortedArrayUsingSelector:self.sortSelector]) {
        [displayText appendFormat:@"Score: %d (%@, %0gs)\n", result.score, [formatter stringFromDate:result.end], round(result.duration)];
    }
    self.scoreTextView.text = displayText;
}

#pragma mark - IBAction

- (IBAction)sortByDate:(UIButton *)sender
{
    self.sortSelector = @selector(compareEndDateToGameResult:);
}

- (IBAction)sortByScore:(UIButton *)sender
{
    self.sortSelector = @selector(compareScoreToGameResult:);
}

- (IBAction)sortByDuration:(UIButton *)sender
{
    self.sortSelector = @selector(compareDurationToGameResult:);
}

@end
