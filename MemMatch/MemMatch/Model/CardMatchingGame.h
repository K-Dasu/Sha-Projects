//
//  CardMatchingGame.h
//  MemMatch
//
//  Created by Keshav Dasu on 7/14/15.
//  Copyright (c) 2015 Keshav Dasu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck;
-(void)chooseCardAtIndex:(NSUInteger)index numberOfCards:(NSUInteger)maxCards;
-(Card *)cardAtIndex:(NSUInteger)index;
-(void)reDeal;

@property (nonatomic, readonly) NSInteger score;

@end
