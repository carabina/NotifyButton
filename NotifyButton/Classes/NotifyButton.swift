//
//  NotifyButton.swift
//  Notify
//
//  Created by Tony M Joseph on 01/12/16.
//  Copyright © 2016 com.qburst.test. All rights reserved.
//

import UIKit


 public protocol NotifyButtonDelegate: class {
    func didFinishTask(sender: String , button : NotifyButton)
}


public class NotifyButton: UIButton, UITextFieldDelegate {
    var  sendButton = UIButton()
    var  emailTextField = TextField()
    var buttonClicked : Bool = false
    open weak var delegate: NotifyButtonDelegate?
    var buttonColor = UIColor()
    var buttonFontSize = CGFloat()
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommon()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCommon()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupCommon()
    }
    
    func setupCommon() {
        // we should use old swift syntax for pass validation of podspec
        buttonColor = self.currentTitleColor
        buttonFontSize = (self.titleLabel?.font.pointSize)!
        addTarget(self, action: #selector(NotifyButton.touchUpInside(_:)), for: .touchUpInside)
        setTitle("Notify Me", for: UIControlState())
        setTitleColor(buttonColor, for: UIControlState.normal)
        self.backgroundColor = UIColor.white
        layer.cornerRadius  = bounds.midY
        contentEdgeInsets = UIEdgeInsets(top: 0,
                                         left: 0,
                                         bottom: 0,
                                         right: 0)
        

    }
    
    
    func touchUpInside(_ sender: NotifyButton) {
        if (!self.buttonClicked) {
            self.buttonClicked = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.frame.size.width += 100
                self.frame.origin.x -= 50
                self.setUpsendButton()
                self.setUpEmailTextField()
                
            }, completion:{(value:Bool) in
                self.addSubview(self.emailTextField)
                self.addSubview(self.sendButton)
                
                UIView.animate(withDuration: 0.1 ,
                               animations: {
                                self.sendButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                },
                               completion: { finish in
                                UIView.animate(withDuration: 0.2){
                                    self.sendButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                                }
                })
                
                
            })
        }
    }
    func sendButtonTapped() {
        self.delegate?.didFinishTask(sender: self.emailTextField.text! , button: self)
    }
    
    open func success() {
        self.isEnabled = false
        self.setTitle("Thank You!", for: UIControlState())
        self.setTitleColor(buttonColor.withAlphaComponent(0), for: UIControlState.normal)
            self.complete()


        
    }
    
    func complete() {
        UIView.animate(withDuration: 0.5, delay: 0 , animations: {
            self.sendButton.isHidden = true
            self.frame.size.width -= 100
            self.frame.origin.x += 50

            self.emailTextField.removeFromSuperview()
            self.sendButton.removeFromSuperview()
//            self.setTitle("Thank You!", for: UIControlState())
            self.setTitleColor(self.buttonColor.withAlphaComponent(1), for: UIControlState.normal)
            
            self.titleLabel?.font.withSize(0)
        },                       completion: { finish in
            self.titleLabel?.font.withSize(self.buttonFontSize)
            
        })
        
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        emailTextField.endEditing(true)
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        if (isValidEmail(testStr: self.emailTextField.text!)) {
            self.sendButton.isEnabled = true
            self.sendButton.setTitleColor(UIColor(white: 1, alpha : 1), for: UIControlState.normal)
        }
        else {
            self.sendButton.isEnabled = false
            self.sendButton.setTitleColor(UIColor(white: 1, alpha : 0.5), for: UIControlState.normal)
        }
    }
    
    
    func setUpsendButton()  {
        buttonColor = self.currentTitleColor
        self.sendButton  = UIButton(frame:CGRect(x :self.frame.size.width * 0.75 - 5, y :4,width : self.frame.size.width/4   ,height :self.frame.size.height-8))
        self.sendButton.layer.cornerRadius  = self.sendButton.bounds.midY
        self.sendButton.addTarget(self, action: #selector(NotifyButton.sendButtonTapped), for: .touchUpInside)
        self.sendButton.setTitle("Send", for: UIControlState())
        self.sendButton.setTitleColor(UIColor(white: 1, alpha : 0.5), for: UIControlState.normal)
        self.sendButton.backgroundColor = buttonColor
        self.sendButton.isEnabled = false
        
    }
    
    func setUpEmailTextField() {
        buttonColor = self.currentTitleColor
        self.emailTextField = TextField (frame:CGRect(x :10, y :0,width : self.sendButton.frame.minX - 10 ,height :self.frame.size.height))
        self.emailTextField.delegate = self
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string:"E-mail",
                                                                       attributes:[NSForegroundColorAttributeName: buttonColor])
        self.emailTextField.layer.cornerRadius = self.bounds.midY - 5
        self.emailTextField.backgroundColor = UIColor.white
        self.emailTextField.textColor = buttonColor
        
    }
    
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}


