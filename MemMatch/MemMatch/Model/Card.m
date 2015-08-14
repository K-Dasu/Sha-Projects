//
//  Card.m
//  MemMatch
//
//  Created by Keshav Dasu on 7/13/15.
//  Copyright (c) 2015 Keshav Dasu. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

-(NSUInteger)match:(NSArray *)otherCards{
    int score = 0;
    
    for (Card * card in otherCards){
        if([card.contents containsString:self.contents]){
            score = 1;
        }
    }
    return score;
}

@end
