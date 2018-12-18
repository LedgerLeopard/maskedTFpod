# MaskedTextField


[![Version](https://img.shields.io/cocoapods/v/maskedTextField.svg?style=flat)](https://cocoapods.org/pods/maskedTextField)
[![License](https://img.shields.io/cocoapods/l/maskedTextField.svg?style=flat)](https://cocoapods.org/pods/maskedTextField)
[![Platform](https://img.shields.io/cocoapods/p/maskedTextField.svg?style=flat)](https://cocoapods.org/pods/maskedTextField)



Delegate for UITextField to work with input mask. 


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
Description of input mask protocol represented below.

All symbols, which user should enter, must be bracketed with square **[]** brackets.
If symbols are not necesseary, but are needed in mask's callback, they should be surrounded by curly  **{}** brackets.
All symbols, which should be presented  **as is**, must be written in mask without any brackets.

There are 6 types of symbols, which you can use into square brackets:

* **'0'** - required number. Mask **[000]** requires to fill **777** for example

* **'9'** - optional number. Mask **[999]** offers to fill **777** for example

* **'A'** - required letter. Mask **[AAA]** requires to fill **abc** for example

* **'a'** - required letter. Mask **[aaa]** offers to fill **abc** for example

* **'_'** - required digit or letter. Mask **[00___]** offers to fill **78a3b** for example

* **'-'** - optional difit or letter. Mask **[00---]** offers to fill **78-6-** for example



## Examples
There are some examples, which could help you to understand this logic:
+ 7 ([000]) [000] - [0000] - this mask provides you to get 10-digit callback with numbers. Clear result could be between 0000000000 and 9999999999
  
![AltText](https://media.giphy.com/media/1wPDeANHRdnDBTTgYE/giphy.gif)

+ 7 ([000]) [000] - [9999] - this mask provides you to get 6,7,8,9 or 10-digit callback.
  Clear result could be between (00000, 999999999)
  
![AltText](https://media.giphy.com/media/wp0uyXpTnuf4VFAdmd/giphy.gif)

+ {7} ([000]) [000] - [9999] - this mask provides you to get 7,8,9,10 or 11-digit callback.
  Clear result could be between (7000000,79999999999).

![AltText](https://media.giphy.com/media/3eTRoLOkcZtMgu3xPt/giphy.gif)

+ (0000)/-(0000)/-(0000)/-(0000) - this mask provides you to get 16-digit callback with numbers.
  Clear result could be between 0000000000000000 and 9999999999999999.

![AltText](https://media.giphy.com/media/uVQbKcAkKe5XEr27Zy/giphy.gif)

+ [____]{A}[-] [999] - this mask provides you to get 5,6,7,8,9 or 10-digit callback.
  Result could be between aaaaA and }}}}A}99
  
![AltText](https://media.giphy.com/media/7TqHP0aURNNnSFesdQ/giphy.gif)





## Author

iuriigushchin, yurii.gushchin@ledgerleopard.com

6epreu, 6epreu@gmail.com


## License

maskedTextField is available under the MIT license. See the LICENSE file for more info.
