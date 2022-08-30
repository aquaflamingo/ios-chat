import UIKit
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let pass = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                if let e = error {
                    print(error)
                } else {
                    self.performSegue(withIdentifier: Constants.registerSegue, sender: self)}
            }
        }
    }
    
}
