//
//  Card.m
//  Matchismo
//
//  Created by Leo Gau on 7/13/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end
