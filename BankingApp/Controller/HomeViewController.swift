//
//  HomeViewController.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 17.01.24.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    private var availableCards: Results<Card>?
    private var quickActionList: [QuickAction] = []
    private var currentCard: Card?
    private var currentCardIndex: Int? {
        didSet {
            if ((availableCards?.count ?? 0) > 0 && currentCardIndex != nil) {
                currentCard = availableCards?[currentCardIndex ?? 0]
            }
        }
    }

    let realm = RealmHelper.instance.realm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getCardList()
        createQuickActionList()
    }
    
    func getCardList() {
        let results = realm?.objects(Card.self)
        availableCards = results
        mainCollectionView.reloadData()
        let collectionList = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: IndexPath(index: 0)) as! CardCollectionCell
        collectionList.reloadData()
            currentCardIndex = 0
        print(availableCards ?? 0)
    }
    
    
    fileprivate func setUpView() {
        mainCollectionView.register(UINib(nibName: "CardCollectionCell", bundle: nil),forCellWithReuseIdentifier: "CardCollectionCell")
        
        mainCollectionView.register(UINib(nibName: "QuickActionsCollectionCell", bundle: nil),forCellWithReuseIdentifier: "QuickActionsCollectionCell")
        
        mainCollectionView.register(UINib(nibName: "EmptyCellCollectionViewCell", bundle: nil),forCellWithReuseIdentifier: "EmptyCellCollectionViewCell")
    }
    
    
    fileprivate func createCard() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddCardController") as! AddCardController
        vc.modalPresentationStyle = .popover
        vc.cardAddCallback = { [weak self] in
            guard let self = self else {return}
            self.getCardList()
        }
           present(vc, animated: true)
    }
    
    public func showAlertMessage(title: String, message: String){
            let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default)
            alertMessagePopUpBox.addAction(okButton)
            self.present(alertMessagePopUpBox, animated: true)
        }
    
    fileprivate func navigateQuickAction(id: Int) {
        switch id {
        case 0:
            createCard()
        case 1:
            if (!availableCards!.isEmpty) {
                try! realm?.write {
                    realm?.delete(currentCard ?? Card())
                    self.getCardList()
                }
            } else {
                showAlertMessage(title: "Cannot delete", message: "No card to delete")
            }
        case 2:
            let vc = storyboard?.instantiateViewController(withIdentifier: "TransferController") as! TransferController
            vc.fromCard = currentCard
            vc.availableCards = availableCards
            vc.modalPresentationStyle = .fullScreen
//            transfer controllere getCardList gonderir
            vc.transferCallback = getCardList
            present(vc, animated: true)
        default:
            break
        }
    }
    
    func createQuickActionList() {
           let actionList = [
               QuickAction(name: "create", image: "plus.app.fill", id: 0),
               QuickAction(name: "delete", image: "minus.square.fill", id: 1),
               QuickAction(name: "transfer", image: "arrow.up.square.fill", id: 2)
           ]
           quickActionList = actionList
       }
}
  

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            if availableCards?.isEmpty ?? false {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCellCollectionViewCell", for: indexPath) as! EmptyCellCollectionViewCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as! CardCollectionCell
                cell.cardList = availableCards
                cell.cardIndexCallback = { [weak self] indexPath in
                    guard let self = self else {return}
//                    updating currentCardIndex when scrolled
                    currentCardIndex = indexPath.row
                }
                cell.indexNumber = currentCardIndex ?? 0
                cell.favoriteCallback = { [weak self] id in
                    guard let self = self else {return}
                    let cardToUpdate = availableCards?.first{ $0.cardID == id }
                    guard let cardToUpdate = cardToUpdate else {return}
                    try! realm?.write {
                        cardToUpdate.isFavorite = !cardToUpdate.isFavorite
                    }
                }
                return cell
            }
            
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickActionsCollectionCell", for: indexPath) as! QuickActionsCollectionCell

            cell.quickActionList = quickActionList
            cell.quickActionCallBack = { [weak self] id in
                guard let self = self else {return}
                self.navigateQuickAction(id: id)
            }
            return cell
        } else {return UICollectionViewCell()}
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            CGSize(width: collectionView.frame.width, height: collectionView.frame.height * 0.3)
        } else {
            CGSize(width: collectionView.frame.width, height: 80)
        }
    }
    
//    if there is no card, then EmptyCardCell is shown and new card can be created
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let availableCards = availableCards else {return}
        if availableCards.isEmpty {
            createCard()
        }
        return
    }
}
