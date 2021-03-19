//
//  ViewController.swift
//  ChallengeProject7-9
//
//  Created by Shilpa Joy on 2021-03-18.
//

import UIKit

class ViewController: UIViewController {

    var answersLabel: UILabel!
    var scoreLabel: UILabel!
    var letterLablel : UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var usedLetters = [String]()
    var currentWord = ""
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
     
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: \(score)"
        view.addSubview(scoreLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 30)
        answersLabel.text = "?????"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        letterLablel = UILabel()
        letterLablel.translatesAutoresizingMaskIntoConstraints = false
        letterLablel.font = UIFont.systemFont(ofSize: 17)
        letterLablel.text = "letter"
        letterLablel.textAlignment = .right
        //letterLablel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(letterLablel)
        
        
        
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.borderWidth = 1
        buttonView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonView)
    
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -20),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor,constant: 30),
            answersLabel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),

            
            letterLablel.topAnchor.constraint(equalTo: answersLabel.bottomAnchor,constant: 20),
            letterLablel.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
        //letterLablel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor,constant: -100),

            
            buttonView.widthAnchor.constraint(equalToConstant: 350),
            buttonView.heightAnchor.constraint(equalToConstant: 300),
            
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //buttonView.topAnchor.constraint(equalTo: letterLablel.bottomAnchor, constant: 10),
            buttonView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -100),
    
        ])
        let width = 60
        let height = 60
        
        for row in 0..<5 {
            for col in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 34)
                //letterButton.setTitle(String(char), for: .normal)
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                buttonView.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
            
        }
        for i in 0 ..< letters.count {
            letterButtons[i].setTitle(letters[i], for: .normal)
        }
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    loadLevel()
  }
    
    @objc func letterTapped(_ sender: UIButton){
   
        var promptWord = ""
    
        guard let buttonTitle = sender.titleLabel?.text else { return }
        usedLetters.append(buttonTitle)
        
        for letter in currentWord {
    
            let strLetter = String(letter)
            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        print(promptWord)
        answersLabel.text = promptWord
        activatedButtons.append(sender)//Appends the button to the activatedButtons array
        sender.isHidden = true
        
        if promptWord == currentWord {
            
            score += 1
            promptWord = ""
            letterLablel.text = ""
            usedLetters.removeAll()
            
            let ac = UIAlertController(title: "Great !!", message: "You got it...Solve the next one", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            
            loadLevel()
            for btn in activatedButtons {
                btn.isHidden = false
            }
            activatedButtons.removeAll()
        }
    }
    
    func loadLevel(){
        
        
        if let fileURL = Bundle.main.url(forResource: "level", withExtension: "txt"){
            if let fileContent = try? String(contentsOf: fileURL){
                var word = fileContent.components(separatedBy: "\n").shuffled()
                guard let randonWord = word.randomElement() else { return }
                currentWord = randonWord
                letterLablel.text = "\(currentWord.count) letter word"
                print(currentWord)
                let attributedText = String(repeating: "?", count: currentWord.count)
                answersLabel.text = attributedText
                
            }
        }
    }        
}

