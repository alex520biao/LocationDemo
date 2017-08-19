//
//  ONETTSPlayer.m
//  Pods
//
//  Created by Liushulong on 13/02/2017.
//
//

#import "ONETTSPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "NSUserDefaults+ONEExtends.h"

NSString * const kMarkTTSPlayerIsSafe = @"ONETTS_markTTSPlayerIsSafe";

BOOL ONESystemVersionEqualTo(NSString *version) {
    return ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame);
}

@interface ONETTSPlayer ()
@property (atomic, strong) AVSpeechSynthesizer* synthesizer;
@end

@implementation ONETTSPlayer{
    NSString* _voiceLange;
}

ARC_SYNTHESIZE_SINGLETON_FOR_CLASS(ONETTSPlayer);

- (instancetype)init {
    if (self = [super init]) {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _voiceLange = @"zh-CN";
    }
    return self;
}

+ (void)playTTS:(NSString *)aSoundText {
    [[ONETTSPlayer sharedInstance] playTTS:aSoundText inBackground:NO];
}
+ (void)playTTS:(NSString *)aSoundText inBackground:(BOOL)isplay{
    [[ONETTSPlayer sharedInstance] playTTS:aSoundText inBackground:isplay];
}

+ (void)stop {
    [[ONETTSPlayer sharedInstance] stop];
}


- (void)playTTS:(NSString *)ttsText inBackground:(BOOL)isplay{
    if (![[self class] isTTSPlayerSafe]) {
        return;
    }
    if (![ttsText isKindOfClass:[NSString class]]
        || ttsText.length <= 0
        || _voiceLange.length <= 0) {
        return;
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        if (!ONESystemVersionEqualTo(@"9.0") || !isplay) {
            return;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stop];
        [[self class] markTTSPlayerIsSafe:NO];
        if (isplay) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            
        }else{
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        }
        
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[ttsText copy]];
        if (!ONESystemVersionEqualTo(@"8.0")) {
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate*0.7;
        }else if (!ONESystemVersionEqualTo(@"9.0")) {
            utterance.rate = AVSpeechUtteranceDefaultSpeechRate*0.4;
        }
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:_voiceLange];
        utterance.voice = voice;
        [self.synthesizer speakUtterance:utterance];

    });
    
}

- (void)stop {
    @synchronized(self) {
        [[self class] markTTSPlayerIsSafe:YES];
        if (self.synthesizer.isSpeaking) {
            [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            return;
        }
    }
}

#pragma mark - 临时（TRICK）解决8.*系统的TTS Crash问题[http://alpha.intra.xiaojukeji.com/crash/detail?app_id=10001&msgid=5EF4F45D-485A-49FE-A058-76DA1421BF9F]

+ (void)markTTSPlayerIsSafe:(BOOL)aSafe {
    if (ONESystemVersionEqualTo(@"9.0")) {
        return;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [NSUserDefaults one_setObject:[NSNumber numberWithBool:aSafe] forKey:kMarkTTSPlayerIsSafe];
    
    if (!aSafe) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self markTTSPlayerIsSafe:YES];
        });
        
    }
}

+ (BOOL)isTTSPlayerSafe {
    if (ONESystemVersionEqualTo(@"9.0")) {
        return YES;
    }
    
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:kMarkTTSPlayerIsSafe];
    if (nil == value) {
        return YES;
    }
    return [value boolValue];
}



@end
