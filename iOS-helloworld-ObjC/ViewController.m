//
//  ViewController.m
//  iOS-helloworld-ObjC
//
//  Created by James Grantham on 9/14/18.
//  Copyright © 2018 Navisens. All rights reserved.
//

/*
 * For complete documentation on Navisens SDK API
 * Please go to the following link:
 * https://github.com/navisens/NaviDocs/blob/master/API.iOS.md
 */

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *receiveMotionDnaTextField;
@property (weak, nonatomic) IBOutlet UITextView *receiveNetworkDataTextField;

@property (strong, nonatomic) NSMutableDictionary<NSString*, MotionDna*> *networkUsers;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber*> *networkUsersTimestamps;
@property (strong, nonatomic) MotionDnaSDK *motionDnaSDK;
-(void)receiveMotionDna:(MotionDna*)motionDna;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _networkUsers = [NSMutableDictionary dictionary];
    _networkUsersTimestamps = [NSMutableDictionary dictionary];
    [self startMotionDna];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MotionDna Callback Methods

//    This event receives the estimation results using a MotionDna object.
//    Check out the Getters section to learn how to read data out of this object.

- (void)receiveMotionDna:(MotionDna *)motionDna {
    Location *location = motionDna.location;
    NSString *motionString = motionDna.classifiers[@"motion"].prediction.label;
    
    NSString *motionDnaLocalString = [NSString stringWithFormat:@"Cartesian Coordinates (meters): \n(%.2f,%.2f,%.2f)",location.cartesian.x,location.cartesian.y,location.cartesian.z];
    NSString *motionDnaHeadingString = [NSString stringWithFormat:@"Current Heading: %.2f",location.global.heading];
    NSString *motionDnaGlobalString = [NSString stringWithFormat:@"Global Position: \n(Lat: %.6f, Lon: %.6f)",location.global.latitude,location.global.longitude];
    NSString *motionDnaMotionTypeString = [NSString stringWithFormat:@"Motion Type: %@",motionString];
    NSDictionary<NSString*,Classifier*> *classifiers = motionDna.classifiers;
    NSString *motionDnaPredictionsString = @"Predictions (BETA):\n";
    for (NSString *classifierKey in classifiers) {
        motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"Classifier: %@\n",classifierKey];
        Classifier *classifier = [classifiers objectForKey:classifierKey];
        
        motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"\tprediction: %@ confidence: %.2f\n",classifier.prediction.label,classifier.prediction.confidence];
        motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingString:@" stats:\n"];
        for (NSString *predictionLabel in classifier.statistics) {
            PredictionStats *predictionStats = [classifier.statistics objectForKey:predictionLabel];
            motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"\t%@\n",predictionLabel];
            motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"\t duration: %.2f\n",predictionStats.duration];
            motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingFormat:@"\t distance: %.2f\n",predictionStats.distance];
        }
        motionDnaPredictionsString = [motionDnaPredictionsString stringByAppendingString:@"\n"];
    }
    [motionDnaPredictionsString stringByAppendingFormat:@"\n%@",classifiers];
    NSString *motionDnaString = [NSString stringWithFormat:@"MotionDna Location:\n%@\n%@\n%@\n%@\n\n%@",motionDnaLocalString,
                                 motionDnaHeadingString,
                                 motionDnaGlobalString,
                                 motionDnaMotionTypeString,
                                 motionDnaPredictionsString];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_receiveMotionDnaTextField setText:motionDnaString];
    });
}

- (void)startMotionDna {
    _motionDnaSDK = [[MotionDnaSDK alloc] initWithDelegate:self];
    NSLog(@"SDK Version: %@",MotionDnaSDK.SDKVersion);
    //    This functions starts up the SDK. You must pass in a valid developer's key in order for
    //    the SDK to function. IF the key has expired or there are other errors, you may receive
    //    those errors through the reportError() callback route.
    [_motionDnaSDK startWithDeveloperKey:@"<--DEVELOPER-KEY-HERE-->"];
}

- (void)reportStatus:(MotionDnaSDKStatus)status message:(NSString *)message {
    switch (status) {
        case MotionDnaSDKStatusSensorTimingIssue:
            NSLog(@"Status: Sensor Timing %@", message);
            break;
        case MotionDnaSDKStatusAuthenticationFailure:
            NSLog(@"Status: Authentication Failed %@", message);
            break;
        case MotionDnaSDKStatusMissingSensor:
            NSLog(@"Status: Sensor Missing %@", message);
            break;
        case MotionDnaSDKStatusExpiredSDK:
            NSLog(@"Status: SDK Expired %@", message);
            break;
        case MotionDnaSDKStatusAuthenticationSuccess:
            NSLog(@"Status: Authentication Succeeded %@", message);
            break;
        case MotionDnaSDKStatusConfiguration:
            NSLog(@"Status: Configuration %@", message);
            break;
        default:
            NSLog(@"Status: Unknown %@", message);
    }
}

@end

