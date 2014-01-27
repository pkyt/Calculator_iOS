//
//  CalculatorViewController.m
//  Calculator_iOS2
//
//  Created by Pavlo Kytsmey on 1/27/14.
//  Copyright (c) 2014 Pavlo Kytsmey. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSString *previousOperation;
@property (nonatomic) int count;
@property (nonatomic) bool minusInFront;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize previousOperation;
@synthesize count;
@synthesize minusInFront;

- (CalculatorBrain *)brain{
    if(!_brain) _brain = [CalculatorBrain new];
    return _brain;
}

- (IBAction)buttonPressed:(UIButton *)sender {
    NSString *cr = [sender currentTitle];
    char c = [cr characterAtIndex:0];
    BOOL thisMinus = NO;
    if (!userIsInTheMiddleOfEnteringNumber){
        if (c == '-'){
            minusInFront = YES;
            thisMinus = YES;
            [self.brain pushChar:'('];
            [self.brain pushChar:'0'];
        }
        self.display.text = cr;
        userIsInTheMiddleOfEnteringNumber = YES;
    }else{
        self.display.text = [self.display.text stringByAppendingString:cr];
    }
    if (minusInFront&&(!thisMinus)){
        if ((c == '-')||(c == '+')||(c == '/')||(c == '*')||(c == '(')||(c == ')')){
            minusInFront = NO;
            [self.brain pushChar:')'];
        }
    }
    [self.brain pushChar:c];
}

- (IBAction)submitPressed:(UIButton *)sender{
    if (minusInFront){
        minusInFront = NO;
        [self.brain pushChar:')'];
    }
    NSString * message = [self.brain performOperation];
    if (![self.brain didWeWriteSthToCCode]){
        userIsInTheMiddleOfEnteringNumber = NO;
    }
    self.display.text = message;
    //NSLog(message);
}

- (IBAction)clearPressed:(UIButton*)sender {
    [self.brain clearExpr];
    self.display.text = @"0";
    userIsInTheMiddleOfEnteringNumber = NO;
}
@end

