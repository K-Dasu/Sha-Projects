//
//  CardMatchingGame.m
//  MemMatch
//
//  Created by Keshav Dasu on 7/14/15.
//  Copyright (c) 2015 Keshav Dasu. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCardDeck.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray * cards;
@property (nonatomic, strong) NSMutableArray * currentSelection;
@end

@implementation CardMatchingGame

-(NSMutableArray *)cards{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray *)currentSelection{
    if(!_currentSelection) _currentSelection = [[NSMutableArray alloc] init];
    return _currentSelection;
}
-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck{
    self = [super init];
    if(self){
        for(int i = 0; i < count; i++){
            Card * card = [deck drawRandomCard];
            if(card) {
                [self.cards addObject:card];
            }else{
                self = nil;
                break;
            }
        }
        _currentSelection = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)reDeal{
    Deck * newDeck = [[PlayingCardDeck alloc]init];
    for(int i = 0; i < [self.cards count]; i++){
        Card * card = [newDeck drawRandomCard];
        [self.cards replaceObjectAtIndex:i withObject:card];
    }
    self.score = 0;
    [_currentSelection removeAllObjects];
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_PICK = 1;



//matching N cards
-(void)chooseCardAtIndex:(NSUInteger)index numberOfCards:(NSUInteger)maxCards{
    Card * card = [self cardAtIndex:index];
    if(![_currentSelection containsObject:card]){ [_currentSelection addObject:card]; }
    
    if(!card.isMatched){
        Card * firstSelection = [_currentSelection objectAtIndex:0];
        if(card.isChosen && [card.contents isEqualToString:firstSelection.contents]){
            //for each card in the current selection deselect
            for(Card * selectedCards in _currentSelection)
                selectedCards.chosen = NO;
            [self updateCards];
            [_currentSelection removeAllObjects]; //clear selection
        }else if([_currentSelection count] == maxCards){
            //Start the scoring
            card.chosen = YES;
            [self scoringForMultipleCards];
            return;
        }else if([_currentSelection count] < maxCards){
            //Set the card to be chosen
            card.chosen = YES;
            self.score = ((self.score - COST_TO_PICK) >= 0) ? self.score - COST_TO_PICK : 0;
        }
    }
    [self updateCards];
}
-(void)scoringForMultipleCards{
    NSInteger i,j,failFlag = 0;
    for(i = 0; i < [_currentSelection count]; i++){
        for(j = i + 1; j < [_currentSelection count]; j++){
            Card * card = [_currentSelection objectAtIndex:i];
            Card * otherCard = [_currentSelection objectAtIndex:j];
            NSInteger matchScore = [card match:@[otherCard]];
            if(matchScore){
                self.score += matchScore * MATCH_BONUS;
                otherCard.matched = YES;
                card.matched = YES;
                failFlag = 99;
            }else{
                failFlag--;
            }
        }
    }
    
    [self didMatchFail:failFlag];
}

-(void)didMatchFail:(NSInteger)failed{
    if(failed < 0){
        self.score =((self.score - MISMATCH_PENALTY) >= 0) ? self.score - MISMATCH_PENALTY : 0;
        for(int i = 0; i + 1  < [_currentSelection count]; i++){
            Card * selectedCards = [_currentSelection objectAtIndex:i];
            selectedCards.chosen = NO;
            selectedCards.matched = NO;
        }
        [self updateCards];
        Card * lastCard = [_currentSelection lastObject];
        [_currentSelection removeAllObjects]; //but the last object
        [_currentSelection addObject:lastCard];
    }else{
        for(int i = 0; i < [_currentSelection count]; i++){
            Card * selectedCards = [_currentSelection objectAtIndex:i];
            if(!selectedCards.isMatched){
                selectedCards.matched = YES;
                self.score += 1;
            }
        }
        [self updateCards];
        [_currentSelection removeAllObjects];
    }
}

-(void)updateCards{
    //update the cards array
    for (Card * otherCards in self.cards){
        for(Card * selectedCard in self.currentSelection){
            if([otherCards.contents isEqualToString:selectedCard.contents]){
                otherCards.matched = selectedCard.matched;
                otherCards.chosen = selectedCard.chosen;
            }
        }
    }
}


-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


@end
