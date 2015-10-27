//
//  ViewController.swift
//  Hangman
//
//  Created by Gene Yoo on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    var guesses_left = 6
    var letters_array = [UIButton]()
    var word_list = HangmanWords()
    var answer = ""
    
    @IBAction func keyboard_btn(sender: UIButton) {
        sender.enabled = false
        sender.backgroundColor = UIColor.redColor()
        letters_array.append(sender)
        let letter : Character = Character(sender.titleLabel!.text!)
        
        if foundLetter(letter) {
            gameStatus()
        } else {
            guesses_left -= 1
            showBody()
            gameStatus()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var word_view: UIView!
    @IBAction func start_over(sender: UIButton) {
        startGame()
    }
    
    func startGame(){
        guesses_left = 6
        resetWord()
        setWordView()
        resetImage()
        if letters_array.count > 0{
            resetKeyboard()
        }
    }
    
    func resetWord(){
        answer = word_list.getRandomWord()
    }
    
    func resetImage(){
        img.image = UIImage(named: "hangman1.png")
    }
    
    func resetKeyboard(){
        for sender in letters_array{
            sender.enabled = true
            sender.backgroundColor = UIColor.whiteColor()
        }
        
        let count = letters_array.count
        for _ in 0...count-1{
            letters_array.removeLast()
        }
    }
    
    func setWordView() {
        for label in word_view.subviews {
            label.removeFromSuperview()
        }
        
        let numberOfLetters = answer.characters.count
        
       
        let totalWidth = word_view.bounds.width
        let availableSpaceForEachLetter = totalWidth / CGFloat(numberOfLetters)
        var xValue = word_view.bounds.origin.x
        for letter in answer.characters {
            let label = UILabel(frame: CGRectMake(xValue, word_view.bounds.origin.y, availableSpaceForEachLetter - 2, word_view.bounds.height))
            if letter != " " {
                label.text = "-"
            }
                
            label.textAlignment = NSTextAlignment.Center
            label.backgroundColor = UIColor.cyanColor()
            word_view.addSubview(label)
            xValue += availableSpaceForEachLetter
        }
    }
    
    func foundLetter(selectedLetter: Character) -> Bool {
        var found = false
        var index = 0
        for solutionLetter in answer.characters {
            if solutionLetter == selectedLetter {
                found = true
                let label = word_view.subviews[index] as!  UILabel
                label.text = (String(selectedLetter))
            }
            index++
        }
        return found
    }
    
    func showBody() {
        switch guesses_left {
        case 5:
            img.image = UIImage(named: "hangman2.png")
        case 4:
            img.image = UIImage(named: "hangman3.png")
        case 3:
            img.image = UIImage(named: "hangman4.png")
        case 2:
            img.image = UIImage(named: "hangman5.png")
        case 1:
            img.image = UIImage(named: "hangman6.png")
        case 0:
            img.image = UIImage(named: "hangman7.png")
        default:
            img.image = UIImage(named: "hangman1.png")

        }
        

    }
    
    func gameStatus() {
        var win = true
        
        if guesses_left == 0 {
            let msg: String = "Wah Wah!"
            alert("YOU LOST! Play again?", msgTitle: msg)
            self.showAnswer()
        }
        
        for label in word_view.subviews {
            let labelView = label as? UILabel
            if labelView!.text == "-" {
                win = false
            }
        }
        if win {
            let msg: String = "Congratulations!"
            alert("YOU WON! Play again?", msgTitle: msg)
        }
    }
    
    func showAnswer() {
        var index = 0
        for solutionLetter in answer.characters {
            let label = word_view.subviews[index] as!  UILabel
            label.text = (String(solutionLetter))
            index++
        }
    }
    
    func alert(msg: String, msgTitle: String) {
        
        let alertController = UIAlertController(title: msgTitle, message: msg, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
            
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.startGame()
        }
        alertController.addAction(OKAction)
            
        self.presentViewController(alertController, animated: true) {
        }
    }
}

