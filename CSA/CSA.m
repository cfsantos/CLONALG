//
//  CSA.m
//  CSA
//
//  Created by Claudio Filipi Goncalves dos Santos on 7/14/15.
//  Copyright (c) 2015 Claudio Filipi Goncalves dos Santos. All rights reserved.
//

#import "CSA.h"

@interface CSA ()

@property(nonatomic, strong)NSArray *antigeneArray;
@property(nonatomic, strong)NSArray *bestDNA;
@property(nonatomic, strong)NSArray *parentsArray;
@property(nonatomic)int triesAfterGetBestDNA;

@end

#define ARC4RANDOM_MAX      0x100000000
#define MAXTRIESAFTERBESTVALUE 100

@implementation CSA

-(void)calculateBestValue{
    self.iteractionsForGeneticAlgorithm = [NSMutableArray new];
    self.timesForGeneticAlgorithm = [NSMutableArray new];
    self.valuesForGeneticAlgorithm = [NSMutableArray new];
    
    NSMutableArray *bestValues = [NSMutableArray new];
    NSMutableArray *iteractions = [NSMutableArray new];
    NSMutableArray *time = [NSMutableArray new];
    
    NSMutableArray *fitnessArray = [NSMutableArray new];
    self.triesAfterGetBestDNA = 0;
    
    //starting my tests from 0
    self.bestDNA = @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];

    
    //matrix used for comparing results
    self.parentsArray = @[    @[@0,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@1],
                              @[@1,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@0],
                              @[@0,@0,@0,@0,@0,@0,@0,@1,@0,@1,@0,@1],
                              @[@0,@0,@0,@0,@0,@1,@0,@1,@0,@1,@0,@0],
                              @[@0,@1,@0,@0,@0,@0,@0,@1,@0,@0,@0,@1],
                              @[@0,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@0],
                              @[@1,@0,@0,@0,@0,@0,@0,@1,@0,@1,@0,@1],
                              @[@0,@0,@0,@0,@0,@0,@0,@1,@0,@1,@0,@0]  ];
    
    //I keep a copy of the parent matrix so I can recover after finished a try
    NSArray *auxCreatedArray = [self.parentsArray copy];
    
    int iteraction = 0;
    
    int position = 0;
//    
//    for (NSArray *compareArray in self.parentsArray) {
//        int fitness = [self fitnessBetweenCreatedArray:compareArray andTargetArray:self.bestDNA];
//        fitnessArray[position] = @(fitness);
//        position++;
//    }
    
    for (int counter = 0; counter < 100; counter++) {
        NSDate *date = [NSDate date];
        
        //stop condition: the algorithm can't find any better value after MAXTRIESAFTERBESTVALUE tries
        while (self.triesAfterGetBestDNA < MAXTRIESAFTERBESTVALUE) {
            for (NSArray *aParent in self.parentsArray) {
                self.bestDNA = [self changeDNAForBestSequence:aParent];
            }
            
            for (NSArray *compareArray in self.parentsArray) {
                int fitness = [self fitnessBetweenCreatedArray:compareArray andTargetArray:self.bestDNA];
                fitnessArray[position] = @(fitness);
                position++;
            }
            
            self.parentsArray = [self mutagenicParentsArrayFromParentsArray:self.parentsArray usingFitnessArray:fitnessArray];
            
            self.triesAfterGetBestDNA++;
            iteraction++;
            //        self.antigeneArray = [self bestDNAFromParents:self.parentsArray usingFitnessArray:fitnessArray];
        }
        
        
        
        NSLog(@"Best value: %f in iteraction %i, time: %f", [self functionForExercise:[self numberFromDNASequence:self.bestDNA]], iteraction, -[date timeIntervalSinceNow]);
        
        [bestValues addObject:@([self functionForExercise:[self numberFromDNASequence:self.bestDNA]])];
        [iteractions addObject:@(iteraction)];
        [time addObject:@(-[date timeIntervalSinceNow])];
        
        iteraction = 0;
        
        NSMutableArray *fitnessArray = [NSMutableArray new];
        self.triesAfterGetBestDNA = 0;
        
        //starting my tests from 0
        self.bestDNA = @[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0];
        
        
        //matrix used for comparing results
        self.parentsArray = @[    @[@0,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@1],
                                  @[@1,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@0],
                                  @[@0,@0,@0,@0,@0,@0,@0,@1,@0,@1,@0,@1],
                                  @[@0,@0,@0,@0,@0,@1,@0,@1,@0,@1,@0,@0],
                                  @[@0,@1,@0,@0,@0,@0,@0,@1,@0,@0,@0,@1],
                                  @[@0,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@0],
                                  @[@1,@0,@0,@0,@0,@0,@0,@1,@0,@1,@0,@1],
                                  @[@0,@0,@0,@0,@0,@0,@0,@1,@0,@1,@0,@0]  ];
    }
    
    NSLog(@"Medium of best values: %f, medium of iteractions: %f, medium of time: %f",[self mediumNumberInArray:bestValues], [self mediumNumberInArray:iteractions], [self mediumNumberInArray:time]);
    
}

#pragma mark - mutagenic action

-(NSArray *)mutagenicParentsArrayFromParentsArray:(NSArray *)parentsArray usingFitnessArray:(NSArray *)fitnessArray{
    NSMutableArray *returnArray = [NSMutableArray new];
    for (int counter = 0; counter < [parentsArray count]; counter++) {
        NSMutableArray *aParent = [parentsArray[counter] mutableCopy];
        int numberOfMutations = 12 - [fitnessArray[counter] intValue];
        for (int mutationCounter = 0; mutationCounter < numberOfMutations; mutationCounter++) {
            int positionOfMutation = arc4random_uniform(12);
            NSNumber *aGene = aParent[positionOfMutation];
            aGene = ([aGene  isEqual: @1] ? @0 : @1);
            aParent[positionOfMutation] = aGene;
        }
        
        [returnArray addObject:aParent];
    }
    
    return returnArray;
}


#pragma mark - Fitness calculation

//calculates the fitness of a DNA, based on the target value
-(int)fitnessBetweenCreatedArray:(NSArray *)createdArray andTargetArray:(NSArray *)targetArray{
    int fitness = 0;
    
    //for each gene in DNA of created array
    for (int i = 0; i <= 11; i++) {
        //if the gene in position i of createdArray is the same gene in position i of the target array, increments the fitness
        if (createdArray[i] == targetArray[i])
            fitness++;
    }
    
    return fitness;
}

-(NSArray *)bestDNAFromParents:(NSArray *)parentsArray usingFitnessArray:(NSArray *)fitnessArray{
    NSNumber *bestNumber = fitnessArray[0];
    int bestPosition = 0;
    for (int counter = 1; counter < [fitnessArray count]; counter++) {
        NSNumber *aNumber = fitnessArray[counter];
        if (aNumber > bestNumber) {
            bestNumber = aNumber;
            bestPosition = counter;
        }
    }
    
    return parentsArray[bestPosition];
}

//transforms DNA sequence into a float
-(float)numberFromDNASequence:(NSArray *)dnaSequence{
    float returnNumber = 0;
    
    if (!dnaSequence) {
        return 0;
    }
    
    for (int position = 0; position <= 11; position++) {
        //for each gene in DNA position
        
        float floatPosition = (float)position;
        
        NSNumber *geneNumber = dnaSequence[position];
        
        //if gene is equal 1, sums 1/2 ^ position of the number
        returnNumber+= pow(2, -(floatPosition + 1)) * [geneNumber intValue];
        
        //returnNumber = floatPosition / 10;
    }
    
    return returnNumber;
}

#pragma mark - Best values

-(NSArray *)changeDNAForBestSequence:(NSArray *)dnaSequence {
    float actualNumber = [self numberFromDNASequence:self.bestDNA];
    float tryNumber = [self numberFromDNASequence:dnaSequence];
    
    actualNumber = [self functionForExercise:actualNumber];
    tryNumber = [self functionForExercise:tryNumber];
    
    if (tryNumber > actualNumber){
        self.triesAfterGetBestDNA = 0;
        return dnaSequence;
    }
    return self.bestDNA;
}

#pragma mark - Function for exercise

-(float)functionForExercise:(float)initialValue{
    float part1 = (initialValue - 0.1) / 0.9;
    float part2 = powf(part1, 2);
    float part25 = -2*part2;
    float part3 = powf(2, part25);
    
    float part4 = powf(sin(5 * 3.14 * initialValue), 6);
    return part3 * part4;
    //return powf(2, powf(-2*(initialValue - 0.1) / (0.9), 2)) * sin(5*3.14*initialValue);
    
}

-(float)mediumNumberInArray:(NSArray *)array{
    float returnValue = 0;
    
    for (NSNumber *number in array) {
        returnValue += [number floatValue];
    }
    
    return returnValue/[array count];
}

@end
