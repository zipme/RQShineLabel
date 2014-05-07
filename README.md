# RQShineLabel

A UILabel subclass that lets you animate text similar to  [Secret app](http://capptivate.co/?s=secret).

## Requirements

iOS >= 6.0

## Installation

RQShineLabel is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "RQShineLabel"

## Usage

```objc

-(void)viewDidLoad
{

  self.shineLabel = [[RQShineLabel alloc] initWithFrame:CGRectMake(16, 16, 298, 300)];

  self.shineLabel.numberOfLines = 0;

  self.shineLabel.text = @"some text";

  self.shineLabel.backgroundColor = [UIColor clearColor];

  [self.shineLabel sizeToFit];

  self.shineLabel.center = self.view.center;

  [self.view addSubview:self.shineLabel];

}

-(void)viewDidAppear:(BOOL)animated
{

  [super viewDidAppear:animated];

  [self.shineLabel shine];

}

```




## Author

zipme, genkiwow@gmail.com

## License

RQShineLabl is available under the MIT license. See the LICENSE file for more info.

