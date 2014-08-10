//
//  UIRedialController.m
//  UIVoice
//
//  Created by  on 12-9-8.
//  Copyright (c) 2012年 coson. All rights reserved.
//

#import "UIRedialController.h"
#import "AppDelegate.h"
@implementation UIRedialController

@synthesize portrait;
@synthesize name;
@synthesize status;

@synthesize btnRedial;
@synthesize btnCancel;
@synthesize btnGSMCall;

@synthesize username;
@synthesize callStatus;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rcScreen = self.view.frame;
    UIImageView *imgBkView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,rcScreen.size.width,rcScreen.size.height)];
    UIImage *pbg = [UIImage imageNamed:@"incalling_background.png"];
    pbg = [pbg getSubImage:CGRectMake(0, 20,rcScreen.size.width,rcScreen.size.height+20)]; 
	[imgBkView setImage:pbg];
	[self.view addSubview:imgBkView];
	[imgBkView release];
    
    //portarit
    UIImage *img = [UIImage imageNamed:@"6_portrait.png"];
	self.portrait = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, img.size.width, img.size.height)] autorelease];
	[self.portrait setImage:img];
	[self.view addSubview:self.portrait];
    
    //name
    self.name = [[[UILabel alloc] initWithFrame:CGRectMake(83, 17, 180, 30)] autorelease];
    self.name.text = self.username;
    self.name.numberOfLines = 0;
	self.name.lineBreakMode = UILineBreakModeWordWrap;
	[self.name setBackgroundColor:[UIColor clearColor]];
	[self.name setTextColor:[UIColor whiteColor]];
	self.name.font = [UIFont systemFontOfSize:24];
	[self.view addSubview:self.name];
    
    //time
    self.status = [[[UILabel alloc] initWithFrame:CGRectMake(83, 51, 150, 20)] autorelease];
    self.status.text = self.callStatus;
    self.status.numberOfLines = 0;
	self.status.lineBreakMode = UILineBreakModeWordWrap;
	[self.status setBackgroundColor:[UIColor clearColor]];
	[self.status setTextColor:[UIColor whiteColor]];
	self.status.font = [UIFont systemFontOfSize:15];
	[self.view addSubview:self.status];
    
    //redail
    CGSize  picSize;
    CGFloat y_offset = 300;
    CGFloat x_offset = 17;
    
    self.btnRedial = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *buttonBackground = [UIImage imageNamed:@"6_redial_normal.png"];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"6_redial_highlight.png"];
    picSize = buttonBackground.size;
    
    [self.btnRedial setFrame:CGRectMake(x_offset, y_offset, picSize.width, picSize.height)];
//    self.btnRedial.backgroundColor = [UIColor clearColor];
//	self.btnRedial.titleLabel.font = [UIFont systemFontOfSize:28];
//    [self.btnRedial setTitle:@"mute"/*NSLocalizedString(@"vedioCall",@"视频呼叫")*/ forState:UIControlStateNormal];	
	[self.btnRedial setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
    //	UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
	[self.btnRedial setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    //	UIImage *newPressedImage = [buttonBackgroundPressed stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
	[self.btnRedial setBackgroundImage:buttonBackgroundPressed forState:UIControlStateHighlighted];
	[self.btnRedial addTarget:self action:@selector(onRedial:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.btnRedial];    
    x_offset += picSize.width+18;
    
    //Cancel
    self.btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
	UIImage *buttonBackground2 = [UIImage imageNamed:@"6_cancel_normal.png"];
	UIImage *buttonBackgroundPressed2 = [UIImage imageNamed:@"6_cancel_highlight.png"];
    picSize = buttonBackground2.size;
    
    [self.btnCancel setFrame:CGRectMake(x_offset, y_offset, picSize.width, picSize.height)];
    self.btnCancel.backgroundColor = [UIColor clearColor];
//	self.btnCancel.titleLabel.font = [UIFont systemFontOfSize:28];
//    [self.btnCancel setTitle:@"mute"/*NSLocalizedString(@"vedioCall",@"视频呼叫")*/ forState:UIControlStateNormal];	
//	[self.btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
    //	UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
	[self.btnCancel setBackgroundImage:buttonBackground2 forState:UIControlStateNormal];
    //	UIImage *newPressedImage = [buttonBackgroundPressed stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
	[self.btnCancel setBackgroundImage:buttonBackgroundPressed2 forState:UIControlStateHighlighted];
	[self.btnCancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.btnCancel];    
    y_offset += picSize.height+39;
    x_offset = 17;
   

    self.btnGSMCall = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonBackground3 = [UIImage imageNamed:@"6_to_gsm_normal.png"];
	UIImage *buttonBackgroundPressed3 = [UIImage imageNamed:@"6_to_gsm_highlight.png"];
    picSize = buttonBackground3.size;
    
    [self.btnGSMCall setFrame:CGRectMake(x_offset, y_offset, picSize.width, picSize.height)];
//    self.btnGSMCall.backgroundColor = [UIColor clearColor];
//	self.btnGSMCall.titleLabel.font = [UIFont systemFontOfSize:28];
	[self.btnGSMCall setBackgroundImage:buttonBackground3 forState:UIControlStateNormal];
    //	UIImage *newPressedImage = [buttonBackgroundPressed stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
	[self.btnGSMCall setBackgroundImage:buttonBackgroundPressed3 forState:UIControlStateHighlighted];
    //	[self.btnMobilePhone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.btnGSMCall addTarget:self action:@selector(onGSMCall:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.btnGSMCall];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)onRedial:(id)sender
{
    NSLog(@"onRedial");
}

-(void)onCancel:(id)sender
{
    NSLog(@"onCancel");
}

-(void)onGSMCall:(id)sender
{
    NSLog(@"onGSMCall");
}

-(void)dealloc
{
    self.portrait=nil;
    self.name = nil;
    self.status = nil;
    
    self.btnRedial = nil;
    self.btnCancel = nil;
    self.btnGSMCall =nil;
    
    self.username = nil;
    self.callStatus = nil;
    
    [super dealloc];
}

@end
