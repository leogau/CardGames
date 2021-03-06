//
//  GameResult.m
//  Matchismo
//
//  Created by Leo Gau on 7/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "GameResult.h"

#define ALL_RESULTS_KEY @"GameResult_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"

@interface GameResult ()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation GameResult

- (id)init
{
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    
    return self;
}

- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = (NSDictionary *)plist;
            _start = resultDic[START_KEY];
            _end = resultDic[END_KEY];
            _score = [resultDic[SCORE_KEY] intValue];
            if (!_start || !_end) {
                self = nil;
            }
        }
    }
    
    return self;
}

#pragma mark - Accessors

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

-(void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

#pragma mark - Private

- (void)synchronize
{
    NSMutableDictionary *gameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!gameResultsFromUserDefaults) {
        gameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    }
    gameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:gameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{ START_KEY: self.start, END_KEY: self.end, SCORE_KEY: @(self.score) };
}

#pragma mark - Class

+ (NSArray *)allGameResults
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (id plist in [[[NSUserDefaults standardUserDefaults] objectForKey:ALL_RESULTS_KEY] allValues]) {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
        [results addObject:result];
    }
    
    return results;
}

#pragma mark - Sorting

- (NSComparisonResult)compareScoreToGameResult:(GameResult *)otherResult
{
    if (self.score > otherResult.score) {
        return NSOrderedAscending;
    } else if(self.score < otherResult.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareEndDateToGameResult:(GameResult *)otherResult
{
    return [otherResult.end compare:self.end];
}

- (NSComparisonResult)compareDurationToGameResult:(GameResult *)otherResult
{
    if (self.duration > otherResult.duration) {
        return NSOrderedDescending;
    } else if (self.duration < otherResult.duration) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}

@end
