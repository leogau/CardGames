//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Leo Gau on 7/13/13.
//  Copyright (c) 2013 Leo Gau. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameDescriptionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeChooserSegmentedControl;

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) int flipCount;
@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}

#pragma mark - Accessors

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
    }
    
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", flipCount];
}

#pragma mark - IBAction

- (IBAction)flipCard:(UIButton *)sender
{
    self.gameTypeChooserSegmentedControl.enabled = NO;
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount += 1;
    [self updateUI];
}

- (IBAction)dealPressed:(UIButton *)sender
{
    self.flipsLabel.text = @"Flips: 0";
    self.scoreLabel.text = @"Score: 0";
    self.flipCount = 0;
    self.gameDescriptionLabel.text = nil;
    self.game = nil;
    self.gameTypeChooserSegmentedControl.enabled = YES;
    [self updateUI];
}

- (IBAction)gameTypeChooser:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex != self.game.gameType) {
        self.game.gameType = sender.selectedSegmentIndex;
    }
}


#pragma mark - Private

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        UIImage *background = [UIImage imageNamed:@"card.jpg"];
        [cardButton setImage:(card.isFaceUp ? nil : background) forState:UIControlStateNormal];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.gameDescriptionLabel.text = self.game.description;
}

@end
