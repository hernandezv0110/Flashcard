//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Victor Hernandez on 3/6/21.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
        
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var answerOption1TextField: UITextField!
    @IBOutlet weak var answerOption2TextField: UITextField!
    
    
    
    var initialQuestion: String?
    var initialAnswer: String?
    var initialExtraAnswer1: String?
    var initialExtraAnswer2: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
        answerOption1TextField.text = initialExtraAnswer1
        answerOption2TextField.text = initialExtraAnswer2
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        let questionText = questionTextField.text
        let answerText = answerTextField.text
        let extraAnswer1Text = answerOption1TextField.text
        let extraAnswer2Text = answerOption2TextField.text
        
        let alert = UIAlertController(title: "Missing Text", message: "You Need to enter both a question and an answer", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        
        if questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty{
            present(alert, animated: true)
        } else {
            flashcardsController.updateFlashCard(question: questionText!, answer: answerText!, extraAnswerOne: extraAnswer1Text!, extraAnswerTwo: extraAnswer2Text!)
        
            dismiss(animated: true)
        }
    }
}
