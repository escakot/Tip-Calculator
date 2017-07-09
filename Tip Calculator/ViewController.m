//
//  ViewController.m
//  Tip Calculator
//
//  Created by Errol Cheong on 2017-07-08.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "ViewController.h"

#define FIELD_PERCENT_TAG 1

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *billAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *tipPercentageTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (weak, nonatomic) IBOutlet UISlider *tipPercentageSlider;

@property (assign, nonatomic) CGPoint viewCenter;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.viewCenter = self.view.center;
    
    self.tipPercentageTextField.tag = FIELD_PERCENT_TAG;
    self.tipPercentageTextField.text = @"15%";
    self.tipPercentageTextField.delegate = self;
    self.billAmountTextField.delegate = self;
    
    self.tipPercentageSlider.minimumValue = 0;
    self.tipPercentageSlider.maximumValue = 100;
    self.tipPercentageSlider.value = 15;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushScreenUp) name:@"keyboardWillShow" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushScreenDown) name:@"keyboardWillDisappear" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)calculateTip:(UIButton *)sender {
    float bill = self.billAmountTextField.text.floatValue;
    float tipPercentage = self.tipPercentageTextField.text.floatValue / 100;
    float tipAmount = bill * tipPercentage;
    self.tipAmountLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    [self.view endEditing:YES];
}

- (IBAction)changeTipPercentage:(UISlider *)sender {
    NSInteger tipPercentage = sender.value;
    
    self.tipPercentageTextField.text = [NSString stringWithFormat:@"%lu%%",  tipPercentage];
    [self calculateTip:nil];
}

- (void)pushScreenUp{
    self.view.center = CGPointMake(self.viewCenter.x, self.viewCenter.y * 0.4);
    
}

- (void)pushScreenDown{
    self.view.center = self.viewCenter;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardWillShow" object:nil];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == FIELD_PERCENT_TAG){
        NSString *lastString = [textField.text substringFromIndex:[textField.text length]-1];
        NSLog(@"%@", lastString);
        if (![lastString isEqualToString:@"%"]){
            textField.text = [NSString stringWithFormat:@"%@%%", textField.text];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardWillDisappear" object:nil];
    [self calculateTip:nil];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self calculateTip:nil];
}


@end
