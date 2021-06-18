//
//  RegisterViewController.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/11.
//

import UIKit
import RxSwift
import FirebaseAuth
import FirebaseFirestore
import PKHUD

class RegisterViewController: UIViewController {
        
    private let disposeBag=DisposeBag()
    private let viewModel=RegisterViewModel()
    
    private let titleLabel=RegisterTitleLabel(text: "USPoN")
    private let nameTextField=RegisterTextField(placeHolder: "ニックネーム")
    private let emailTextField=RegisterTextField(placeHolder: "@ec.usp.ac.jpまたは@st.shiga-u.ac.jp")
    private let passwordTextField=RegisterTextField(placeHolder: "パスワード3文字以上")
    private let registerButton=RegisterButton(text: "登録")
    private let alreadyHaveAccount:UIStackView={
        let label=UILabel()
        let alreadyHaveAccountButton=UIButton(type: .system).createAboutButton()
        label.font = .systemFont(ofSize: 14)
        label.text="既にアカウントをお持ちの方は"
        let view=UIStackView(arrangedSubviews: [label,alreadyHaveAccountButton])
        view.axis = .horizontal
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        setupLayout()
        setupBindings()
        let notificationCenter = NotificationCenter.default
        //アプリがアクティブになったとき
        notificationCenter.addObserver(
            self,
            selector: #selector(self.function),
            name:UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden=true
    }
    //MARK:Methods
    private func setupGradientLayer(){
        let layer=CAGradientLayer()
        let startColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
        let endColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1).cgColor

        layer.colors=[startColor,endColor]
        layer.locations=[0.02,1,3]
        layer.frame=view.bounds
        view.layer.addSublayer(layer)
    }
    
    @objc func function(){
        if Auth.auth().currentUser != nil{
            Auth.auth().currentUser?.reload(completion: { error in
                if error == nil {
                    if Auth.auth().currentUser?.isEmailVerified == true {
                        HomeViewController.registerflag=true
                        ProfileViewController.firstflag=true
                        NotificationCenter.default.removeObserver(self)
                        self.dismiss(animated: true)
                    } else if Auth.auth().currentUser?.isEmailVerified == false {
                        let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。メールのリンクをタップして認証を完了してください。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        let resend: UIAlertAction = UIAlertAction(title: "再送信", style: UIAlertAction.Style.cancel, handler:{
                            // キャンセルボタンが押された時の処理をクロージャ実装する
                            (action: UIAlertAction!) -> Void in
                            //実際の処理
                            Auth.auth().languageCode="ja"
                            Auth.auth().currentUser?.sendEmailVerification { (error) in
                            }
                        })
                        alert.addAction(resend)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }

    
    private func setupLayout(){
        //パスワードの文字を隠す
        passwordTextField.isSecureTextEntry=true
        
        emailTextField.textContentType = .emailAddress
        nameTextField.textContentType = .username
        passwordTextField.textContentType = .password

        let alert=UIAlertController.createreRegisterAlert()
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
        
        let backImage=UIImage(named: "biwako")
        let imageViewBackground=UIImageView(image: backImage)
        imageViewBackground.alpha=0.3
        imageViewBackground.contentMode = .scaleAspectFill
        
        let baseStackView=UIStackView(arrangedSubviews: [nameTextField,emailTextField,passwordTextField,registerButton])
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        baseStackView.spacing=20
        view.addSubview(imageViewBackground)
        view.addSubview(baseStackView)
        view.addSubview(titleLabel)
        view.addSubview(alreadyHaveAccount)
        
        nameTextField.anchor(height:45)
        baseStackView.anchor(left:view.leftAnchor,right:view.rightAnchor,centerY: view.centerYAnchor,leftpadding: 40,rightpadding: 40)
        titleLabel.anchor(bottom:baseStackView.topAnchor,centerX: view.centerXAnchor,bottompadding: 80)
        alreadyHaveAccount.anchor(top:baseStackView.bottomAnchor,centerX: view.centerXAnchor,toppadding: 20)
        imageViewBackground.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left:view.leftAnchor, right: view.rightAnchor,toppadding: 200,bottompadding: 200, leftpadding: 50, rightpadding: 50)
        
    }
    private func setupBindings(){

        nameTextField.rx.text
            .asDriver()
            .drive{ [weak self] text in
                self?.viewModel.nameTextInput.onNext(text ?? "")
            }
            .disposed(by:disposeBag)
        
        emailTextField.rx.text
            .asDriver()
            .drive{ [weak self] text in
                self?.viewModel.emailTextInput.onNext(text ?? "")
            }
            .disposed(by:disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive{ [weak self] text in
                self?.viewModel.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by:disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive{[weak self] _ in
                //登録時の処理
                self?.createUser()
            }
            .disposed(by:disposeBag)

        guard let alreadyHaveAccountButton=alreadyHaveAccount.subviews[1] as? UIButton else {return}
        alreadyHaveAccountButton.rx.tap
            .asDriver()
            .drive{[weak self] _ in
                let login=LoginViewController()
                self?.navigationController?.pushViewController(login, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.validRegisterDriver
            .drive{[weak self] validAll in
                self?.registerButton.isEnabled=validAll
                self?.registerButton.backgroundColor=validAll ? .rgb(red: 227, green: 48, blue: 78) : .init(white:0.7,alpha:1)
            }
            .disposed(by:disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil{
            Auth.auth().currentUser?.reload(completion: { error in
                if error == nil {
                    if Auth.auth().currentUser?.isEmailVerified == true {
                        print(2)
                        HomeViewController.registerflag=true
                        ProfileViewController.firstflag=true
                        self.dismiss(animated: true)
                    } else if Auth.auth().currentUser?.isEmailVerified == false {
                        let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。メールのリンクをタップして認証を完了してください。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        let resend: UIAlertAction = UIAlertAction(title: "再送信", style: UIAlertAction.Style.cancel, handler:{
                            // キャンセルボタンが押された時の処理をクロージャ実装する
                            (action: UIAlertAction!) -> Void in
                            //実際の処理
                            Auth.auth().currentUser?.sendEmailVerification { (error) in
                              // ...
                            }
                        })
                        alert.addAction(resend)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
        
}
    
    private func createUser(){
        
        let email=emailTextField.text
        let password=passwordTextField.text
        let name=nameTextField.text
        
        HUD.show(.progress)
        Auth.createUsertoFirebaseAuth(email: email, password: password, name: name) {[weak self] (success) in
            if success{
                HUD.hide{(_) in
                    HUD.flash(.success,onView: self?.view,delay: 1){(_) in
                        let alert = UIAlertController(title: "仮登録を行いました。", message: "入力したメールアドレス宛に確認メールを送信しました。メールのリンクをタップして認証を完了してください。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
