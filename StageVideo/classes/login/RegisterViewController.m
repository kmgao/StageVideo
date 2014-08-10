//
//  RegisterViewController.m
//  StageVideo
//
//  Created by kmgao on 14-5-16.
//  Copyright (c) 2014年 kmgao. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h" 
#import "ParserBridge.h" 

@interface RegisterViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UITextField  *txtUsrName;
    UITextField  *txtEmail;
    UITextField  *txtPassword;
    UITextField  *txtRetryPassword;
    UIImageView  *graybgView;
    UIImageView  *headImgView;
    UIActivityIndicatorView   *netAnimation;
    UITapGestureRecognizer    *tapGesure;
    UIImagePickerController   *imgPicker;
    
}

@property(nonatomic,strong) UIScrollView    *scView;

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
  
}

-(void)handleTouchGesture
{
    [txtUsrName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtRetryPassword resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

-(void)chooseHeaderImage:(int)type
{
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = type;
    [self presentViewController:imgPicker animated:YES completion:^{
        
    }];

}

-(void)clickHeaderImage
{
#if 0//TARGET_IPHONE_SIMULATOR
    [self chooseHeaderImage:UIImagePickerControllerSourceTypePhotoLibrary];
#else
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"info" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"photo library",@"take camera", nil];
    [actionSheet showInView:self.view];
    
#endif
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self chooseHeaderImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    else if(buttonIndex ==1)
    {
        [self chooseHeaderImage:UIImagePickerControllerSourceTypeCamera];
    }
    else if(buttonIndex == 2)
    {
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBgImageView:@"app_backgound.png"];
    
    UIImage *imgSignUp = [UIImage imageNamed:@"sign_Up.png"];
    UIImageView *imgSignUpView = [[UIImageView alloc] initWithImage:imgSignUp];
    imgSignUpView.frame = CGRectMake(kScale2x(254.5), kScale2x(64), kScale2x(125), kScale2x(41));
    [self.view addSubview:imgSignUpView];
    
    UIImage *graybg = [UIImage imageNamed:@"login_gray_bg.png"];
    graybgView = [[UIImageView alloc] initWithImage:graybg];
    graybgView.frame = CGRectMake(0,kScale2x(128),IPHONE_SCREEN_WIDTH, kScale2x(1010));
    [self.view addSubview:graybgView];
    
    self.scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScale2x(128), IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT - kScale2x(128))];
    self.scView.backgroundColor = [UIColor clearColor];
    self.scView.contentSize = CGSizeMake(IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT+106);
    self.scView.scrollEnabled = YES;
    self.scView.showsVerticalScrollIndicator  = NO;
    self.scView.delegate = self;
    
    [self.view addSubview:self.scView];
    
    UIImage *headImg = [UIImage imageNamed:@"regist_header_default.png"];
    headImgView = [[UIImageView alloc] initWithImage:headImg];
    headImgView.frame = CGRectMake(kScale2x(183),kScale2x(179)-kScale2x(128),kScale2x(274), kScale2x(274));
    headImgView.userInteractionEnabled = YES;
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = kScale2x(274)/2;
    tapGesure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderImage)];
    [headImgView addGestureRecognizer:tapGesure];
    
    [self.scView addSubview:headImgView];
    
    CGRect _frame = CGRectMake(kScale2x(0), kScale2x(500)-kScale2x(128), IPHONE_SCREEN_WIDTH, kScale2x(98));
    
    txtUsrName = [[UITextField alloc] initWithFrame:_frame];
    txtUsrName.background = [UIImage imageNamed:@"textField_bg.png"];
    txtUsrName.textAlignment = NSTextAlignmentCenter;
    txtUsrName.borderStyle = UITextBorderStyleNone;
    txtUsrName.returnKeyType = UIReturnKeyDone;
    txtUsrName.font = [UIFont systemFontOfSize:kNormalFontSize];
    txtUsrName.textColor = [UIColor grayColor];
    txtUsrName.placeholder = @"Username";
    txtUsrName.delegate = self;
    
    [self.scView addSubview:txtUsrName];
    
    _frame = CGRectMake(kScale2x(0), kScale2x(603)-kScale2x(128), IPHONE_SCREEN_WIDTH, kScale2x(98));
    
    txtEmail = [[UITextField alloc] initWithFrame:_frame];
    txtEmail.background = [UIImage imageNamed:@"textField_bg.png"];
    txtEmail.textAlignment = NSTextAlignmentCenter;
    txtEmail.borderStyle = UITextBorderStyleNone;
    txtEmail.returnKeyType = UIReturnKeyDone;
    txtEmail.font = [UIFont systemFontOfSize:kNormalFontSize];
    txtEmail.textColor = [UIColor grayColor];
    txtEmail.placeholder = @"Email Address";
    txtEmail.delegate = self;
    
    [self.scView addSubview:txtEmail];
    
    _frame = CGRectMake(kScale2x(0), kScale2x(706)-kScale2x(128), IPHONE_SCREEN_WIDTH, kScale2x(98));
    
    txtPassword = [[UITextField alloc] initWithFrame:_frame];
    txtPassword.background = [UIImage imageNamed:@"textField_bg.png"];
    txtPassword.textAlignment = NSTextAlignmentCenter;
    txtPassword.borderStyle = UITextBorderStyleNone;
    txtPassword.keyboardType = UIKeyboardTypeASCIICapable;
    txtPassword.returnKeyType = UIReturnKeyDone;
    txtPassword.secureTextEntry = YES;
    txtPassword.font = [UIFont systemFontOfSize:kNormalFontSize];
    txtPassword.textColor = [UIColor grayColor];
    txtPassword.placeholder = @"Password(At least 6 characters)";
    txtPassword.delegate = self;
    
    [self.scView addSubview:txtPassword];
    
    _frame = CGRectMake(kScale2x(0), kScale2x(809)-kScale2x(128), IPHONE_SCREEN_WIDTH, kScale2x(98));
    
    txtRetryPassword = [[UITextField alloc] initWithFrame:_frame];
    txtRetryPassword.background = [UIImage imageNamed:@"textField_bg.png"];
    txtRetryPassword.textAlignment = NSTextAlignmentCenter;
    txtRetryPassword.borderStyle = UITextBorderStyleNone;
    txtRetryPassword.keyboardType = UIKeyboardTypeASCIICapable;
    txtRetryPassword.returnKeyType = UIReturnKeyDone;
    txtRetryPassword.secureTextEntry = YES;
    txtRetryPassword.font = [UIFont systemFontOfSize:kNormalFontSize];
    txtRetryPassword.textColor = [UIColor grayColor];
    txtRetryPassword.placeholder = @"Retype Password";
    txtRetryPassword.delegate = self;
    
    [self.scView addSubview:txtRetryPassword];
    
    
    _frame = CGRectMake(kScale2x(0), kScale2x(912)-kScale2x(128), IPHONE_SCREEN_WIDTH, kScale2x(128));
    
    UIButton  *doButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doButton setBackgroundImage:[UIImage imageNamed:@"done_button.png"] forState:UIControlStateNormal];
    doButton.showsTouchWhenHighlighted = YES;
    [doButton setFrame:_frame];
    
    [doButton addTarget:self action:@selector(clickDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scView addSubview:doButton];
    
}

-(void)clickDoneButton:(id)sender
{
    if(txtUsrName.text == nil || [txtUsrName.text isEqualToString:@""]){
        [[UIPromptTools shareInstance] showAlertView:@"Error" content:@"please input your name~" okButton:@"OK" ancelButton:nil];
    }
    else if(txtUsrName.text.length > 15){
        [[UIPromptTools shareInstance] showAlertView:@"Error" content:@"the user name must be 6-15 character~" okButton:@"OK" ancelButton:nil];
    }
    else if(txtEmail.text == nil || [txtEmail.text isEqualToString:@""]){
        [[UIPromptTools shareInstance] showAlertView:@"Error" content:@"please input your email~" okButton:@"OK" ancelButton:nil];
    }
    else if([txtEmail.text rangeOfString:@"@"].length <= 0){
        [[UIPromptTools shareInstance] showAlertView:@"Error" content:@"invalid email~" okButton:@"OK" ancelButton:nil];
    }
    else if(txtPassword.text == nil || [txtPassword.text isEqualToString:@""]){
        [[UIPromptTools shareInstance] showAlertView:@"Error" content:@"password must be not Empty~" okButton:@"OK" ancelButton:nil];
    }
    else if(![txtPassword.text isEqualToString:txtRetryPassword.text]){
        [[UIPromptTools shareInstance] showAlertView:@"Error" content:@"twice password is not same~" okButton:@"OK" ancelButton:nil];
    }
    else if(txtPassword.text.length > 15 || txtPassword.text.length < 6){
        [[UIPromptTools shareInstance] showAlertView:@"Error" content:@"the password must be 6-16 character~" okButton:@"OK" ancelButton:nil];
    }
    else{
        [self sendUserRegistInformation];
    }
}


-(void)showNextViewControlller
{
    UIViewController *nextVC = [MainViewController createSlidViewController];
    [self.navigationController pushViewController:nextVC animated:YES];
}


-(void)sendUserRegistInformation
{
    [self startNetAnimation];
    
    NSString *user = txtUsrName.text;
    NSString *pws = txtPassword.text;
    NSString *email = txtEmail.text;
    
    [[ParserBridge shareParser] registeNewUser:user password:pws eMail:email andBlock:^(BOOL succeeded, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopNetAnimation];
            if(error != nil)
            {
                NSString *errInfo = [[error userInfo] objectForKey:@"error"];
                [[UIPromptTools shareInstance] showAlertView:@"Error" content:errInfo okButton:@"OK" ancelButton:nil];
            }
            else
            {
                [self showNextViewControlller];
            }
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startNetAnimation
{
    if(netAnimation == nil)
    {
        netAnimation = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        CGSize nsize =CGSizeMake(20, 20);
        CGSize nsize =netAnimation.frame.size;
        netAnimation.center = CGPointMake((IPHONE_SCREEN_WIDTH - nsize.width)/2, (IPHONE_SCREEN_HEIGHT - nsize.height)/2);
        
        [self.view addSubview:netAnimation];
    }
    [netAnimation startAnimating];
}

-(void)stopNetAnimation
{
    if(netAnimation != nil)
    {
        [netAnimation stopAnimating];
        [netAnimation removeFromSuperview];
        netAnimation = nil;
    }
}


#pragma mark--
#pragma UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickDoneButton:nil];
    return YES;
}

#pragma end


#pragma mark--
#pragma uiscrollviewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self handleTouchGesture];
}

#pragma mark --
#pragma  UIImagePickerControllerDelegate,UINavigationControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    headImgView.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare((CFStringRef)mediaType, (CFStringRef)@"public.image", 0) == kCFCompareEqualTo)
    {
        
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage)
        {
            imageToSave = editedImage;
        }
        else
        {
            imageToSave = originalImage;
        }
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        headImgView.image = imageToSave;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self saveHeaderImage2Disk];
            [self senderImgData2Parser];
        }];
    }
}

-(void)saveHeaderImage2Disk
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imgData = UIImageJPEGRepresentation(headImgView.image, 0.3);
        NSString *savePath = [UtileTool getAppDirPath];
        NSString  *saveName = [NSString stringWithFormat:kSaveHeaderImageName,savePath];
        BOOL ret =  [imgData writeToFile:saveName atomically:YES];
        if(ret == NO)
        {
            NSLog(@"save image faild >>>>>>>>>>>");
        }
    });
}

-(void)senderImgData2Parser
{//发送图片数据
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    
}

@end
