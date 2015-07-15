//
//  PlayingCard.m
//  MemMatch
//
//  Created by Keshav Dasu on 7/13/15.
//  Copyright (c) 2015 Keshav Dasu. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(NSString *)contents{
    NSArray * rankStrings = [PlayingCard rankStrings];
    return [rankStrings[(int)self.rank] stringByAppendingString:self.suit];
}
+(NSArray *)rankStrings{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

@synthesize suit = _suit;

+(NSArray *)validSuits{
    return @[@"♠️",@"♣️",@"♥️",@"♦️"];
}
-(void)setSuit:(NSString *)suit{
    if([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}
-(NSString *)suit{
    return _suit ? _suit : @"?";
}

+(NSUInteger)maxRank{ return [[self rankStrings] count] - 1; }
-(void)setRank:(NSUInteger)rank{
    if(rank <= [PlayingCard maxRank]){
        _rank = rank;
    }
}

-(NSUInteger)match:(NSArray *)otherCards{
    int score = 0;
    if([otherCards count] == 1){
        PlayingCard * otherCard = [otherCards firstObject];
        if(otherCard.rank == self.rank){
            score = 4;
        }else if([otherCard.suit isEqualToString:self.suit]){
            score = 1;
        }
    }
    
    return score;
}

@end
