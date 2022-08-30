import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var msgs: [Message] = []
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.msgs = []
                
                if let e = error {
                    print("Error retrieving data from Firestore \(e)")
                } else {
                    if let snapshotDocs = querySnapshot?.documents {
                        for doc in snapshotDocs {
                            let data = doc.data()
                            if let sender = data[Constants.FStore.senderField] as? String, let msg = data[Constants.FStore.bodyField] as? String {
                                
                                self.msgs.append(
                                    Message(sender: sender, body: msg)
                                )
                                
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    let ipath = IndexPath(row: self.msgs.count - 1, section: 0)
                                    
                                    self.tableView.scrollToRow(
                                        at: ipath,
                                        at: .top,
                                        animated: true)
                                }
                            } else {
                                print("Casting failed")
                            }
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let body = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(
                data: [
                    Constants.FStore.senderField: sender,
                    Constants.FStore.bodyField: body,
                    Constants.FStore.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error {
                        print("Error receive \(e)")
                    } else {
                        print("Data was saved")
                    }
                }
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let m = msgs[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = m.body
        
        cell.leftImageView.isHidden = true
        cell.rightImageView.isHidden = true
        
        if m.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
        } else {
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
        }
        
        return cell
    }
}
