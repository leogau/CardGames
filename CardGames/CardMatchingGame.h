//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Leo Gau on 7/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

- (void)flipSetCardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic) NSUInteger gameType;
@property (nonatomic, strong) NSString *description;

@end


