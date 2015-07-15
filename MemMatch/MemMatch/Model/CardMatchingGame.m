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
@end

@implementation CardMatchingGame

-(NSMutableArray *)cards{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
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
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_PICK = 1;

-(void)chooseCardAtIndex:(NSUInteger)index{
    Card * card = [self cardAtIndex:index];
    if(!card.isMatched){
        if(card.isChosen){
            card.chosen = NO;
        }else{
            for(Card * otherCards in self.cards){
                if(otherCards.isChosen && !otherCards.isMatched){
                    NSInteger matchScore = [card match:@[otherCards]];
                    if(matchScore){
                        self.score += matchScore * MATCH_BONUS;
                        otherCards.matched = YES;
                        card.matched = YES;
                    }else{
                        self.score =((self.score - MISMATCH_PENALTY) >= 0) ? self.score - MISMATCH_PENALTY : 0;
                        otherCards.chosen = NO;
                    }
                    break;
                }
            }
            self.score = ((self.score - COST_TO_PICK) >= 0) ? self.score - COST_TO_PICK : 0;
            card.chosen = YES;
        }
    }
    
}
-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


@end
