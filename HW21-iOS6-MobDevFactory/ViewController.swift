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
        firstLabel.text = "What's the password?"
        print(password)
        
    }
    
    let queue = DispatchQueue(label: "myQueue", qos: .default)
    let activityQue = DispatchQueue(label: "activityQue", qos: .default)
    
    
    @IBAction func serachPass(_ sender: Any) {

        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
        }
        
        
        queue.async { [self] in
            self.bruteForce(passwordToUnlock: self.password)
            self.firstLabel.text = self.password
            self.textField.isSecureTextEntry = false
            self.activityIndicator.isHidden = true
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        firstLabel.text = "What's the password?"
        activityIndicator.isHidden = true

    }
    
    func bruteForce(passwordToUnlock: String) {

        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }

        var password: String = ""

       
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)

            
            print(password)
      
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


