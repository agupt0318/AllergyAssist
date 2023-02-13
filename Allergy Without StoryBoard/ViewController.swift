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
       return res;
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
    let vc = RegistrationVC()
    lazy var user = vc.user
    let left_margin : CGFloat = 10;
    let top_margin : CGFloat = 10;
    lazy var container_height : CGFloat = view.frame.height / 4
    
    //user interface
    lazy var top_container : UIView = {
        let iv = UIView()
        iv.frame = CGRect(x : left_margin, y: top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = UIColor.systemGray
        return iv
    }()
    lazy var middle_container : UIView = {
        let iv = UIView()
        iv.frame = CGRect(x : left_margin, y: top_container.center.y + top_container.frame.height / 2 + top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = UIColor.systemGray
        return iv
    }()
    
    lazy var bottom_container : UIView = {
        let iv = UIView()
        iv.frame = CGRect(x : left_margin, y: middle_container.center.y + middle_container.frame.height / 2 + top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.backgroundColor = UIColor.systemGray
        
        let user_profile_image_view = UIImageView()
        user_profile_image_view.image = UIImage(systemName: "Camera")
        user_profile_image_view.frame = CGRect(x : left_margin, y: top_margin, width: iv.frame.width/4, height: iv.frame.width/4)
        user_profile_image_view.clipsToBounds = true
        user_profile_image_view.backgroundColor = .white
        user_profile_image_view.layer.cornerRadius = 5
        
        let user_name = UILabel()
        user_name.frame = CGRect(x: left_margin, y: top_margin + user_profile_image_view.center.y + user_profile_image_view.frame.height / 2, width: iv.frame.width / 4, height: 20)
        user_name.clipsToBounds = true
        user_name.layer.cornerRadius = 5
        user_name.font = UIFont.boldSystemFont(ofSize : 18)
        user_name.backgroundColor = .white
        user_name.text = String(user.age)
        DispatchQueue.main.asyncAfter(deadline:
            DispatchTime.now() + 1) {
            user_name.text = self.user.name
        }
        
        let user_bio = UILabel()
        user_bio.frame = CGRect(x: left_margin + user_profile_image_view.center.x + user_profile_image_view.frame.width / 2, y: top_margin, width: 3 * (iv.frame.width / 4) - left_margin * 4, height: 20)
        user_bio.clipsToBounds = true
        user_bio.layer.cornerRadius = 5
        user_bio.font = UIFont.boldSystemFont(ofSize : 18)
        user_bio.backgroundColor = .white
        user_bio.text = user.email
        DispatchQueue.main.asyncAfter(deadline:
            DispatchTime.now() + 1) {
            user_bio.text = self.user.email
        }
        user_bio.text = user.email
        
        iv.addSubview(user_bio)
        iv.addSubview(user_name)
        iv.addSubview(user_profile_image_view)
        
        return iv
    }()
    func setup(){
        view.addSubview(top_container)
        view.addSubview(middle_container)
        view.addSubview(bottom_container)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(AddUser)
        view.frame = CGRect(x : 0, y: 0, width: 400, height: 600)
        setup()
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
        let vc = RegistrationVC()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
}

enum Race{
    case Asian
    case Black
    case Latino
    case White
    case Other
}

class User {
    var email : String
    var name : String
    var age : Int
    var race : Race
    init (email : String, name : String, age : Int, race : Race){
        self.email = email
        self.name = name
        self.age = age
        self.race = Race.Other
    }
}


class RegistrationVC : UIViewController {
    let email_input : UITextView = {
        let tx = UITextView()
        tx.isUserInteractionEnabled = true
        tx.layer.borderWidth = 2
        tx.layer.borderColor = UIColor.black.cgColor
        
        return tx
    }()
    
    let name_input : UITextView = {
        let tx1 = UITextView()
        tx1.isUserInteractionEnabled = true
        tx1.layer.borderWidth = 2
        tx1.layer.borderColor = UIColor.black.cgColor
        
        return tx1
        
    }()
    
    let age_input : UITextView = {
        let tx2 = UITextView()
        tx2.isUserInteractionEnabled = true
        tx2.layer.borderWidth = 2
        tx2.layer.borderColor = UIColor.black.cgColor
        
        return tx2
        
    }()
    
    var user = User(email: "sample@gmail.com", name: "Joe", age: 21, race: Race.Asian)
    
    
    @objc func submit() {
        //let sampleEmail = "asdasd"
        //email_input.text = sampleEmail
        user.email = email_input.text
        user.name = name_input.text
        
        let vc = UserAccountInfo()
        vc.user = self.user
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(EditButton)
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 600)
        /*DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
         self.work();
         }*/
        start3()
        for item in res {
            item.addTarget(self, action: #selector(SelectingRace(sender: )), for: .touchUpInside)
            view.addSubview(item)
        }
    }
    
    let races = ["Asian", "Black", "Latino", "White", "Other"]
    lazy var res = SelectRace(arr: races,
                              n: races.count,
                              c: UIColor.systemBlue,
                              s: (view.frame.width/CGFloat(races.count)) * 0.85,
                              y: 200,
                              m: 1.2)
    
    let EditButton : UIButton = {
        let EB = UIButton()
        EB.setTitle("Edit", for: .normal)
        EB.backgroundColor = UIColor.systemGreen
        EB.layer.cornerRadius = 10
        EB.addTarget(self, action: #selector(MyAllergies), for : .touchUpInside)
        
        return EB
        
    }()
    
    @objc func MyAllergies(){
        //pushing the current VC to another T(x) --->  X
        //step one : instance or object declaration
        let vc = myAllergens()
        //B obj = new B()
        vc.view.backgroundColor = UIColor.white
        //vc.title_lb.text = sign_in.titleLabel?.text
        self.present(vc, animated : true)
        
    }
    
    lazy var SaveButton : UIButton = {
        let SB = UIButton()
        SB.setTitle("Save", for: .normal)
        SB.backgroundColor = UIColor.systemGreen
        SB.layer.cornerRadius = 10
        SB.addTarget(self, action: #selector(submit), for : .touchUpInside)
        
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
        print(user)
        //user["Race"] = sender.titleLabel?.text
        
    }
    
    let SetUpMyAllergenProfile : UIButton = {
        let SUMAP = UIButton()
        SUMAP.setTitle("Set Up My Allergen Profile", for: .normal)
        SUMAP.backgroundColor = UIColor.systemGreen
        SUMAP.layer.cornerRadius = 10
        SUMAP.addTarget(self, action: #selector(MyAllergies), for : .touchUpInside)
        return SUMAP
        
    }()
    
    //    @objc func submit(sender: UIButton) {
    //        // Create the new view controller
    //        let nextViewController = UIViewController()
    //        nextViewController.view.backgroundColor = .white
    //
    //        // Present the new view controller
    //        present(nextViewController, animated: true, completion: nil)
    //    }
    
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
        email_input.frame = CGRect(x:45, y: 120, width: 300, height: 30)
        view.addSubview(email_input)
        name_input.frame = CGRect(x:45, y: 180, width: 300, height: 30)
        view.addSubview(name_input)
        age_input.frame = CGRect(x:45, y: 240, width: 300, height: 30)
        view.addSubview(age_input)
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
    
    class User_Profile_VC : UIViewController{
        let vc = RegistrationVC()
        lazy var user = vc.user
        let left_margin : CGFloat = 10;
        let top_margin : CGFloat = 10;
        lazy var container_height : CGFloat = view.frame.height / 4
        
        //user interface
        lazy var top_container : UIView = {
            let iv = UIView()
            iv.frame = CGRect(x : left_margin, y: top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 30
            iv.backgroundColor = UIColor.systemGray
            return iv
        }()
        lazy var middle_container : UIView = {
            let iv = UIView()
            iv.frame = CGRect(x : left_margin, y: top_container.center.y + top_container.frame.height / 2 + top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 30
            iv.backgroundColor = UIColor.systemGray
            return iv
        }()
        
        lazy var bottom_container : UIView = {
            let iv = UIView()
            iv.frame = CGRect(x : left_margin, y: middle_container.center.y + middle_container.frame.height / 2 + top_margin, width: view.frame.width - 2 * left_margin, height: container_height)
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 30
            iv.backgroundColor = UIColor.systemGray
            
            let user_profile_image_view = UIImageView()
            user_profile_image_view.image = UIImage(systemName: "Camera")
            user_profile_image_view.frame = CGRect(x : left_margin, y: top_margin, width: iv.frame.width/4, height: iv.frame.width/4)
            user_profile_image_view.clipsToBounds = true
            user_profile_image_view.backgroundColor = .white
            user_profile_image_view.layer.cornerRadius = 5
            
            let user_name = UILabel()
            user_name.frame = CGRect(x: left_margin, y: top_margin + user_profile_image_view.center.y + user_profile_image_view.frame.height / 2, width: iv.frame.width / 4, height: 20)
            user_name.clipsToBounds = true
            user_name.layer.cornerRadius = 5
            user_name.font = UIFont.boldSystemFont(ofSize : 18)
            user_name.backgroundColor = .white
            user_name.text = String(user.age)
            DispatchQueue.main.asyncAfter(deadline:
                                            DispatchTime.now() + 1) {
                user_name.text = self.user.email
            }
            
            let user_bio = UILabel()
            user_bio.frame = CGRect(x: left_margin + user_profile_image_view.center.x + user_profile_image_view.frame.width / 2, y: top_margin, width: 3 * (iv.frame.width / 4) - left_margin * 4, height: 20)
            user_bio.clipsToBounds = true
            user_bio.layer.cornerRadius = 5
            user_bio.font = UIFont.boldSystemFont(ofSize : 18)
            user_bio.backgroundColor = .white
            user_bio.text = user.name
            DispatchQueue.main.asyncAfter(deadline:
                                            DispatchTime.now() + 1) {
                user_bio.text = self.user.name
            }
            user_bio.text = user.name
            
            iv.addSubview(user_bio)
            iv.addSubview(user_name)
            iv.addSubview(user_profile_image_view)
            
            return iv
        }()
        func setup(){
            view.addSubview(top_container)
            view.addSubview(middle_container)
            view.addSubview(bottom_container)
        }
        override func viewDidLoad(){
            super.viewDidLoad()
            view.frame = CGRect(x : 0, y: 0, width: 400, height: 600)
            setup()
        }
    }
    
    
    class Add_User : UIViewController {
        
        var user_registration = ["Email" : "sample", "Name" : "N/A", "Age" : "0", "Race" : "N/A"]
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
            EB.addTarget(self, action: #selector(MyAllergies), for : .touchUpInside)
            
            return EB
            
        }()
        
        lazy var SaveButton : UIButton = {
            let SB = UIButton()
            SB.setTitle("Save", for: .normal)
            SB.backgroundColor = UIColor.systemGreen
            SB.layer.cornerRadius = 10
            SB.addTarget(self, action: #selector(submit), for : .touchUpInside)
            
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
            SUMAP.addTarget(self, action: #selector(MyAllergies), for : .touchUpInside)
            
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
    }
    /*---------------------------------------------------------------------------------------------------------*/
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
    
    //    class myAllergens: UIViewController {
    //
    //        let allergens : [[String]] = [["Shellfish","+"],
    //                                      ["Egg",""],
    //                                      ["Peanut",""],
    //                                      ["Tree Nuts","+"],
    //                                      ["Dairy",""],
    //                                      ["Fish",""],
    //                                      ["Sesame",""],
    //                                      ["Soybean",""],
    //                                      ["Wheat",""],
    //                                      ["Additive","+"],
    //                                      ["Seed","+"],
    //                                      ["Meat","+"],
    //                                      ["Fruit","+"],
    //                                      ["Other","+"]]
    //        let pageTitle = UILabel()
    //        let warning = UILabel()
    //        let segmentItems = ["Avoid", "Limit this", "Can eat"]
    //        let scrollView = UIScrollView()
    //        let eggRow: UIStackView = {
    //            let eggRow = UIStackView()
    //            let eggRowlb = UILabel()
    //            eggRowlb.font = UIFont.boldSystemFont(ofSize: 20)
    //            eggRowlb.backgroundColor = UIColor.white
    //            eggRowlb.textColor = UIColor.black
    //            eggRowlb.textAlignment = .left
    //            eggRowlb.text = "Egg"
    //            eggRow.addArrangedSubview(eggRowlb)
    //            let bt0 = UIButton()
    //            bt0.setTitle("", for: .normal)
    //            eggRow.addArrangedSubview(bt0)
    //            eggRow.setCustomSpacing(5, after: bt0)
    //            let segmentItems = ["Avoid", "Limit this", "Can eat"]
    //            let control = UISegmentedControl(items: segmentItems)
    //            control.frame = CGRect(x: 5, y: 0, width: 240, height: 30)
    //            control.addTarget(myAllergens.self, action: #selector(segmentControl(_:)), for: .valueChanged)
    //            control.selectedSegmentIndex = 0
    //            eggRow.addArrangedSubview(control)
    //            NSLayoutConstraint.activate([
    //                eggRowlb.widthAnchor.constraint(equalToConstant: 90.0),
    //                eggRowlb.heightAnchor.constraint(equalToConstant: 30.0),
    //            ])
    //            NSLayoutConstraint.activate([
    //                bt0.widthAnchor.constraint(equalToConstant: 30.0),
    //                bt0.heightAnchor.constraint(equalToConstant: 30.0),
    //            ])
    //            NSLayoutConstraint.activate([
    //                control.widthAnchor.constraint(equalToConstant: 240.0),
    //                control.heightAnchor.constraint(equalToConstant: 30.0),
    //            ])
    //            return eggRow
    //        }()
    //
    //        override func viewDidLoad() {
    //            super.viewDidLoad()
    //            // Do any additional setup after loading the view.
    //            view.backgroundColor = UIColor.white
    //            //setup layout
    //            pageTitle.font = UIFont.boldSystemFont(ofSize: 25)
    //            pageTitle.backgroundColor = UIColor.white
    //            pageTitle.textColor = UIColor.black
    //            pageTitle.textAlignment = .center
    //            pageTitle.text = "My Allergens"
    //            warning.font = UIFont.boldSystemFont(ofSize: 25)
    //            warning.backgroundColor = UIColor.yellow
    //            warning.textColor = UIColor.red
    //            warning.textAlignment = .center
    //            warning.text = "Leave it if you are not sure!!!"
    //
    //            // create a vertical stack view to hold the rows of buttons
    //            let verticalStackView = UIStackView()
    //            verticalStackView.axis = .vertical
    //
    //            // we're going to use auto-layout
    //            pageTitle.translatesAutoresizingMaskIntoConstraints = false
    //            warning.translatesAutoresizingMaskIntoConstraints = false
    //            scrollView.translatesAutoresizingMaskIntoConstraints = false
    //            verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    //
    //            // add label to view
    //            view.addSubview(pageTitle)
    //            view.addSubview(warning)
    //
    //            // add Scrollview to view
    //            self.view.addSubview(scrollView)
    //
    //            // add stack view to scrollView
    //            scrollView.addSubview(verticalStackView)
    //
    //            for i in 0..<allergens.count{
    //                // add row
    //                let row = UIStackView()
    //                // add it to the vertical stack view
    //                verticalStackView.addArrangedSubview(row)
    //                verticalStackView.setCustomSpacing(15, after: row)
    //                let lb = UILabel()
    //                lb.font = UIFont.boldSystemFont(ofSize: 20)
    //                lb.backgroundColor = UIColor.white
    //                lb.textColor = UIColor.black
    //                lb.textAlignment = .left
    //                lb.text = allergens[i][0]
    //                row.addArrangedSubview(lb)
    //                row.setCustomSpacing(5, after: lb)
    //                NSLayoutConstraint.activate([
    //                    lb.widthAnchor.constraint(equalToConstant: 90.0),
    //                    lb.heightAnchor.constraint(equalToConstant: 30.0),
    //                ])
    //
    //                let bt0 = UIButton()
    //                if allergens[i][1]=="+"{
    //                    bt0.setTitle(allergens[i][1], for: .normal)
    //                    bt0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
    //                    //                bt0.frame = CGRectMake(0, 0, 20, 20)
    //                    //                bt0.clipsToBounds = true
    //                    bt0.layer.cornerRadius = 15
    //                    bt0.backgroundColor = .systemGreen
    //                    bt0.addTarget(self, action: #selector(shellfishDetail), for: .touchUpInside)
    //                }
    //                row.addArrangedSubview(bt0)
    //                row.setCustomSpacing(5, after: bt0)
    //                NSLayoutConstraint.activate([
    //                    bt0.widthAnchor.constraint(equalToConstant: 30.0),
    //                    bt0.heightAnchor.constraint(equalToConstant: 30.0),
    //                ])
    //
    //                let bt1 = UIButton()
    //                bt1.setTitle("Avoid", for: .normal)
    //                bt1.layer.borderWidth = 1
    //                bt1.setTitleColor(.blue, for: .normal)
    //                bt1.addTarget(self, action: #selector(shellfishDetail), for: .touchUpInside)
    //                row.addArrangedSubview(bt1)
    //                NSLayoutConstraint.activate([
    //                    bt1.widthAnchor.constraint(equalToConstant: 80.0),
    //                    bt1.heightAnchor.constraint(equalToConstant: 30.0),
    //                ])
    //
    //                let bt2 = UIButton()
    //                bt2.setTitle("Limit this", for: .normal)
    //                bt2.layer.borderWidth = 1
    //                bt2.setTitleColor(.blue, for: .normal)
    //                bt2.addTarget(self, action: #selector(shellfishDetail), for: .touchUpInside)
    //                row.addArrangedSubview(bt2)
    //                NSLayoutConstraint.activate([
    //                    bt2.widthAnchor.constraint(equalToConstant: 80.0),
    //                    bt2.heightAnchor.constraint(equalToConstant: 30.0),
    //                ])
    //
    //                let bt3 = UIButton()
    //                bt3.setTitle("Can eat", for: .normal)
    //                bt3.layer.borderWidth = 1
    //                bt3.setTitleColor(.blue, for: .normal)
    //                bt3.addTarget(self, action: #selector(shellfishDetail), for: .touchUpInside)
    //                row.addArrangedSubview(bt3)
    //                NSLayoutConstraint.activate([
    //                    bt3.widthAnchor.constraint(equalToConstant: 80.0),
    //                    bt3.heightAnchor.constraint(equalToConstant: 30.0),
    //                ])
    //            }
    //
    //            verticalStackView.addArrangedSubview(eggRow)
    //
    //            // finally, let's set our constraints
    //            // respect safe-area
    //            let safeG = view.safeAreaLayoutGuide
    //            NSLayoutConstraint.activate([
    //                // constrain label
    //                //  50-pts from top
    //                //  80% of the width
    //                pageTitle.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 0.0),
    //                pageTitle.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.5),
    //                pageTitle.leftAnchor.constraint(equalTo: safeG.leftAnchor, constant: 10.0),
    //                // constrain label
    //                //  50-pts from top
    //                //  80% of the width
    //                //  centered horizontally
    //                warning.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 5.0),
    //                warning.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.95),
    //                warning.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
    //                // constrain scrollView
    //                //  10-pts from bottom of label
    //                //  Leading and Trailing to safe-area with 10-pts "padding"
    //                //  Bottom to safe-area with 50-pts "padding"
    //                scrollView.topAnchor.constraint(equalTo: warning.bottomAnchor, constant: 10.0),
    //                scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 5.0),
    //                scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -5.0),
    //                scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -75.0),
    //
    //                // constrain vertical stack view to scrollView Content Layout Guide
    //                //  8-pts all around (so we have a little "padding")
    //                verticalStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5.0),
    //                verticalStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 5.0),
    //                verticalStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -5.0),
    //                verticalStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -5.0),
    //
    //            ])
    //            //method call
    //            edit_pf()
    //            save_pf()
    //            navi()
    //        }
    //
    //        //method declaration
    //        private func edit_pf(){
    //            edit_pf_bt.frame = CGRect(x: 250, y: 55, width: 50, height: 30)
    //            edit_pf_bt.layer.cornerRadius = 10
    //            edit_pf_bt.layer.masksToBounds = true
    //            edit_pf_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
    //            view.addSubview(edit_pf_bt)
    //        }
    //
    //        private func save_pf(){
    //            save_pf_bt.frame = CGRect(x: 330, y: 55, width: 50, height: 30)
    //            save_pf_bt.layer.cornerRadius = 10
    //            save_pf_bt.layer.masksToBounds = true
    //            save_pf_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
    //            view.addSubview(save_pf_bt)
    //        }
    //
    //        private func navi(){
    //            home_bt.frame = CGRect(x: 30, y: 750, width: 100, height: 30)
    //            home_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
    //            view.addSubview(home_bt)
    //            scan_bt.frame = CGRect(x: 150, y: 750, width: 100, height: 30)
    //            scan_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
    //            view.addSubview(scan_bt)
    //            setting_bt.frame = CGRect(x: 270, y: 750, width: 100, height: 30)
    //            setting_bt.addTarget(self, action: #selector(h1(sender: )), for: .touchUpInside)
    //            view.addSubview(setting_bt)
    //        }
    //
    //        @objc func h1(sender : UIButton){
    //            let vc = Main_VC()
    //            vc.modalPresentationStyle = .fullScreen
    //            self.present(vc, animated: true)
    //        }
    //
    //        let edit_pf_bt : UIButton = {
    //            let bt = UIButton()
    //            bt.setTitle("Edit", for: .normal)
    //            bt.backgroundColor = UIColor.systemBlue
    //            return bt
    //        }()
    //
    //        let save_pf_bt : UIButton = {
    //            let bt = UIButton()
    //            bt.setTitle("Save", for: .normal)
    //            bt.backgroundColor = UIColor.systemBlue
    //            return bt
    //        }()
    //
    //        let home_bt : UIButton = {
    //            let bt = UIButton()
    //            bt.setTitle("Home", for: .normal)
    //            bt.backgroundColor = UIColor.systemGray
    //            return bt
    //        }()
    //
    //        let scan_bt : UIButton = {
    //            let bt = UIButton()
    //            bt.setTitle("Scan", for: .normal)
    //            bt.backgroundColor = UIColor.systemGray
    //            return bt
    //        }()
    //
    //        let setting_bt : UIButton = {
    //            let bt = UIButton()
    //            bt.setTitle("Setting", for: .normal)
    //            bt.backgroundColor = UIColor.systemGray
    //            return bt
    //        }()
    //
    //        @objc func shellfishDetail(sender: UIButton!) {
    //            warning.text = sender.title(for: .normal)
    //        }
    //        @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
    //            switch (segmentedControl.selectedSegmentIndex) {
    //            case 0:
    //                break
    //            case 1:
    //                break
    //            case 2:
    //                break
    //            default:
    //                break
    //            }
    //        }
    //    }
    class myAllergens: UIViewController, UITableViewDataSource, UITableViewDelegate {

        let allergens: [[String]] = [["Shellfish","+"],
                                      ["Egg",""],
                                      ["Peanut",""],
                                      ["Tree Nuts","+"],
                                      ["Dairy",""],
                                      ["Fish",""],
                                      ["Sesame",""],
                                      ["Soybean",""],
                                      ["Wheat",""],
                                      ["Additive","+"],
                                      ["Seed","+"],
                                      ["Meat","+"],
                                      ["Fruit","+"],
                                      ["Other","+"]]
        let segmentItems = ["Avoid", "Limit this", "Can eat"]
        let tableView = UITableView()
        let warning = UILabel()

        override func viewDidLoad() {
            super.viewDidLoad()

            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AllergenCell")
            view.addSubview(tableView)

            tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])

            warning.frame = CGRect (
                x: 100,
                y: 100,
                width: 200,
                height: 48)
            warning.numberOfLines = 0
            warning.textAlignment = .center
            warning.textColor = UIColor.black
            warning.font = UIFont.boldSystemFont(ofSize: 24)
            warning.text = "When in Doubt, Leave it Out"
            warning.backgroundColor = UIColor.systemYellow
            view.addSubview(warning)

            warning.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                warning.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                warning.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allergens.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllergenCell", for: indexPath)

            let allergen = allergens[indexPath.row]
            cell.textLabel?.text = allergen[0]

            let control = UISegmentedControl(items: segmentItems)
            control.frame = CGRect(x: cell.frame.width - 200, y: cell.frame.minY, width: 200, height: cell.frame.height)
            control.selectedSegmentIndex = 0
            control.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
            cell.addSubview(control)

            let dropdown = UIButton(type: .system)
            dropdown.frame = CGRect(x: cell.frame.width - 50, y: cell.frame.minY + 10, width: 30, height: 30)
            if allergen[1] == "+" {
                dropdown.setImage(UIImage(named: "greenplus"), for: .normal)
                dropdown.addTarget(self, action: #selector(dropdownTapped), for: .touchUpInside)
            } else {
                dropdown.isHidden = true
            }
            cell.addSubview(dropdown)

            return cell
        }

        @objc func dropdownTapped(sender: UIButton) {
            // Code to handle the dropdown button tap
        }
            
        @objc func valueChanged(sender: UISegmentedControl) {
            guard let cell = sender.superview?.superview as? UITableViewCell else {
                return
            }

            let indexPath = tableView.indexPath(for: cell)
            var allergen = allergens[indexPath!.row]
            allergen[1] = segmentItems[sender.selectedSegmentIndex]
            tableView.reloadData()
        }

        
        @objc func segmentControl(_ sender: UISegmentedControl) {
                // handle the value changed event of the segmented control here
        }
    }
}
