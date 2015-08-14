//
//  PlayingCard.h
//  MemMatch
//
//  Created by Keshav Dasu on 7/13/15.
//  Copyright (c) 2015 Keshav Dasu. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString * suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *)validSuits;
+(NSUInteger)maxRank;
@end
