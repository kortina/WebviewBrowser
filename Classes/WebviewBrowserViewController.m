//
//  WebviewBrowserViewController.m
//  WebviewBrowser
//
//  Forked by Kortina from: http://www.icodeblog.com/2008/12/19/iphone-coding-learning-about-uiwebviews-by-creating-a-web-browser/
//  by Brandon Trebitowski on 12/19/08.
//  
//  For use with this python testing server: https://github.com/kortina/bakpak/blob/master/python/cachetest.py

#import "WebviewBrowserViewController.h"
#import "SDURLCache.h"

@implementation WebviewBrowserViewController

@synthesize webView, webViewHidden, addressBar, activityIndicator;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL *url;
    NSString *urlAddress;
    NSString *html5Mode = @"HTML5" ;
    NSString *sdnMode = @"SDN";
    
    // which mode do you want to test?
    NSString *testmode = html5Mode;
    
    if (testmode == html5Mode) {
        NSString *cacheVersionNum = @"";
        
        urlAddress = [NSString stringWithFormat:@"http://ec2-50-19-29-73.compute-1.amazonaws.com/cm%@", cacheVersionNum];
        url = [NSURL URLWithString:urlAddress];
        
        // use hidden webview to warm the cache
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        self.webViewHidden = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
        [self.webViewHidden loadRequest:requestObj];
        
    } else {
        SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
                                                             diskCapacity:1024*1024*5 // 5MB disk cache
                                                                 diskPath:[SDURLCache defaultCachePath]];
        [NSURLCache setSharedURLCache:urlCache];
        [urlCache release];
        
        NSString *cacheVersionNum = @"7";
        
        urlAddress = [NSString stringWithFormat:@"http://ec2-50-19-29-73.compute-1.amazonaws.com/pr%@", cacheVersionNum];
        url = [NSURL URLWithString:urlAddress];
        
        NSString *jsAddress = [NSString stringWithFormat:@"http://ec2-50-19-29-73.compute-1.amazonaws.com/cached%@.js", cacheVersionNum];
        NSURL *jsUrl = [NSURL URLWithString:jsAddress];

        // use hidden webview to warm the cache
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        self.webViewHidden = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
        [self.webViewHidden loadRequest:requestObj];

        
        // see if cache is warm for HTML
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:requestObj];
        NSLog(@"cached HTML response from hidden: %@", cachedResponse);
        
        // see if cache is warm for JS that was inline loaded in HTML
        NSURLRequest *jsReq = [NSURLRequest requestWithURL:jsUrl];
        cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:jsReq];
        NSLog(@"cached JS response from hidden: %@", cachedResponse);
    }
    
    // load acutal request in actual webview
    NSURLRequest *requestObj2 = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj2];
    
    // display URL in address bar
	[addressBar setText:urlAddress];
	
    
    
}

-(IBAction)gotoAddress:(id) sender {
	NSURL *url = [NSURL URLWithString:[addressBar text]];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[webView loadRequest:requestObj];
	[addressBar resignFirstResponder];
}

-(IBAction) goBack:(id)sender {
	[webView goBack];
}

-(IBAction) goForward:(id)sender {
	[webView goForward];
}

-(IBAction) refresh:(id)sender {
	[webView reload];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	//CAPTURE USER LINK-CLICK.
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *URL = [request URL];	
		if ([[URL scheme] isEqualToString:@"http"]) {
			[addressBar setText:[URL absoluteString]];
			[self gotoAddress:nil];
		}	 
		return NO;
	}	
	return YES;   
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[activityIndicator stopAnimating];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}

@end
