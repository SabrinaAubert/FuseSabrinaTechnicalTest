//
//  ViewController.m
//  Fuse
//
//  Created by MobileDeveloper on 11/11/2015.
//  Copyright © 2015 BP. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@end
NSString *companyEntered;
NSDictionary *jsonObject;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //change text colour after the first search
    [self.homepagetextfield addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    
    
   
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    self.homepagetextfield.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"%@",textField.text);
    companyEntered = textField.text;
    
    
    if ([self textValidated:companyEntered]) {
        NSString *textWithoutSpace = [companyEntered stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *URLToCall = [self generateURL:textWithoutSpace];
        
        [self makeTheCall:URLToCall];
    }
    textField.resignFirstResponder;
    
    
    return YES;
}

- (void) makeTheCall: (NSString *)url{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                
                if ([httpResponse statusCode] == 200) {
                    
                    
                    
                    [self createModelOfResponse:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self changeText];
                        self.homepagetextfield.backgroundColor=[UIColor greenColor];
                                                  });
                   
                    
                }
                else{
                    NSLog(@"status code not 200");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.homepagetextfield.backgroundColor=[UIColor redColor];
                    });
                    
                    
                }
                
            }] resume];

}

-(void)changeText{
     self.homepagetextfield.text = [jsonObject objectForKey:@"name"];
}
-(void) createModelOfResponse: (NSData *)responseData{
    
    jsonObject=[NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingMutableLeaves
                              error:nil];
    NSLog(@"jsonObject is %@",jsonObject);

   

}
-(BOOL)textValidated:(NSString *)textEntered{
    if ([textEntered length]>=1) {
        
        return true;
    }
    else{
        NSLog(@"Empty textfield");
        return false;
    }
}

-(NSString *) generateURL: (NSString *)companyName{
    NSString *jsonURL = @".fusion-universal.com/api/v1/company.json";
    NSString *URLToCall = [@"https://" stringByAppendingString:[companyName stringByAppendingString:jsonURL]];
    
    return URLToCall;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
