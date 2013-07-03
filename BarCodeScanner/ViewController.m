//
//  ViewController.m
//  BarCodeScanner
//
//  Created by Bart van den Berg on 03-07-13.
//  Copyright (c) 2013 Blue Giraffe. All rights reserved.
//

#import "ViewController.h"
#import "TSMiniWebBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    NSLog(@"Scan resultaat: %@",symbol.data);
    
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    
    [reader dismissViewControllerAnimated:YES
                             completion:^{
                                 [self openWebBrowser:symbol.data];
                             }];
    
}

-(void) openWebBrowser:(NSString*)withURL
{
    NSString *resultString =[NSString stringWithFormat:@"http://www.praxis.nl?id=%@",withURL];
    NSURL *resultURL = [NSURL URLWithString:resultString];
    TSMiniWebBrowser *webBrowser = [[TSMiniWebBrowser alloc] initWithUrl:resultURL];
    webBrowser.delegate = self;
    //    webBrowser.showURLStringOnActionSheetTitle = YES;
    //    webBrowser.showPageTitleOnTitleBar = YES;
        webBrowser.showActionButton = YES;
        webBrowser.showReloadButton = YES;
        [webBrowser setFixedTitleBarText:@"Praxis Producten"]; // This has priority over "showPageTitleOnTitleBar".
    webBrowser.mode = TSMiniWebBrowserModeModal;
    
    webBrowser.barStyle = UIBarStyleBlack;
    
    if (webBrowser.mode == TSMiniWebBrowserModeModal) {
        webBrowser.modalDismissButtonTitle = @"Terug";
        [self presentViewController:webBrowser animated:YES completion:nil];
        
    }
    else if(webBrowser.mode == TSMiniWebBrowserModeNavigation) {
        [self.navigationController pushViewController:webBrowser animated:YES];
    }
}

- (void)dealloc {
    [_startScanner release];
    [super dealloc];
}
- (IBAction)startScannerUp:(id)sender {
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    //reader.readerView.showsFPS = YES;
    reader.readerView.showsCrossHair = YES;
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController: reader animated: YES completion:nil];
    [reader release];
}
@end
