//
//  ViewController.swift
//  Flashcards
//
//  Created by Victor Hernandez on 2/19/21.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extra_answer1: String
    var extra_answer2: String
}

class ViewController: UIViewController {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    
    var flashcards = [Flashcard]()
    
    var currentIndex = 0
    
    //comment.....
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        readSavedFlashcards()
        answerLabel.isHidden = true
        //card layout
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.5
        //question and answer card layout
        questionLabel.layer.cornerRadius = 20.0
        answerLabel.layer.cornerRadius = 20.0
        questionLabel.clipsToBounds = true
        answerLabel.clipsToBounds = true
        questionLabel.backgroundColor = UIColor .white
        // button one layout
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        //button two layout
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        //button three layout
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        if flashcards.count == 0{
        updateFlashCard(question: "Who won the 2018 world cup?", answer: "Croatia", extraAnswerOne: "France", extraAnswerTwo: "Argentina", isExisting: false)
        } else{
            updateLabelsButtons()
            updateNextPrevButtons()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        card.alpha = 0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionOne.alpha = 0
        btnOptionTwo.alpha = 0
        btnOptionThree.alpha = 0
        btnOptionOne.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionTwo.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionThree.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1
            self.btnOptionOne.alpha = 1
            self.btnOptionTwo.alpha = 1
            self.btnOptionThree.alpha = 1
            self.card.transform = CGAffineTransform.identity
            self.btnOptionOne.transform = CGAffineTransform.identity
            self.btnOptionTwo.transform = CGAffineTransform.identity
            self.btnOptionThree.transform = CGAffineTransform.identity
        })
        
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        if answerLabel.isHidden == true{
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
                self.questionLabel.isHidden = true
                self.answerLabel.isHidden = false
            }
        } else{
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
                self.answerLabel.isHidden = true
                self.questionLabel.isHidden = false
            }
        }
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        answerLabel.isHidden = false
        questionLabel.isHidden = true
    }
    
    @IBAction func didTapThirdOption(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
    
    func animateCardOutNext(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: {
            finish in
            self.animateCardInNext()
            self.updateLabelsButtons()
        })

    }
    
    func animateCardInNext(){
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func animatedCardOutPrev(){
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }, completion: {
            finish in
            self.animatedCardInPrev()
            self.updateLabelsButtons()
        })
    }
    
    func animatedCardInPrev(){
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapNext(_ sender: Any) {
        //add 1 to the current index
        currentIndex = currentIndex + 1
        //update the labels and buttons
        //update the buttons
        updateNextPrevButtons()
        resetLabelsButtons()
        animateCardOutNext()
    }
    
    @IBAction func didTapPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateNextPrevButtons()
        resetLabelsButtons()
        animatedCardOutPrev()
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func deleteCurrentFlashcard(){
        flashcards.remove(at: currentIndex)
        if currentIndex > flashcards.count - 1{
            currentIndex = flashcards.count - 1
        }
        updateLabelsButtons()
        updateNextPrevButtons()
        saveAllFlashcardsToDisk()
    }
    
    
    func updateLabelsButtons(){
        let currentFlashcard = flashcards[currentIndex]
        questionLabel.text = currentFlashcard.question
        answerLabel.text = currentFlashcard.answer
        btnOptionOne.setTitle(currentFlashcard.extra_answer1, for: .normal)
        btnOptionTwo.setTitle(currentFlashcard.answer, for: .normal)
        btnOptionThree.setTitle(currentFlashcard.extra_answer2, for: .normal)
    }
    
    func updateNextPrevButtons(){
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        } else{
            nextButton.isEnabled = true
        }
        if currentIndex == 0{
            prevButton.isEnabled = false
        } else{
            prevButton.isEnabled = true
        }
    }
    
    func resetLabelsButtons(){
        btnOptionOne.isHidden = false
        btnOptionTwo.isHidden = false
        btnOptionThree.isHidden = false
        answerLabel.isHidden = true
        questionLabel.isHidden = false
    }
    
    func updateFlashCard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String, isExisting: Bool){
        //Write stuff here
        let flashcard = Flashcard(question: question, answer: answer, extra_answer1: extraAnswerOne, extra_answer2: extraAnswerTwo)
        
        //Adding Flashcards to the Flashcards array
        if isExisting{
            flashcards[currentIndex] = flashcard
        } else {
            flashcards.append(flashcard)
            currentIndex = flashcards.count - 1
        }
        
        //Making every multiple choice answer reappear if it was pressed
        
        resetLabelsButtons()
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        print("Our current index is \(currentIndex)")
        //update buttons
        updateNextPrevButtons()
        updateLabelsButtons()
        saveAllFlashcardsToDisk()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = questionLabel.text
            creationController.initialAnswer = answerLabel.text
            creationController.initialExtraAnswer1 = btnOptionOne.titleLabel!.text
            creationController.initialExtraAnswer2 = btnOptionThree.titleLabel!.text
        }
    }
    
    func saveAllFlashcardsToDisk(){
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer, "extraAnswer1": card.extra_answer1, "extraAnswer2": card.extra_answer2]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("Flashcards saved to disk")
    }
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map { (dictionary) -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extra_answer1: dictionary["extraAnswer1"]!, extra_answer2: dictionary["extraAnswer2"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }

}
