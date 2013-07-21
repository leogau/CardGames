//
//  SetPlayingCard.h
//  CardGames
//
//  Created by Leo Gau on 7/20/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "Card.h"

@interface SetPlayingCard : Card

@property (nonatomic) int number;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *shade;
@property (nonatomic, strong) UIColor *color;

+ (NSArray *)validSymbols;
+ (NSArray *)validColors;
+ (NSArray *)validShades;
+ (int)maxNumber;

@end
