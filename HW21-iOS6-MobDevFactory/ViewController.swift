//
//  ViewController.swift
//  HW21-iOS6-MobDevFactory
//
//  Created by Борис Киселев on 13.07.2022.
//

import UIKit

class ViewController: UIViewController {
  
    var password: String = ""
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBAction func generatePass(_ sender: Any) {
        password = String(String().lowercase.randomElement()!) + String(String().digits.randomElement()!) + String(String().uppercase.randomElement()!) + String(String().punctuation.randomElement()!)
        
        activityIndicator.isHidden = true
        textField.isSecureTextEntry = true
        textField.text = password
        print(password)
        
    }
    
    let queue = DispatchQueue(label: "myQueue", qos: .default)
    
    @IBAction func serachPass(_ sender: Any) {
        activityIndicator.isHidden = false
        queue.async { [self] in
            self.bruteForce(passwordToUnlock: self.password)
            firstLabel.text = password
            textField.isSecureTextEntry = false
        }
        
       
       
        
        
    }
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        firstLabel.text = "Fuck"
        activityIndicator.isHidden = true
        
//        self.bruteForce(passwordToUnlock: "1!gr")
        
        // Do any additional setup after loading the view.
    }
    
    func bruteForce(passwordToUnlock: String) {
        
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
//             Your stuff here
            
            DispatchQueue.main.async { [self] in
                firstLabel.text = password
            }
            
            print(password)
            // Your stuff here
        }
        
        print(password)
    }
}



extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }

    return str
}


