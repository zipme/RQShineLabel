# RQShineLabel

A UILabel subclass that lets you animate text similar to [Secret app](http://capptivate.co/?s=secret).

![image](https://raw.githubusercontent.com/zipme/RQShineLabel/master/Screenshots/rqshinelabel.gif)

## Installation

RQShineLabel is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "RQShineLabel"


## Usage

```objc
- (void)viewDidLoad
{
  self.shineLabel = [[RQShineLabel alloc] initWithFrame:CGRectMake(16, 16, 298, 300)];
  self.shineLabel.numberOfLines = 0;
  self.shineLabel.text = @"some text";
  self.shineLabel.backgroundColor = [UIColor clearColor];
  [self.shineLabel sizeToFit];
  self.shineLabel.center = self.view.center;
  [self.view addSubview:self.shineLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.shineLabel shine];
}
```

### Other methods

fade in with completion block
```objc
- (void)shineWithCompletion:(void (^)())completion;
```

fade out
```objc
- (void)fadeOut
```

fade out with completion block
```objc
- (void)fadeOutWithCompletion:(void (^)())completion;
```

## Requirements

iOS >= 6.0


## Author

gk

## License

RQShineLabel is available under the MIT license. See the LICENSE file for more info.

