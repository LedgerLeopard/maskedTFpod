//
//  ViewController.swift
//  maskedTextField
//
//  Created by iuriigushchin on 09/20/2018.
//  Copyright (c) 2018 iuriigushchin. All rights reserved.
//

import UIKit
import maskedTextField

class ViewController: UIViewController {

    @objc var TextFieldOne = UITextField()
    var delegateOne: MaskedTextFieldDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        let textFieldFrame = CGRect(x: 110, y: 150, width: 200, height: 31)
        TextFieldOne = UITextField(frame: textFieldFrame)
        TextFieldOne.borderStyle = UITextBorderStyle.roundedRect
        TextFieldOne.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        TextFieldOne.placeholder = "Введите значение"
        view.addSubview(self.TextFieldOne)
        
        delegateOne = MaskedTextFieldDelegate(TextFieldOne, "[____]{A}[-]/[999]", "")
        TextFieldOne.delegate = delegateOne
        
        delegateOne.resultCallback = { maskedValue, clearValue in
            print("masked value: \(maskedValue), clear value: \(clearValue)")
        }
        
        delegateOne.focusReceivedCallback = { [ unowned self ]  focused in
            if focused {
                self.TextFieldOne.layer.borderWidth = 1
                self.TextFieldOne.layer.borderColor = UIColor.red.cgColor
            } else {
                self.TextFieldOne.layer.borderWidth = 0
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

