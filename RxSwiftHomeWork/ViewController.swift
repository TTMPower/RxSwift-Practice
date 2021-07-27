//
//  ViewController.swift
//  RxSwiftHomeWork
//
//  Created by Владислав Вишняков on 23.07.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var errorTypesOutlet: UILabel!
    @IBAction func loginButton(_ sender: UIButton) {
        print("Button tapped")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.becomeFirstResponder()
        
        emailTextfield.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.emailTextfieldPublish).disposed(by: disposeBag)
        passwordTextfield.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.passwordTextfieldPublish).disposed(by: disposeBag)
        
        loginViewModel.emailIsValid.bind(to: errorTypesOutlet.rx.isHidden).disposed(by: disposeBag)
        loginViewModel.emailIsValid.map{$0 ? "":"Некорректный E-mail"}.bind(to: errorTypesOutlet.rx.text).disposed(by: disposeBag)
        
        loginViewModel.password.bind(to: errorTypesOutlet.rx.isHidden).disposed(by: disposeBag)
        loginViewModel.password.map{$0 ? "":"Некорректный пароль"}.bind(to: errorTypesOutlet.rx.text).disposed(by: disposeBag)
        
        
        loginViewModel.isValid().bind(to: loginButtonOutlet.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map{$0 ? 1 : 0.1}.bind(to: loginButtonOutlet.rx.alpha).disposed(by: disposeBag)
        loginViewModel.isValid().bind(to: loginButtonOutlet.rx.isEnabled).disposed(by: disposeBag)
    }
}

class LoginViewModel {
    let emailTextfieldPublish = PublishSubject<String>()
    let passwordTextfieldPublish = PublishSubject<String>()
    
    var emailIsValid: Observable<Bool> {
        return emailTextfieldPublish.asObservable().map({
            $0.contains("@")
        })
    }
    
    var password: Observable<Bool> {
        return passwordTextfieldPublish.asObservable().map({
            $0.count >= 6
        })
    }
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(emailIsValid.asObservable(), password.asObservable()) { email, pass in
            return email && pass
        }.startWith(false)
    }
    
}
