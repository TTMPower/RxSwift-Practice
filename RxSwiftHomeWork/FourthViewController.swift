//
//  FourthViewController.swift
//  RxSwiftHomeWork
//
//  Created by Владислав Вишняков on 26.07.2021.
//

import UIKit
import RxCocoa
import RxSwift

class FourthViewController: UIViewController {
    
    var counts = 0
    var dispose = DisposeBag()

    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tapButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.counts += 1
            self?.label.text = "\(self?.counts ?? 0)"
        }).disposed(by: dispose)
    }
}
