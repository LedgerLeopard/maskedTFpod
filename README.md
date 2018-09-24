# MaskedTextField


[![Version](https://img.shields.io/cocoapods/v/maskedTextField.svg?style=flat)](https://cocoapods.org/pods/maskedTextField)
[![License](https://img.shields.io/cocoapods/l/maskedTextField.svg?style=flat)](https://cocoapods.org/pods/maskedTextField)
[![Platform](https://img.shields.io/cocoapods/p/maskedTextField.svg?style=flat)](https://cocoapods.org/pods/maskedTextField)



Delegate for UITextField to simplify work with masks!


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Requirements


## Installing with CocoaPods

maskedTextField is available through [CocoaPods](https://cocoapods.org). 
To integrate **maskedTextField** into your **Xcode** project using **CocoaPods**, specify it in your **podfile**: 
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'maskedTextField'
end
```
And then run the following comand:
```ruby
pod install
```


## Masks logic
To work with this delegate you should set a mask for it. There are some logic, and your mask will worlk according to it. Here we go: 

All symbols, which user should enter, must be bracketed with square **[]** brackets.
If symbols are not necesseary to enter, but are needed in mask's callback, you should write it in the curly  **{}** brackets.
All symbols, which should be presented **only**, must be written in mask without any brackets.

There are 6 types of symbols, which you can use into square brackets:

* '0' - one number (necessary)

* '9' - one  number (not necessary)

* 'A' - ane letter (necessary)

* 'a' - one not letter (not necessary)

* '_' - one any character (necessary)

* '-' - one any character (not necessary)

What does "necessary/not necessary" flag means? - It means, that on the place of necessary character will be shown int your UITextField mask as "_" symbol. Not necessary symbols won't be shown.


## Examples
There are some examples, which could help you to understand this logic:
+ 7 ([000]) [000] - [0000] - this mask provides you to get 10-digit callback with numbers,
  which user will enter. Clear result could be between 0000000000 and 9999999999
  
![AltText](https://media.giphy.com/media/1wPDeANHRdnDBTTgYE/giphy.gif)

+ 7 ([000]) [000] - [9999] - this mask provides you to get 6,7,8,9 or 10-digit callback.
  Clear result could be between (00000, 999999999)
  
![AltText](https://media.giphy.com/media/wp0uyXpTnuf4VFAdmd/giphy.gif)

+ {7} ([000]) [000] - [9999] - this mask provides you to get 7,8,9,10 or 11-counted digit.
  Clear result could be between (7000000,79999999999).

![AltText](https://media.giphy.com/media/3eTRoLOkcZtMgu3xPt/giphy.gif)

+ (0000)/-(0000)/-(0000)/-(0000) - this mask provides you to get 16-digit callback with numbers.
  Clear result could be between 0000000000000000 and 9999999999999999.

![AltText](https://media.giphy.com/media/uVQbKcAkKe5XEr27Zy/giphy.gif)

+ [____]{A}[-] [999] - this mask provides you to get 5,6,7,8,9 or 10-digit callback.
  Result could be between aaaaA and }}}}A}99
  
![AltText](https://media.giphy.com/media/7TqHP0aURNNnSFesdQ/giphy.gif)





## Author

6epreu, iuriigushchin. yurii.gushchin@ledgerleopard.com

## License

maskedTextField is available under the MIT license. See the LICENSE file for more info.
