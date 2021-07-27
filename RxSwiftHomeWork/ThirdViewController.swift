//
//  ThirdViewController.swift
//  RxSwiftHomeWork
//
//  Created by Владислав Вишняков on 23.07.2021.
//

import UIKit
import RxSwift
import RxCocoa

class ThirdViewController: UIViewController {
    
    private let dispose = DisposeBag()
    let names = BehaviorSubject<[String]>(value: ["Catheryn Mar", "Elias Durand","Tari Borrero","Katharine Greenough", "Effie Laberge","Era Palin","Herbert Leland","Gudrun Watford","Elijah Asuncion","Marian Paterson","Ardelle Waddington","Flo Pascual","Mafalda Mccrady","Ashley Wolpert","Krysta Mayorga","Hedwig Stavros","Rebeca Jaqua", "Edmund Sugg","Vina Nelligan", "Viola Amon"])
    var filterText: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var copyNames: [String] = []
    

    @IBOutlet weak var searchTextField: UISearchBar!
    func bindTableView() {
        names.bind(to: myTableView.rx.items) {
            (myTableView: UITableView, index: Int, element: String) in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = element
            return cell
        }.disposed(by: dispose)
    }
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBAction func addName(_ sender: Any) {
        
        if var value = try? names.value() {
            let randomElement = copyNames.randomElement() ?? ""
            value.insert(randomElement, at: 0)
            names.on(.next(value))
        }
    }
    @IBAction func removeName(_ sender: Any) {
        if var value = try? names.value() {
            if value.isEmpty == false {
                value.removeLast()
                names.on(.next(value))
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        copyNames = try! names.value()
        bindTableView()
        searchTextField.rx.text.throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance) .subscribe(onNext: { query in
            if var value = try? self.names.value() {
                if query?.isEmpty == false {
                    let filter = value.filter({(item) -> Bool in
                        return item.contains(query ?? "")
                    })
                    value = filter
                } else {
                    value = self.copyNames
                }
                self.names.on(.next(value))
            }
        }).disposed(by: dispose)
        
    }
}
