//
//  Deck.m
//  MemMatch
//
//  Created by Keshav Dasu on 7/13/15.
//  Copyright (c) 2015 Keshav Dasu. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong,nonatomic) NSMutableArray * cards;
@end

@implementation Deck

@synthesize cards = _cards;

-(NSMutableArray *)cards{
    if(!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

-(void)setCards:(NSMutableArray *)cards{
    
}


-(void)addCard:(Card *)card atTop:(BOOL)atTop{
    
    if(atTop){
        [self.cards insertObject:card atIndex:0];
    }else{
        [self.cards addObject:card];
    }
    
}

-(void)addCard:(Card *)card{
    [self addCard:card atTop:NO];
}


-(Card *)drawRandomCard{
    Card * random = nil;
    if([self.cards count]){
        unsigned index = arc4random() % [self.cards count];
        random = [self.cards objectAtIndex:index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return random;
}

@end
