//
//  HorizontalCollectionViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 10.01.23.
//

import UIKit
import Display
import Combine

class HorizontalCollectionViewController<SetupModel: HorizontalCollectionDataSourced, Cell: SetupableCollectionCell>: UICollectionView, Setupable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate where Cell.SetupModel == SetupModel.CellModel {

    // MARK: - Properties
    
    private var cellIdentifier: String { return String(describing: Cell.self) }
    private var model: SetupModel!
    private var cancellables: Set<AnyCancellable> = []
    private var itemWidth: CGFloat {
        return frame.width - 2 * 13
    }
    
    private var indexOfCellBeforeDragging = 0

    // MARK: - Setup UI
    
    func setup(with model: SetupModel) {
        self.model = model

        register(UINib(nibName: "\(Cell.self)", bundle: Constants.mainBundle),
                 forCellWithReuseIdentifier: cellIdentifier)
        
        delegate = self
        dataSource = self
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        //        isPagingEnabled = true
        
        setupLayout()
        bindToDataSource()
        backgroundColor = .clear
    }
    
    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        collectionViewLayout = layout
    }
    
    // MARK: - Binding
    
    private func bindToDataSource() {
        model.dataSource
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.reloadData()
                
                if let initialSelectedIndex = self?.model.initialSelectedIndex {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.scrollToItem(at: IndexPath(item: initialSelectedIndex, section: 0), at: .centeredHorizontally, animated: false)
                        self?.model.currentItemIndexPath.send(IndexPath(item: initialSelectedIndex, section: 0))
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func indexOfMajorCell() -> Int {
        let proportionalOffset = collectionViewLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(model.dataSource.value.count - 1, index))

        return safeIndex
    }
    
    private func shouldSkipCurrentCell(for velocity: CGPoint) -> (Bool, Bool) {
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < model.dataSource.value.count && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell() == indexOfCellBeforeDragging
        let shouldSkip = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)

        return (shouldSkip, hasEnoughVelocityToSlideToTheNextCell)
    }

    // MARK: - CollectionView Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.dataSource.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellModel = model.dataSource.value[safe: indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        
        cell.setup(with: cellModel)
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset

        let indexOfMajorCell = self.indexOfMajorCell()
        let shouldSkipCell: (shouldSkip: Bool, isToNext: Bool) = shouldSkipCurrentCell(for: velocity)
        // calculate conditions:
        
        if shouldSkipCell.shouldSkip {
            let snapToIndex = indexOfCellBeforeDragging + (shouldSkipCell.isToNext ? 1 : -1)
            let toValue = itemWidth * CGFloat(snapToIndex)
            
            model.currentItemIndexPath.send(IndexPath(item: snapToIndex, section: 0))

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            model.currentItemIndexPath.send(IndexPath(item: indexOfMajorCell, section: 0))
            scrollToItem(at: IndexPath(item: indexOfMajorCell, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        
        return CGSize(width: itemWidth, height: height)
    }
    

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let selectedIndex = model.currentItemIndexPath.value?.row ?? 0
        guard selectedIndex != 0 else {
            return true
        }

        cancelContextGestures(view: self)
        
        return true
    }

    private func cancelContextGestures(view: UIView) {
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if let recognizer = recognizer as? InteractiveTransitionGestureRecognizer {
                    recognizer.cancel()
                } else if let recognizer = recognizer as? WindowPanRecognizer {
                    recognizer.cancel()
                }
            }
        }

        if let superview = view.superview {
            cancelContextGestures(view: superview)
        }
    }
}
