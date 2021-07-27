//
//  SecondViewController.swift
//  RxSwiftHomeWork
//
//  Created by Владислав Вишняков on 23.07.2021.
//

import UIKit
import RxSwift
import RxCocoa

class SecondViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var finderTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        finderTextField.rx.text.orEmpty.asObservable().debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] el in
                self.finderTextField.text = el
                print("Send request for \(el )")
            }).disposed(by: disposeBag)
    }
}
