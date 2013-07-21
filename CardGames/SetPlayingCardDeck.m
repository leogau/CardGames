//
//  SetPlayingCardDeck.m
//  CardGames
//
//  Created by Leo Gau on 7/20/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "SetPlayingCardDeck.h"
#import "SetPlayingCard.h"

@implementation SetPlayingCardDeck

- (id)init
{
    self = [super init];
    if (self) {
        for (int i = 1; i <= [SetPlayingCard maxNumber]; i++) {
            for (NSString *symbol in [SetPlayingCard validSymbols]) {
                for (NSString *shade in [SetPlayingCard validShades]) {
                    for (UIColor *color in [SetPlayingCard validColors]) {
                        SetPlayingCard *card = [[SetPlayingCard alloc] init];
                        card.number = i;
                        card.symbol = symbol;
                        card.shade = shade;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
