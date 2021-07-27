//
//  FiveViewController.swift
//  RxSwiftHomeWork
//
//  Created by Владислав Вишняков on 26.07.2021.
//

import UIKit
import RxSwift
import RxCocoa

class FiveViewController: UIViewController {
    
    func placeText() {
        label.text = " Ракета запущена "
    }
    let dispose = DisposeBag()

    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.merge(button1.rx.tap.do(),button2.rx.tap.do()).subscribe(onNext: {
            self.placeText()
        }).disposed(by: dispose)
    }
}
