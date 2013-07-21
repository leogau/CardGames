//
//  SetPlayingCard.m
//  CardGames
//
//  Created by Leo Gau on 7/20/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "SetPlayingCard.h"

@implementation SetPlayingCard

#pragma mark - Accessors

- (void)setNumber:(int)number
{
    if (number > 0 && number <= 3) {
        _number = number;
    }
}

- (void)setSymbol:(NSString *)symbol
{
    if ([[SetPlayingCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)contents
{
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < self.number; i++) {
        [result appendString:self.symbol];
    }
    return result;
}

#pragma mark - Instance

#define SET_MATCH_SCORE 1

// Rules: Must satisfy all rules
//They all have the same number, or they have three different numbers.
//They all have the same symbol, or they have three different symbols.
//They all have the same shading, or they have three different shadings.
//They all have the same color, or they have three different colors.
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    SetPlayingCard *card1 = nil;
    SetPlayingCard *card2 = nil;
    id firstObj = otherCards[0];
    id secondObj = otherCards[1];
    if ([firstObj isKindOfClass:[SetPlayingCard class]]) {
        card1 = firstObj;
    }
    
    if ([secondObj isKindOfClass:[SetPlayingCard class]]) {
        card2 = secondObj;
    }
    
    // Match numbers
    if ((self.number == card1.number && self.number == card2.number) ||
        (self.number != card1.number && self.number != card2.number)) {
        score += SET_MATCH_SCORE;
    } else {
        return 0;
    }
    
    // Match symbols
    if (([self.symbol isEqualToString:card1.symbol] &&
           [self.symbol isEqualToString:card1.symbol]) ||
          (![self.symbol isEqualToString:card1.symbol] &&
           ![self.symbol isEqualToString:card2.symbol]))
    {
        score += SET_MATCH_SCORE;
    } else {
        return 0;
    }
    
    //Match shading
    if (([self.shade isEqualToString:card1.shade] &&
         [self.shade isEqualToString:card2.shade]) ||
        (![self.shade isEqualToString:card1.shade] &&
         ![self.shade isEqualToString:card2.shade]))
    {
        score += SET_MATCH_SCORE;
    } else {
        return 0;
    }
    
    // Match colors
    if (([self.color isEqual:card1.color] && [self.color isEqual:card2.color]) ||
        (![self.color isEqual:card1.color] && ![self.color isEqual:card2.color]))
    {
        score += SET_MATCH_SCORE;
    } else {
        return 0;
    }
    
    return score;
}


#pragma mark - Class methods

+ (NSArray *)validSymbols
{
    return @[@"▲", @"●", @"■"];
}

+ (NSArray *)validColors
{
    return @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
}

+ (NSArray *)validShades
{
    return @[@"SOLID", @"STRIPE", @"OPEN"];
}

+ (int)maxNumber
{
    return 3;
}


@end
