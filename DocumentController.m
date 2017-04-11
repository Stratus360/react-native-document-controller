#import "DocumentController.h"
#import "RCTBridge.h"

@implementation DocumentController

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(show:(NSDictionary *)args)
{
    NSURL *file = [NSURL fileURLWithPath:args[@"file"]];
    
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:file];
    self.documentController.delegate = self;
    
    UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    // On iPhone just passing bounds works fine.
    // On iPad however it will give warnings about broken constraints.
    // This calculates the bottom middle point in order to show the popup
    CGRect fromRect = CGRectMake(ctrl.view.bounds.size.width/2, ctrl.view.bounds.size.height, 0, 0);
    
    if (![self.documentController presentOpenInMenuFromRect:fromRect inView:ctrl.view animated:YES]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"There are no installed apps that can open this file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

@end
