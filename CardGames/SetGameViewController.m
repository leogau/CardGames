//
//  SetGameViewController.m
//  CardGames
//
//  Created by Leo Gau on 7/20/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetPlayingCardDeck.h"
#import "SetPlayingCard.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *setGameCards;
@property (weak, nonatomic) IBOutlet UILabel *gameDescription;
@property (weak, nonatomic) IBOutlet UILabel *flipsCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) NSMutableArray *cardHistory;

@end

@implementation SetGameViewController

#pragma mark - Accessors

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.setGameCards.count usingDeck:[[SetPlayingCardDeck alloc] init]];
    }
    
    return _game;
}

- (NSMutableArray *)cardHistory
{
    if (!_cardHistory) {
        _cardHistory = [[NSMutableArray alloc] init];
    }
    
    return _cardHistory;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsCount.text = [NSString stringWithFormat:@"Flips: %d", flipCount];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

#pragma mark - IBActions

- (IBAction)dealPressed:(UIButton *)sender
{
    self.flipCount = 0;
    self.game = nil;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender
{
    NSUInteger cardIndex = [self.setGameCards indexOfObject:sender];
    SetPlayingCard *cardAtIndex = (SetPlayingCard *)[self.game cardAtIndex:cardIndex];
    [self.cardHistory addObject:cardAtIndex];
    
    [self.game flipSetCardAtIndex:cardIndex];
    self.flipCount += 1;

    self.gameDescription.attributedText = [self styleGameDescription:self.game.description withCard:self.cardHistory];
    [self updateUI];
    
    if (self.cardHistory.count == 3) {
        self.cardHistory = nil;
    }
}

#pragma mark - Private

- (void)updateUI
{
    for (UIButton *cardButton in self.setGameCards) {
        SetPlayingCard *card = (SetPlayingCard *)[self.game cardAtIndex:[self.setGameCards indexOfObject:cardButton]];
        
        NSAttributedString *cardTitle = [self styleCard:card];
        
        [cardButton setAttributedTitle:cardTitle forState:UIControlStateSelected];
        [cardButton setAttributedTitle:cardTitle forState:UIControlStateNormal];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.1 : 1.0;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (NSAttributedString *)styleGameDescription:(NSString *)gameDescription
                                    withCard:(NSArray *)cards
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:gameDescription];
    for (SetPlayingCard * card in cards) {
        NSRange range = [gameDescription rangeOfString:card.contents];
        if (range.location != NSNotFound) {
            NSDictionary *attributes = [self getAttributesDictionary:card];
            [result addAttributes:attributes range:range];
        }
    }

    return result;
}

- (NSAttributedString *)styleCard:(SetPlayingCard *)card
{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:card.contents];
    NSDictionary *attributes = [self getAttributesDictionary:card];
    
    [result addAttributes:attributes range:[card.contents rangeOfString:card.contents]];
    
    return result;
}

- (NSDictionary *)getAttributesDictionary:(SetPlayingCard *)card
{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:20.0];
    
    NSString *shade = card.shade;
    if ([shade isEqualToString:@"SOLID"]) {
        attributes[NSForegroundColorAttributeName] = card.color;
        attributes[NSStrokeColorAttributeName] = card.color;
    } else if ([shade isEqualToString:@"OPEN"]) {
        attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
        attributes[NSStrokeColorAttributeName] = card.color;
        attributes[NSStrokeWidthAttributeName] = @5.0;
    } else if ([shade isEqualToString:@"STRIPE"]) {
        UIColor *foregroundColor = card.color;
        [foregroundColor colorWithAlphaComponent:0.5];
        
        attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        attributes[NSStrokeColorAttributeName] = card.color;
        attributes[NSStrokeWidthAttributeName] = @-3.0;
    }
    
    return attributes;
}

@end
