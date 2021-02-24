//
//  ViewController.swift
//  Graph-Path-Finding
//
//  Created by Edward O'Neill on 2/24/21.
//

import UIKit

class ViewController: UIViewController {
    
    var cellCollection = [CustomCell]()
    var cellCount = 0
    var selectedCells = 0
    var searchSpeed: Timer?
    var cells = [CustomCell]()
    var graphSearchOptions = GraphSearchOptions()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let button: UIButton = {
        let screenSize = UIScreen.main.bounds
        let frame = CGRect(x: screenSize.width/2 - 100, y: 500, width: 200, height: 50)
        let button = UIButton(type: .system)
        button.frame = frame
        button.setTitle("Generate Board", for: .normal)
        button.addTarget(self, action: #selector(stateButtonPressed), for: .touchUpInside)

        return button
    }()
    
    @objc func stateButtonPressed(sender : UIButton) {
        if button.titleLabel?.text == "Generate Board" {
            button.setTitle("Start", for: .normal)
            searchSpeed = Timer.scheduledTimer(timeInterval: 0.00001, target: self, selector: #selector(createBoard), userInfo: nil, repeats: true)
            button.isEnabled = false
        } else if button.titleLabel?.text == "Start" {
            button.setTitle("Reset", for: .normal)
            startSearch()
        } else {
            for cell in cellCollection {
                cell.backgroundColor = .black
                cell.tag = 0
            }
            cells = []
            selectedCells = 0
            cellCount = 0
            button.setTitle("Generate Board", for: .normal)
            searchSpeed?.invalidate()
        }
        
    }
    
    @objc func createBoard() {
        guard cellCount < 306 else {
            searchSpeed?.invalidate()
            return
        }
        
        cellCollection[cellCount].backgroundColor = .white
        cellCount += 1
    }
    
    func startSearch() {
        graphSearchOptions.generateMatrix(cellCollection)
        graphSearchOptions.startSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        view.addSubview(collectionView)
        view.backgroundColor = .black
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: 20).isActive = true
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.frame.width
        let size = CGSize(width: (viewWidth/20), height: (viewWidth/20))
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 306
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        //        cell.data = self.data[indexPath.row]
        cell.backgroundColor = .black
        cellCollection.append(cell)
        cell.tag = 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedCells == 0 {
            cellCollection[indexPath.row].backgroundColor = .green
            selectedCells += 1
        } else if selectedCells == 1 {
            cellCollection[indexPath.row].backgroundColor = .red
            selectedCells += 1
            button.isEnabled = true
        } else {
            cellCollection[indexPath.row].backgroundColor = .gray
        }
        
    }
}
