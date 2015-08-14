//
//  ViewController.m
//  MemMatch
//
//  Created by Keshav Dasu on 7/13/15.
//  Copyright (c) 2015 Keshav Dasu. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentedControlIndexChanged;

@property (strong,nonatomic) CardMatchingGame * game;
@property int numberOfCards;
@end

@implementation ViewController

-(CardMatchingGame *)game{
    if(!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                         usingDeck:[self createDeck]];
    return _game;
}

-(PlayingCardDeck *)createDeck{
    return [[PlayingCardDeck alloc]init];
}



- (IBAction)segmentedControlIndexChanged {
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _numberOfCards = 2;
            break;
        case 1:
            _numberOfCards = 3;
            break;
        default:
            _numberOfCards = 2;
            break;
    }
}


- (IBAction)touchCardButton:(UIButton *)sender {
    _segmentedControl.enabled = NO;
    NSUInteger chooseButtonIndex = [self.cardButtons indexOfObject:sender];
    if(_numberOfCards < 2 || _numberOfCards > 3) _numberOfCards = 2;
    [self.game chooseCardAtIndex:chooseButtonIndex numberOfCards:_numberOfCards];
    [self updateUI];
}

- (IBAction)reDealButton {
    _segmentedControl.enabled = YES;
    for(UIButton * cardButton in self.cardButtons){
        [cardButton setBackgroundImage:[UIImage imageNamed:@"cardBack"] forState:UIControlStateNormal];
        [cardButton setTitle:@"" forState:UIControlStateNormal];
        cardButton.enabled = YES;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: 0"];
    [self.game reDeal];
}

-(void)updateUI{
    for(UIButton * cardButton in self.cardButtons){
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card * card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card]forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",(int)self.game.score];
    }
}

-(NSString *)titleForCard:(Card *)card{
    return (card.isChosen) ? card.contents : @"";
}

-(UIImage *)backgroundImageForCard:(Card *)card{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

@end
