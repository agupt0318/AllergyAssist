import UIKit

var greeting = "Hello, playground"
// https://www.youtube.com/watch?v=_U6_l58Cv4E
//  ViewController.swift
//  Allergy Without StoryBoard
//
//  Created by Colin Hu on 1/2/23.
//



import Vision
import UIKit

enum AType{
    case nut
}

enum ALevel {
    case easy
    case medium
    case hard
}

class Allergy_Elements {
    //class variable
    let type : AType
    let level : ALevel
    //constructor
    init(type: AType, level: ALevel) {
        self.type = type
        self.level = level
    }
    
    //method
    public func Launch_Alert(){
        print("Allergies contained in this product!")
    }
    
    public func getType() -> AType{
        return self.type
    }
}
//data base to store suspicious elements
var allergy_elements = [Allergy_Elements(type: AType.nut, level: ALevel.medium)]
let sample_db = ["123", "0", "public"]

enum Occupation {
    case student
    case proffesional
}

class Account{
    let name : String?
    let age : Int?
    var Occupation : Occupation?
    var Allergy_Categories : [Allergy_Elements]?
    
    
    init (name : String, age : Int, Allergy_Categories: [Allergy_Elements]){
        self.name = name
        self.age = age
        self.Allergy_Categories = Allergy_Categories
    }
    
    private func insert_EI(){
        for i in 0..<5{
            self.Allergy_Categories?.append(Allergy_Elements(type: AType.nut, level: ALevel.easy))
        }
    }
}

class ViewController: UIViewController {
    var count = 0;
    
    private let label: UILabel = {
         let label = UILabel()
         label.numberOfLines = 0
         label.textAlignment = .center
         label.text = "Allergy Assist"
         
         return label
     }()
    
    private let appName: UILabel = {
         let appName = UILabel()
         appName.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 48)
         appName.numberOfLines = 0
         appName.textAlignment = .center
         appName.textColor = UIColor.black
         appName.font = UIFont.boldSystemFont(ofSize: 30)
         appName.text = "Allergy Assist"
         
         return appName
     }()
     
     private let imageView: UIImageView = {
         let imageView = UIImageView()
         imageView.image = UIImage(named: "Cover")
         imageView.contentMode = .scaleAspectFit
         return imageView
     }()
     
     override func viewDidLoad(){
        super.viewDidLoad()
        //view.addSubview(label)
        view.addSubview(appName)
        view.addSubview(imageView)
        view.backgroundColor = UIColor.white
        view.addSubview(log_in)
        view.addSubview(scan_barcode)
        view.addSubview(scan_label)
         
        start()
        
        recognizeText(image: imageView.image)
         
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
             self.DA(mes: self.label.text!)
         }
    }
    
    private func start(){
        log_in.frame = CGRect(x : 125, y: 475, width: 150, height: 48 )
        //sign_in.addTarget(self, action: #selector (handle_B(sender: )), for: .touchUpInside)
        view.addSubview(log_in)
        scan_barcode.frame = CGRect(x : 125, y: 575, width: 150, height: 48 )
        view.addSubview(scan_barcode)
        scan_label.frame = CGRect(x : 125, y: 675, width: 150, height: 48 )
        view.addSubview(scan_label)
    }
    
    let log_in : UIButton = {
        let si = UIButton()
        si.setTitle("Log In", for: .normal)
        si.backgroundColor = UIColor.systemGreen
        si.layer.cornerRadius = 10
        si.addTarget(self, action: #selector(LogIn), for : .touchUpInside)
        return si
    }()
    
    let scan_barcode : UIButton = {
        let sb = UIButton()
        sb.setTitle("Scan Barcode", for: .normal)
        sb.backgroundColor = UIColor.systemOrange
        sb.layer.cornerRadius = 10
        sb.addTarget(self, action: #selector(Scan_Barcode), for : .touchUpInside)
        return sb
    }()
    
    let scan_label : UIButton = {
        let sl = UIButton()
        sl.setTitle("Scan Label", for: .normal)
        sl.backgroundColor = UIColor.systemOrange
        sl.layer.cornerRadius = 10
        sl.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        return sl
    }()
    
    @objc func LogIn(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = UserAccountInfo()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
    @objc func Scan_Label(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = ScanLabel()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
    @objc func Scan_Barcode(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = ScanBarcode()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
     override func viewDidLayoutSubviews(){
         super.viewDidLayoutSubviews()
         imageView.frame = CGRect (
            x: 20,
            y: view.safeAreaInsets.top+80,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40)
         label.frame = CGRect(x: 20,
                          y: view.frame.size.width + view.safeAreaInsets.top-120,
                              width: view.frame.size.width-40,
                              height: 600)
     }
     
     private func recognizeText(image: UIImage?) {
         guard let cgImage = image?.cgImage else {
             fatalError("could not get image")
     }
     
     //Handler
         let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
     //Request
         let request = VNRecognizeTextRequest { [weak self] request, error in
             guard let observations = request.results as? [VNRecognizedTextObservation],
                   error == nil else {
                 return
     }
     
             let text = observations.compactMap({
                 $0.topCandidates(1).first?.string
            }).joined(separator: " ,")
     
             DispatchQueue.main.async {
         self?.label.text = text
             }
         }
     //Process the Request
            do {
                try handler.perform([request])
            }
            catch{
                label.text = ("\(error)")
            }
        }
    
    
    
    //Data Analysis
    public func DA(mes : String) -> Bool{
            //var text1 = mes
            print(mes)
        //passing the raw data in form of string
        // convert the string into array and split the substring by special symbols such as , ; space...
        // "the food contains peanut, fruit, milk" -> ["the", "food", "contains", "peanut", "fruit", "milk"]
        let res : Bool = false;
        var cnt : Int = 0
        let arr = mes.split(separator: ", ")
        print(arr)
        var percentage_arr = [String]()
        return res;
        for item in arr {
            if item.contains("%") {
                percentage_arr.append(String(item))
            }
        }
        print(percentage_arr)
        for i in 0..<arr.count {
            let lb = UILabel()
            lb.numberOfLines = -1
            let size : CGFloat = CGFloat(arr[i].count * 18 + 10)
            let x : CGFloat = 10
            let y = CGFloat(i) * 20 + 300
            lb.frame = CGRect(x: x, y: y, width: size, height: 20)
            lb.backgroundColor = UIColor.black
            lb.clipsToBounds = true
            lb.layer.cornerRadius = 3
            lb.textColor = .white
            lb.font = UIFont.boldSystemFont(ofSize: 18)
            lb.text = String(arr[i])
            view.addSubview(lb)
        }
        /*for item in mes {
            for inner in sample_db{
                if item == Character(inner){
                    cnt += 1
                }
                
            }
        }*/
    }
}

class ScanLabel : UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        let textView = UITextView(frame: CGRect(x: 50, y: 525, width: 300, height: 225))
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.text = IngredientList.text
        view.addSubview(textView)
        //ImportImage.borderWidth = 1
        //ImportImage.borderColor = UIColor.black.cgColor
        view.addSubview(display_imageview)
        view.addSubview(AllergyAssist)
        PhotoIcon.frame = CGRect (
           x: 80,
           y: 125,
           width: 40,
           height: 40)
        view.addSubview(PhotoIcon)
        recognizeText(image: display_imageview.image)
        
        start3()
    }
    
    let User1 : UIButton = {
        let U1 = UIButton()
        U1.setTitle("User 1", for: .normal)
        U1.backgroundColor = UIColor.systemOrange
        U1.layer.cornerRadius = 10
        //U1.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        return U1
    }()
    
    let display_imageview : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.systemGray
        iv.isUserInteractionEnabled = true
            iv.image = UIImage(named : "example2") //iv.image = UIImage(named : "sample.png")
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    
    
    /*let ImportImage : UIButton = {
        let II = UIButton()
        //II.setTitle("Banana", for: .normal)
        II.backgroundColor = UIColor.systemGreen
        //II.layer.cornerRadius =
        //II.layer.borderColor = CGColor.systemBlue
        //II.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        
        return II
        
    }()*/
    
    let home_bt : UIButton = {
        let bt = UIButton()
        bt.setTitle("Home", for: .normal)
        bt.backgroundColor = UIColor.systemGray
        return bt
    }()
    
    @objc func h1(sender : UIButton){
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private func start3(){
        display_imageview.frame = CGRect(x : 50, y: 180, width: 300, height: 250 )
        view.addSubview(display_imageview)
        User1.frame = CGRect(x : 150, y: 500, width: 100, height: 50 )
        view.addSubview(display_imageview)
        AllergyAssist.frame = CGRect(x : 100, y: 50, width: 200, height: 36 )
        view.addSubview(AllergyAssist)
        ScanAnItem.frame = CGRect(x : 125, y: 120, width: 200, height: 50 )
        view.addSubview(ScanAnItem)
        ChooseUser.frame = CGRect(x : 150, y: 450, width: 100, height: 50 )
        view.addSubview(ChooseUser)
        IngredientList.frame = CGRect(x : 50, y: 525, width: 300, height: 225 )
        view.addSubview(IngredientList)
        home_bt.frame = CGRect(x: 150, y: 750, width: 100, height: 30)
        home_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
        view.addSubview(home_bt)
        
    }
    
    private let AllergyAssist: UILabel = {
         let allergyAssist = UILabel()
        allergyAssist.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        allergyAssist.numberOfLines = 0
        allergyAssist.textAlignment = .center
        allergyAssist.textColor = UIColor.black
        allergyAssist.font = UIFont.boldSystemFont(ofSize: 24)
        allergyAssist.text = "Allergy Assist"
        allergyAssist.backgroundColor = UIColor.white
        
         
         return allergyAssist
     }()
    
    private let ChooseUser: UILabel = {
         let chooseUser = UILabel()
        chooseUser.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        chooseUser.numberOfLines = 2
        chooseUser.textAlignment = .center
        chooseUser.textColor = UIColor.black
        chooseUser.font = UIFont.boldSystemFont(ofSize: 12)
        chooseUser.text = "Choose User To Scan"
        //chooseUser.cornerRadius = 10
        chooseUser.backgroundColor = UIColor.orange
        
         
         return chooseUser
     }()
    
    private let IngredientList: UITextView = {
        let iList = UITextView()
        //iList.numberOfLines = 12
        //iList.textAlignment = .center
        iList.textColor = UIColor.black
        iList.font = UIFont.boldSystemFont(ofSize: 12)
        iList.text = ""
        iList.isEditable = false
        iList.isUserInteractionEnabled = true
        //chooseUser.cornerRadius = 10
        iList.backgroundColor = UIColor.white
        iList.layer.borderWidth = 1
        iList.layer.borderColor = UIColor.black.cgColor
         
         return iList
     }()
    
    private let ScanAnItem: UILabel = {
         let SAI = UILabel()
        SAI.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        SAI.numberOfLines = 2
        SAI.textAlignment = .center
        SAI.textColor = UIColor.black
        SAI.font = UIFont.boldSystemFont(ofSize: 12)
        SAI.text = "Scan an item label to see if it is safe for you to eat"
        SAI.backgroundColor = UIColor.white
        
         
         return SAI
     }()
    
    private let PhotoIcon: UIImageView = {
        let photoIcon = UIImageView()
        photoIcon.image = UIImage(named: "PhotoIcon")
        photoIcon.contentMode = .scaleAspectFit
        return photoIcon
    }()
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
    }
    
    //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    //Request
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
    }
    
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
           }).joined(separator: " ,")
    
            DispatchQueue.main.async {
        self?.IngredientList.text = text
            }
        }
    //Process the Request
           do {
               try handler.perform([request])
           }
           catch{
               IngredientList.text = ("\(error)")
           }
        
       }
   
   
   
   //Data Analysis
   public func DA(mes : String) -> Bool{
           //var text1 = mes
           print(mes)
       //passing the raw data in form of string
       // convert the string into array and split the substring by special symbols such as , ; space...
       // "the food contains peanut, fruit, milk" -> ["the", "food", "contains", "peanut", "fruit", "milk"]
       let res : Bool = false;
       var cnt : Int = 0
       let arr = mes.split(separator: ", ")
       print(arr)
       var percentage_arr = [String]()
       return res;
       for item in arr {
           if item.contains("%") {
               percentage_arr.append(String(item))
           }
       }
       print(percentage_arr)
       for i in 0..<arr.count {
           let lb = UILabel()
           lb.numberOfLines = -1
           let size : CGFloat = CGFloat(arr[i].count * 18 + 10)
           let x : CGFloat = 10
           let y = CGFloat(i) * 20 + 300
           lb.frame = CGRect(x: x, y: y, width: size, height: 20)
           lb.backgroundColor = UIColor.black
           lb.clipsToBounds = true
           lb.layer.cornerRadius = 3
           lb.textColor = .white
           lb.font = UIFont.boldSystemFont(ofSize: 18)
           lb.text = String(arr[i])
           view.addSubview(lb)
       }
       /*for item in mes {
           for inner in sample_db{
               if item == Character(inner){
                   cnt += 1
               }
               
           }
       }*/
   }
}

class ScanBarcode : UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        //ImportImage.borderWidth = 1
        //ImportImage.borderColor = UIColor.black.cgColor
        view.addSubview(ImportImage)
        view.addSubview(AllergyAssist)
        PhotoIcon.frame = CGRect (
           x: 80,
           y: 125,
           width: 40,
           height: 40)
        view.addSubview(PhotoIcon)
        
        start3()
        
    }
    
    let ImportImage : UIButton = {
        let II = UIButton()
        //II.setTitle("Banana", for: .normal)
        II.backgroundColor = UIColor.systemGreen
        //II.layer.cornerRadius =
        //II.layer.borderColor = CGColor.systemBlue
        //II.addTarget(self, action: #selector(Scan_Label), for : .touchUpInside)
        
        return II
        
    }()
    
    private func start3(){
        ImportImage.frame = CGRect(x : 50, y: 180, width: 300, height: 250 )
        view.addSubview(ImportImage)
        AllergyAssist.frame = CGRect(x : 100, y: 50, width: 200, height: 36 )
        view.addSubview(AllergyAssist)
        ScanAnItem.frame = CGRect(x : 125, y: 115, width: 200, height: 50 )
        view.addSubview(ScanAnItem)
        ChooseUser.frame = CGRect(x : 150, y: 450, width: 100, height: 50 )
        view.addSubview(ChooseUser)
        
    }
    
    private let AllergyAssist: UILabel = {
         let allergyAssist = UILabel()
        allergyAssist.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        allergyAssist.numberOfLines = 0
        allergyAssist.textAlignment = .center
        allergyAssist.textColor = UIColor.black
        allergyAssist.font = UIFont.boldSystemFont(ofSize: 24)
        allergyAssist.text = "Allergy Assist"
        allergyAssist.backgroundColor = UIColor.white
        
         
         return allergyAssist
     }()
    
    private let ChooseUser: UILabel = {
         let chooseUser = UILabel()
        chooseUser.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        chooseUser.numberOfLines = 2
        chooseUser.textAlignment = .center
        chooseUser.textColor = UIColor.black
        chooseUser.font = UIFont.boldSystemFont(ofSize: 12)
        chooseUser.text = "Choose User To Scan"
        //chooseUser.cornerRadius = 10
        chooseUser.backgroundColor = UIColor.orange
        
         
         return chooseUser
     }()
    
    private let ScanAnItem: UILabel = {
         let SAI = UILabel()
        SAI.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        SAI.numberOfLines = 2
        SAI.textAlignment = .center
        SAI.textColor = UIColor.black
        SAI.font = UIFont.boldSystemFont(ofSize: 12)
        SAI.text = "Scan an item barcode to see if it is safe for you to eat"
        SAI.backgroundColor = UIColor.white
        
         
         return SAI
     }()
    
    private let PhotoIcon: UIImageView = {
        let photoIcon = UIImageView()
        photoIcon.image = UIImage(named: "PhotoIcon")
        photoIcon.contentMode = .scaleAspectFit
        return photoIcon
    }()
    
}



class UserAccountInfo : UIViewController{
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(AddUser)
        
        start2()
        
    }
    let AddUser : UIButton = {
        let AU = UIButton()
        AU.setTitle("Add User", for: .normal)
        AU.backgroundColor = UIColor.systemGreen
        AU.layer.cornerRadius = 10
        AU.addTarget(self, action: #selector(handle_C), for : .touchUpInside)
        
        return AU
        
    }()
    
    private func start2(){
        AddUser.frame = CGRect(x : 60, y: 60, width: 125, height: 36 )
        view.addSubview(AddUser)
        UserAccount.frame = CGRect(x : 0, y: 120, width: 400, height: 36 )
        view.addSubview(UserAccount)
    }
    
    private let UserAccount: UILabel = {
         let userAccount = UILabel()
         userAccount.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
         userAccount.numberOfLines = 0
         userAccount.textAlignment = .center
         userAccount.textColor = UIColor.black
         userAccount.font = UIFont.boldSystemFont(ofSize: 24)
         userAccount.text = "User Account"
         userAccount.backgroundColor = UIColor.systemYellow
        
         
         return userAccount
     }()
    
    private let plusSign: UIImageView = {
        let ps = UIImageView()
        ps.image = UIImage(named: "Cover")
        ps.contentMode = .scaleAspectFit
        return ps
    }()
    
    @objc func handle_C(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = Add_User()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
}

class Users {
    let email : String?
    let name: String?
    let race : String?
    let password : String?
    
    init (email: String, name : String, race : String, password : String){
        self.email = email
        self.name = name
        self.race = race
        self.password = password
    }
}

class Main_VC1 : UIViewController {
    
    var email = "";
    var name = "";
    var race = "";
    var password = "";
    
    lazy var user = Users(email: email, name: name, race : race, password: password)
    override func viewDidLoad(){
        super.viewDidLoad()
        print(user.email)
        print(user.name)
        print(user.race)
        print(user.password)
    }
}

class Add_User : UIViewController {
    
    var user_registration = ["Email" : "sample", "Password" : "N/A", "Name" : "N/A", "Race" : "N/A"]
    let races = ["Asian", "Black", "Latino", "White", "Other"]
    lazy var res = SelectRace(arr: races,
                              n: races.count,
                              c: UIColor.systemBlue,
                              s: (view.frame.width/CGFloat(races.count)) * 0.85,
                              y: 200,
                              m: 1.2)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(EditButton)
        start3()
        
        for item in res {
            item.addTarget(self, action: #selector(SelectingRace(sender: )), for: .touchUpInside)
            view.addSubview(item)
        }
    }
    
    let EditButton : UIButton = {
        let EB = UIButton()
        EB.setTitle("Edit", for: .normal)
        EB.backgroundColor = UIColor.systemGreen
        EB.layer.cornerRadius = 10
        EB.addTarget(self, action: #selector(handle_D), for : .touchUpInside)
        
        return EB
        
    }()
    
    lazy var SaveButton : UIButton = {
        let SB = UIButton()
        SB.setTitle("Save", for: .normal)
        SB.backgroundColor = UIColor.systemGreen
        SB.layer.cornerRadius = 10
        SB.addTarget(self, action: #selector(handle_D), for : .touchUpInside)
        
        return SB
        
    }()
    
    func SelectRace (arr : [String], n : Int, c : UIColor, s : CGFloat, y : CGFloat, m : CGFloat) -> [UIButton] {
        var res = [UIButton]()
        for i in 0..<n {
            let bt = UIButton()
            let x : CGFloat = CGFloat(i) * s * m + 10
            bt.frame = CGRect(x: x, y: y+100, width: s, height: s)
            bt.tag = i
            bt.setTitle(arr[i], for: .normal)
            bt.backgroundColor = c
            res.append(bt)
        }
        return res
    }
    var isPicked : [Bool] = [false,false,false,false,false]
    @objc func SelectingRace(sender : UIButton) {
        // implement algorithm to make each button work
        // check if the button is selected
        // if yes, then turn other 3s off
        // turn the currect button on
        sender.isSelected = true
        let index = sender.tag
        for i in 0..<res.count {
            if i == index {
                isPicked[i] = true
                res[i].isSelected = isPicked[i]
                res[i].backgroundColor = .green
            }else{
                isPicked[i] = false
                res[i].isSelected = isPicked[i]
                res[i].backgroundColor = .gray
            }
        }
        print(isPicked)
        print(user_registration)
        user_registration["Race"] = sender.titleLabel?.text
        
    }
    
    let SetUpMyAllergenProfile : UIButton = {
        let SUMAP = UIButton()
        SUMAP.setTitle("Set Up My Allergen Profile", for: .normal)
        SUMAP.backgroundColor = UIColor.systemGreen
        SUMAP.layer.cornerRadius = 10
        SUMAP.addTarget(self, action: #selector(handle_D), for : .touchUpInside)
        
        return SUMAP
        
    }()
    
    let input_box : UITextView = {
        let tx = UITextView()
        tx.isUserInteractionEnabled = true
        tx.layer.borderWidth = 2
        tx.layer.borderColor = UIColor.black.cgColor
        
        return tx
    }()
    
    let input_box1 : UITextView = {
        let tx1 = UITextView()
        tx1.isUserInteractionEnabled = true
        tx1.layer.borderWidth = 2
        tx1.layer.borderColor = UIColor.black.cgColor
        
        return tx1
        
    }()
    
    let input_box2 : UITextView = {
        let tx2 = UITextView()
        tx2.isUserInteractionEnabled = true
        tx2.layer.borderWidth = 2
        tx2.layer.borderColor = UIColor.black.cgColor
        
        return tx2
        
    }()
    
    private func start3(){
        EditButton.frame = CGRect(x : 125, y: 400, width: 50, height: 36 )
        view.addSubview(EditButton)
        SaveButton.frame = CGRect(x : 225, y: 400, width: 50, height: 36 )
        view.addSubview(SaveButton)
        SetUpMyAllergenProfile.frame = CGRect(x : 75, y: 575, width : 250, height : 36)
        view.addSubview(SetUpMyAllergenProfile)
        UserAccount.frame = CGRect(x : 0, y: 50, width: 400, height: 36 )
        view.addSubview(UserAccount)
        Finalize.frame = CGRect(x : 50, y: 465, width: 300, height: 72 )
        view.addSubview(Finalize)
        input_box.frame = CGRect(x:45, y: 120, width: 300, height: 30)
        view.addSubview(input_box)
        input_box1.frame = CGRect(x:45, y: 180, width: 300, height: 30)
        view.addSubview(input_box1)
        input_box2.frame = CGRect(x:45, y: 240, width: 300, height: 30)
        view.addSubview(input_box2)
        emailAccount.frame = CGRect(x : 50, y: 96, width: 300, height: 24 )
        view.addSubview(emailAccount)
        userName.frame = CGRect(x : 50, y: 156, width: 300, height: 24 )
        view.addSubview(userName)
        ageString.frame = CGRect(x : 50, y: 216, width: 300, height: 24 )
        view.addSubview(ageString)
    }
    
    private let UserAccount: UILabel = {
         let userAccount = UILabel()
         userAccount.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
         userAccount.numberOfLines = 0
         userAccount.textAlignment = .center
         userAccount.textColor = UIColor.black
         userAccount.font = UIFont.boldSystemFont(ofSize: 24)
         userAccount.text = "User Account"
         userAccount.backgroundColor = UIColor.systemYellow
        
         
         return userAccount
     }()
    
    private let emailAccount: UILabel = {
         let email = UILabel()
         email.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
         email.numberOfLines = 0
         //email.textAlignment = .center
         email.textColor = UIColor.black
         email.font = UIFont.boldSystemFont(ofSize: 12)
         email.text = "Enter Your Email"
         email.backgroundColor = UIColor.white
        
         
         return email
     }()
    
    private let userName: UILabel = {
         let username = UILabel()
         username.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
         username.numberOfLines = 0
         //email.textAlignment = .center
         username.textColor = UIColor.black
         username.font = UIFont.boldSystemFont(ofSize: 12)
         username.text = "Enter Your Name"
         username.backgroundColor = UIColor.white
        
         
         return username
     }()
    
    private let ageString: UILabel = {
         let age = UILabel()
        age.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 48)
        age.numberOfLines = 0
         //email.textAlignment = .center
        age.textColor = UIColor.black
        age.font = UIFont.boldSystemFont(ofSize: 12)
        age.text = "Age"
        age.backgroundColor = UIColor.white
        
         
         return age
     }()
    

    
    private let Finalize: UILabel = {
         let finalize = UILabel()
        finalize.frame = CGRect (
             x: 100,
             y: 100,
             width: 200,
             height: 96)
        finalize.numberOfLines = 3
        finalize.textAlignment = .center
        finalize.textColor = UIColor.black
        finalize.font = UIFont.boldSystemFont(ofSize: 18)
        finalize.text = "Finalize your personalized list of ingredients that you eat, limit, and avoid based on your selections."
        finalize.backgroundColor = UIColor.white
        
         
         return finalize
     }()
    
    private let plusSign: UIImageView = {
        let ps = UIImageView()
        ps.image = UIImage(named: "Cover")
        
        ps.contentMode = .scaleAspectFit
        return ps
    }()
    
    @objc func handle_D(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = Main_VC1()
        vc.email = user_registration["Email"]!
        vc.name = user_registration["Name"]!
        vc.race = user_registration["Race"]!
        vc.password = user_registration["Password"]!
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
    }
}

class SelectingAllergens : UIViewController {
    
    let allergens : [String] = ["Shellfish", "Egg", "Peanut", "Tree Nuts", "Dairy", "Fish", "Sesame", "Soybean", "Wheat", "Additive", "Seed", "Meat", "Fruit", "Other"]

    lazy var res = SelectAllergen(arr: allergens,
                                  n: allergens.count,
                                  c: UIColor.systemBlue,
                                  s: (view.frame.width/CGFloat(allergens.count)) * 0.85,
                                  y: 200,
                                  m: 1.2)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        start3()
        for item in res{
            item.addTarget(self, action: #selector(SelectingAllergen(sender: )), for: .touchUpInside)
            view.addSubview(item)
        }
    }
    
    func SelectAllergen(arr : [String], n : Int, c: UIColor, s : CGFloat, y: CGFloat, m: CGFloat)-> [UIButton]{
        var res = [UIButton]()
        //design the pattern
        let y : CGFloat = view.frame.width - 20
        for i in 0..<n{
            let bt = UIButton()
            bt.setTitle(arr[i], for: .normal)
            let x : CGFloat = Warning.center.y + Warning.frame.height - 120
            let y : CGFloat = CGFloat(i) * s * 2.5 + 165  //f(x) = ax + b
            bt.frame = CGRect(x : x, y: y, width: 100, height: 20)
            bt.setTitleColor(UIColor.black, for: .normal)
            bt.backgroundColor = UIColor.white
            res.append(bt)
            bt.addTarget(self, action: #selector(SelectingAllergen), for : .touchUpInside)
        }
        //bt.addTarget(self, action: #selector(SelectingRace), for : .touchUpInside)
        return res
    }
    
    var isPicked : [Bool] = [false,false,false,false,false]
    @objc func SelectingAllergen(sender: UIButton){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = UserProfile()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        //self.present(vc, animated : true)
        sender.isSelected = true
        for i in 0..<res.count {
            if res[i].isSelected == true {
                isPicked[sender.tag] = true
                // turn other off
                // in the mean while change the selected button's background into other color
                // in the meanwhile, pass the selected information to the final container
                res[i].backgroundColor = UIColor.systemGreen
            }else{
                isPicked[i] = false
                res[i].backgroundColor = UIColor.systemGray
            }
        }
        print(isPicked)
                
        
    }
    
    private let Warning: UILabel = {
         let warning = UILabel()
         warning.frame = CGRect (
            x: 100,
            y: 100,
            width: 200,
            height: 48)
         warning.numberOfLines = 0
         warning.textAlignment = .center
         warning.textColor = UIColor.black
         warning.font = UIFont.boldSystemFont(ofSize: 24)
         warning.text = "When it Doubt, Leave it Out"
         warning.backgroundColor = UIColor.systemYellow
        
         
         return warning
     }()
    
    private func start3(){
        Warning.frame = CGRect(x : 0, y: 100, width: 400, height: 36 )
        view.addSubview(Warning)
    }
    
    @objc func handle_D(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = UserProfile()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
}

class UserProfile : UIViewController {
    override func viewDidLoad(){
        super.viewDidLoad()
        //view.addSubview(AddUser)
        
        //start3()
        
    }
}

class ReadingTheLabel  : UIViewController{
    override func viewDidLoad(){
        super.viewDidLoad()
        title_lb.frame = CGRect(x : 10, y: 60, width : 120, height: 48)
        title_lb.textAlignment =  .center
        view.addSubview(title_lb)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            self.start()
        }
    }
    let title_lb = UILabel()
    var display_bars = [UIButton]()
    var data_from_main : Int = 0
    var data_string_from_main : [String]?
    
    func iterate(n : Int, arr : [String])-> [UIButton]{
        var res = [UIButton]()
        //design the pattern
        let w : CGFloat = view.frame.width - 20
        let size : CGFloat = 24
        for i in 0..<n{
            let bt = UIButton()
            let length : CGFloat = CGFloat(arr[i].count) * size * 1.2
            bt.setTitle(arr[i], for: .normal)
            let x : CGFloat = 10
            let y : CGFloat = CGFloat(i) * size * 1.2 + 60 //f(x) = ax + b
            bt.frame = CGRect(x : x, y: y, width: w, height: size)
            bt.setTitleColor(UIColor.black, for: .normal)
            bt.backgroundColor = UIColor.systemGray
            res.append(bt)
        }
        return res
    }
    func start(){
        display_bars = iterate(n : data_from_main, arr : data_string_from_main!)
        for item in display_bars {
            view.addSubview(item)
            
        }
    }
}


/*class Multi_UIResponder : UIViewController {
    // class variable
    let races : [String] = ["A","B","L","W","O"]
    lazy var res = bts(arr: races,
                  n: races.count,
                  c: UIColor.systemBlue,
                  s: (view.frame.width/CGFloat(races.count)) * 0.85,
                  y: 200,
                  m: 1.2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 600)
        // local variable
        for item in res {
            item.addTarget(self, action: #selector(handle_R_Selection(sender: )), for: .touchUpInside)
            view.addSubview(item)
        }
    }
    func bts (arr : [String], n : Int, c : UIColor, s : CGFloat, y : CGFloat, m : CGFloat) -> [UIButton] {
        var res = [UIButton]()
        for i in 0..<n {
            let bt = UIButton()
            let x : CGFloat = CGFloat(i) * s * m + 10
            bt.frame = CGRect(x: x, y: y, width: s, height: s)
            bt.tag = i
            bt.setTitle(arr[i], for: .normal)
            bt.backgroundColor = c
            res.append(bt)
        }
        return res
    }
    var isPicked : [Bool] = [false,false,false,false,false]
    @objc func handle_R_Selection(sender : UIButton) {
        // implement algorithm to make each button work
        // check if the button is selected
        // if yes, then turn other 3s off
        let bt1 = UIButton()
        let bt2 = UIButton()
        let bt3 = UIButton()
        let bt4 = UIButton()
        let arr = [bt1, bt2,bt3, bt4]
        // turn the currect button on
        sender.isSelected = true
        // selected counter
        for i in 0..<res.count {
            if res[i].isSelected == true {
                isPicked[sender.tag] = true
                // turn other off
                // in the mean while change the selected button's background into other color
                // in the meanwhile, pass the selected information to the final container
                res[i].backgroundColor = UIColor.systemGreen
            }else{
                isPicked[i] = false
                res[i].backgroundColor = UIColor.systemGray
            }
        }
        print(isPicked)
    }
}

// final user's information collection---dictionary
var Users_Account = [Users]()
var user_1 = ["email" : "", "password" : "", "race" : ""]
user_1["email"] = "sample@gmail.ocm"
user_1["password"] = "123456"
// Classic Example of OOP and Algorithm in App System Design and Development
class Users {
    let email : String
    let password : String
    let race : String // add other important elements below such as age, potential allergic elements......
    // initializer or constructor
    init (email : String, password : String, race : String) {
        self.email = email
        self.password = password
        self.race = race
    }
}
// class object or instance
    let u1 = Users(email: "user_1@gmail.com", password: "1234567", race: "Asian")
    let u2 = Users(email: "user_2@gmail.com", password: "1234567", race: "Black")
    let u3 = Users(email: "user_3@gmail.com", password: "1234567", race: "Latino")
    let u4 = Users(email: "user_4@gmail.com", password: "1234567", race: "White")

    // when user press the submit registration button
    Users_Account.append(u1)
    Users_Account.append(u2)
    Users_Account.append(u3)
    Users_Account.append(u4)

print(Users_Account)
// Three Major Algorithm Principle (sequencing, iteration, selection)
    for item in Users_Account {
        if (item.race == "Black") {
            print(item.email)
    }
}*/
