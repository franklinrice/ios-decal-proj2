//
//  ViewController.swift
//  Hangman
//
//  Created by Gene Yoo on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "-"]
    
    let confirmClosure: ((UIAlertAction!) -> Void)! = { action in
        let newhm = HangmanViewController()
        newhm.beginNewGame()
    }
    

    
    
    
    
    
    
    var hm = Hangman()
    
    @IBOutlet weak var newGame: UIButton!
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var unsuccessfulGuesses: UILabel!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.layer.cornerRadius = 15
        image.image = UIImage(named: "hangman1.gif")
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        
        

        unsuccessfulGuesses.text = ""
        
        hm.start()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        switch hm.incorrectGuesses.count {
        case 0:
            image.image = UIImage(named: "hangman1.gif")
        case 1:
            image.image = UIImage(named: "hangman2.gif")
        case 2:
            image.image = UIImage(named: "hangman3.gif")
        case 3:
            image.image = UIImage(named: "hangman4.gif")
        case 4:
            image.image = UIImage(named: "hangman5.gif")
        case 5:
            image.image = UIImage(named: "hangman6.gif")
        case 6:
            image.image = UIImage(named: "hangman7.gif")
        default:
            image.image = UIImage(named: "hangman1.gif")
        }
        
        word.text = hm.knownString
        unsuccessfulGuesses.text = ""
        for letter in hm.incorrectGuesses {
            let str: String = letter as! String
            unsuccessfulGuesses.text! += str
            unsuccessfulGuesses.text! += " "
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alphabet.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return alphabet[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //do I need this?
    }
    
    @IBAction func NewGameButtonPressed(sender: UIButton) {
        let newGameController = UIAlertController(title: "Begin a new Game?", message: "You will lose your current game.", preferredStyle: .Alert)
        
        let NGcancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // do nothing, return to game
        }
        let NGOKAction = UIAlertAction(title: "OK", style: .Default) { (Void) in
            self.beginNewGame()
        }
        
        newGameController.addAction(NGcancelAction)
        newGameController.addAction(NGOKAction)
        
        self.presentViewController(newGameController, animated: true, completion: nil)
    
    
    }
    
    @IBAction func guessButtonPressed(sender: UIButton) {
        if hm.canPlay == false {
            return
        }
        let youLoseController = UIAlertController(title: "You Lose", message: "Buddy has been hung :(", preferredStyle: .Alert)
        
        let YLAction = UIAlertAction(title: "okay :(", style: .Default) { (action) in
            //
        }
        
        let youWinController = UIAlertController(title: "You win!", message: "Congratulations!", preferredStyle: .Alert)
        
        let YWAction = UIAlertAction(title: "Yay! :)", style: .Default) { (action) in
            //
        }
        
        let winNewGameAction = UIAlertAction(title: "Start New Game", style: .Default) { (action) in
            self.beginNewGame()
        }
        let lossNewGameAction = UIAlertAction(title: "Start New Game", style: .Default) { (action) in
            self.beginNewGame()
        }
        
        youLoseController.addAction(YLAction)
        youLoseController.addAction(lossNewGameAction)
        youWinController.addAction(YWAction)
        youWinController.addAction(winNewGameAction)
        
        let letter = alphabet[picker.selectedRowInComponent(0)]
        hm.guessLetter(letter.uppercaseString)
        viewWillAppear(false)
        if hm.incorrectGuesses.count == 6 {
            hm.canPlay = false
            self.presentViewController(youLoseController, animated: false, completion: nil)
        }
        if (hm.knownString?.rangeOfString("_") == nil) {
            self.presentViewController(youWinController, animated: false, completion: nil)
        }
        
    }
    
    func beginNewGame() {
        self.hm = Hangman()
        self.hm.start()
        viewWillAppear(true)
    }
    
}

