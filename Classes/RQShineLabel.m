//
//  TSTextShineView.m
//  TextShine
//
//  Created by Genki on 5/7/14.
//  Copyright (c) 2014 Reteq. All rights reserved.
//

#import "RQShineLabel.h"

@interface RQShineLabel()

@property (strong, nonatomic) NSMutableAttributedString *attributedString;
@property (nonatomic, strong) NSMutableArray *characterAnimationDurations;
@property (nonatomic, strong) NSMutableArray *characterAnimationDelays;
@property (strong, nonatomic) CADisplayLink *displaylink;
@property (assign, nonatomic) CFTimeInterval beginTime;
@property (assign, nonatomic, getter = isReversed) BOOL reversed;
@property (nonatomic, copy) void (^completion)();

@end

@implementation RQShineLabel

- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
  
  [self commonInit];
  
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (!self) {
    return nil;
  }
  
  [self commonInit];
  
  return self;
}

- (void)commonInit
{
  // Defaults
  _shineDuration   = 2.5;
  _fadeoutDuration = 2.5;
  _autoStart       = NO;
  _reversed        = NO;
  self.textColor  = [UIColor whiteColor];
  
  _characterAnimationDurations = [NSMutableArray array];
  _characterAnimationDelays    = [NSMutableArray array];
}

- (void)didMoveToWindow
{
  if (nil != self.window && self.autoStart) {
    [self shine];
  }
}

- (void)setText:(NSString *)text
{
  [super setText:text];
  for (NSUInteger i = 0; i < text.length; i++) {
    self.characterAnimationDelays[i] = @(arc4random_uniform(self.shineDuration / 2 * 100) / 100.0);
    CGFloat remain = self.shineDuration - [self.characterAnimationDelays[i] floatValue];
    self.characterAnimationDurations[i] = @(arc4random_uniform(remain * 100) / 100.0);
  }
}

- (BOOL)isShining
{
  return nil != self.displaylink;
}

- (BOOL)isVisible
{
  return NO == self.isReversed;
}

- (void)shine
{
  if (!self.isShining) {
    self.attributedString = [[self randomlyFadedAttributedStringFromString:self.text] mutableCopy];
    self.attributedText = self.attributedString;
    self.reversed = NO;
    [self startAnimation];
  }
}

- (void)shineWithCompletion:(void (^)())completion
{
  self.completion = completion;
  [self shine];
}

- (void)fadeOut
{
  [self fadeOutWithCompletion:NULL];
}

- (void)fadeOutWithCompletion:(void (^)())completion
{
  self.completion = completion;
  self.reversed = YES;
  [self startAnimation];
}

- (void)startAnimation
{
  self.beginTime = CACurrentMediaTime();
  self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateAttributedString)];
  [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)updateAttributedString
{
  CFTimeInterval now = CACurrentMediaTime();
  for (NSUInteger i = 0; i < self.attributedString.length; i ++) {
    [self.attributedString enumerateAttribute:NSForegroundColorAttributeName
                                      inRange:NSMakeRange(i, 1)
                                      options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                   usingBlock:^(id value, NSRange range, BOOL *stop) {
                                     if ((now - self.beginTime) < [self.characterAnimationDelays[i] floatValue]) {
                                       return;
                                     }                                     
                                     CGFloat percentage = (now - self.beginTime - [self.characterAnimationDelays[i] floatValue]) / ( [self.characterAnimationDurations[i] floatValue]);
                                     if (self.isReversed) {
                                       percentage = 1 - percentage;
                                     }
                                     UIColor *color = [self.textColor colorWithAlphaComponent:percentage];
                                     [self.attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
                                   }];
    
    self.attributedText = self.attributedString;
    if (CACurrentMediaTime() > self.beginTime + self.shineDuration) {
      [self.displaylink invalidate];
      self.displaylink = nil;
      if (self.completion) {
        self.completion();
        self.completion = NULL;
      }
    }
  }
}



- (NSAttributedString *)randomlyFadedAttributedStringFromString:(NSString *)string
{
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
  UIColor *color = [self.textColor colorWithAlphaComponent:0];
  [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];
  return [attributedString copy];
}


@end
