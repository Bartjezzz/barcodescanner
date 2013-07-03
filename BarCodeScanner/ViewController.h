//
//  ViewController.h
//  BarCodeScanner
//
//  Created by Bart van den Berg on 03-07-13.
//  Copyright (c) 2013 Blue Giraffe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "TSMiniWebBrowser.h"

@interface ViewController : UIViewController <ZBarReaderDelegate,TSMiniWebBrowserDelegate>
{
    
}
- (IBAction)startScannerUp:(id)sender;

@property (retain, nonatomic) IBOutlet UIButton *startScanner;
@end
