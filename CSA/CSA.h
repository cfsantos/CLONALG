//
//  CSA.h
//  CSA
//
//  Created by Claudio Filipi Goncalves dos Santos on 7/14/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSA : NSObject

@property(nonatomic, strong)NSMutableArray *iteractionsForGeneticAlgorithm;
@property(nonatomic, strong)NSMutableArray *timesForGeneticAlgorithm;
@property(nonatomic, strong)NSMutableArray *valuesForGeneticAlgorithm;

-(void)calculateBestValue;

@end
