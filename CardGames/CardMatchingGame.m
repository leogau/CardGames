//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Leo Gau on 7/14/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;

@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}

#pragma mark - Accessors

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

#pragma mark - Instance

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            
            if (self.gameType == 0) {
                for (Card *otherCard in self.cards) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable && otherCard != card) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            otherCard.unplayable = YES;
                            card.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            self.description = [NSString stringWithFormat:@"Matched %@ and %@ for %d points", card.contents, otherCard.contents, matchScore * MATCH_BONUS];
                        } else {
                            otherCard.faceUp = NO;
                            self.score -= MISMATCH_PENALTY;
                            self.description = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty", card.contents, otherCard.contents, MISMATCH_PENALTY];
                        }
                        break;
                    } else {
                        self.description = [NSString stringWithFormat:@"Flipped up %@", card.contents];
                    }
                }
            } else {
                NSMutableArray *cardsFaceUp = [[NSMutableArray alloc] init];
                for (Card *otherCard in self.cards) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable && otherCard != card) {
                        [cardsFaceUp addObject:otherCard];
                    }
                }
                if (cardsFaceUp.count == 2) {
                    int matchScore = [card match:cardsFaceUp];
                    if (matchScore) {
                        for (Card *aCard in cardsFaceUp) {
                            aCard.unplayable = YES;
                        }
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.description = [NSString stringWithFormat:@"Matched %@, %@, and %@ for %d points", card.contents, [cardsFaceUp[0] contents], [cardsFaceUp[1] contents], matchScore * MATCH_BONUS];
                    } else {
                        for (Card *aCard in cardsFaceUp) {
                            aCard.faceUp = NO;
                        }
                        self.score -= MISMATCH_PENALTY;
                        self.description = [NSString stringWithFormat:@"%@, %@, and %@ don't match! %d point penalty", card.contents, [cardsFaceUp[0] contents], [cardsFaceUp[1] contents], MISMATCH_PENALTY];
                    }
                } else {
                    self.description = [NSString stringWithFormat:@"Flipped up %@", card.contents];
                }
            }

            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
