//
//  CollectionVc.swift
//  CloudInteractiveTest
//
//  Created by 五加一 on 2019/2/22.
//  Copyright © 2019 五加一. All rights reserved.
//

import UIKit

class CollectionVc: UIViewController {
    
    var vo: PhotoBoxVo? {
        didSet {
            
            guard let vo: PhotoBoxVo = vo else {
                return
            }
            dataBox = vo.box
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
    }
    
    private
    var dataBox: [CellVO] = []
    private
    var collection: UICollectionView?
}

extension CollectionVc: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataBox.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: PhotoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
        }
        cell.vo = dataBox[indexPath.item]
        
        return cell
    }
}

extension CollectionVc {
    
    private
    func setCollectionView() {
        
        let flaoLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemSideLength: CGFloat = UIScreen.main.bounds.width / 4
        flaoLayout.itemSize = CGSize(width: itemSideLength, height: itemSideLength)
        flaoLayout.scrollDirection = .vertical
        flaoLayout.minimumInteritemSpacing = 0
        flaoLayout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flaoLayout)
        self.collection = collection
        collection.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collection.delegate = self
        collection.dataSource = self
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        view.addSubview(collection)
        collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

class PhotoCell: UICollectionViewCell {
    
    var vo: CellVO? {
        didSet {
            setDataSource()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setInit()
    }
    
    private
    let idLb: UILabel = UILabel()
    private
    let titleLb: UILabel = UILabel()
    private
    let imgView: UrlImgView = UrlImgView()
}

extension PhotoCell {
    
    private
    func setInit() {
        
        setDataSource()
        
        layoutImgView()
        layoutidLb()
        layoutTitleLb()
    }
    private
    func setDataSource() {
        
        setImg()
        setIdLb()
        setTitleLb()
    }
    private
    func setSameLb(with lb: UILabel, title: String) {
        
        lb.textAlignment = .center
        lb.text = title
    }
    private
    func setIdLb() {
        
        guard let vo: CellVO = vo else {
            idLb.text = "0"
            return
        }
        setSameLb(with: idLb, title: "\(vo.id)")
    }
    private
    func layoutidLb() {
        
        setSameLayout(with: idLb)
        NSLayoutConstraint(item: idLb, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.5, constant: 0).isActive = true
        idLb.sizeToFit()
    }
    
    private
    func setImg() {
        
        guard let vo: CellVO = vo,
            let url: URL = vo.getUrl(with: .thumbnail) else {
            
            return
        }
        imgView.getImg(with: url)
    }
    private
    func layoutImgView() {
        
        setSameLayout(with: imgView)
        imgView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private
    func setTitleLb() {
        
        guard let vo: CellVO = vo else {
            titleLb.text = "0"
            return
        }
        titleLb.numberOfLines = 0
        titleLb.adjustsFontSizeToFitWidth = true
        setSameLb(with: titleLb, title: "\(vo.title)")
    }
    private
    func layoutTitleLb() {
        
        setSameLayout(with: titleLb)
        titleLb.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLb.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    private
    func setSameLayout(with view: UIView) {
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
