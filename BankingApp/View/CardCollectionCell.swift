//
//  CardCollectionCell.swift
//  BankingApp
//
//  Created by Fatima Abdinli on 08.02.24.
//

import UIKit
import RealmSwift

class CardCollectionCell: UICollectionViewCell {
    @IBOutlet weak var cardCollection: UICollectionView!
    
    var cardIndexCallback: ((IndexPath) -> Void)?
    var favoriteCallback: ((String) -> Void)?
    
    var cardList: Results<Card>?
    let realm = RealmHelper.instance.realm
    var indexNumber: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        reloadData()
    }
    
    func reloadData() {
        self.cardCollection.reloadData()
//        cardCollection.scrollToItem(at:IndexPath(item: indexNumber, section: 0), at: .right, animated: false)

    }
    
    fileprivate func setUpView() {
        cardCollection.register(UINib(nibName: "CardCell", bundle: nil),forCellWithReuseIdentifier: "CardCell")
    }
}

extension CardCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cardList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let list = cardList else {return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCell
        cell.configureCell(card: (list[indexPath.row]))
        cell.favoriteCallback = favoriteCallback
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in cardCollection.visibleCells {
            let indexPath = cardCollection.indexPath(for: cell)
            cardIndexCallback?(indexPath!)
        }
    }
}
