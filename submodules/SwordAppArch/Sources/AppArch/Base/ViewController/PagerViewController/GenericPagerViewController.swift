//
//  GenericPagerViewController.swift
//  sword-ios
//
//  Created by Tigran Simonyan on 19.05.23.
//

import UIKit

class GenericPagerViewController<VM: PagerViewDataSourced, PageView: SetupableView>: HeaderFooterViewController<VM>, UIPageViewControllerDelegate, UIPageViewControllerDataSource where VM.PageModel == PageView.SetupModel {

    // MARK: - Poperties

    private let stackView: UIStackView = UIStackView()
    private var pagesContainerView: UIView = UIView()
    private var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()

        control.translatesAutoresizingMaskIntoConstraints = false
        control.currentPageIndicatorTintColor = theme.colors.tintGray
        control.pageIndicatorTintColor = theme.colors.lightBlue2

        return control
    }()

    private var currentPageIndex = 0
    private(set) var pagesViewControllers: [UIViewController] = []

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView = stackView
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        setupPageController()
        setupPageControlIfNeeded()
        setupPages()
        setupInitialPage()
    }

    private func setupPageController() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        pagesContainerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(pagesContainerView)
        setupPageViewController()
    }

    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self

        addChild(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pagesContainerView.addSubview(pageViewController.view)
        pageViewController.view.addBorderConstraints(constraintSides: .all)
        pageViewController.didMove(toParent: self)
    }

    private func setupPages() {
        pagesViewControllers = viewModel.dataSource.compactMap { createPageController(with: $0) }
    }

    private func setupInitialPage() {
        guard let firstPage = pagesViewControllers.first else { return }

        pageViewController.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        updatePageControlIfNeeded(newIndex: 0)
    }

    // MARK: - Page View Controller Delegate & DataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pagesViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        let pagesCount = pagesViewControllers.count

        guard pagesCount != nextIndex else {
            return nil
        }

        guard pagesCount > nextIndex else {
            return nil
        }
   
        return pagesViewControllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pagesViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard pagesViewControllers.count > previousIndex else {
            return nil
        }

        return pagesViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard finished,
              let firstViewController = pageViewController.viewControllers?.first,
              let index = pagesViewControllers.firstIndex(of: firstViewController) else { return }

        updatePageControlIfNeeded(newIndex: index)
    }

    // MARK: - Pages Creation

    func createPageController(with model: VM.PageModel) -> UIViewController? {
        guard let pageView = createPageView(with: model) else { return nil }

        let viewController = UIViewController()
        viewController.view.addSubview(pageView)
        pageView.addBorderConstraints(constraintSides: .all)

        return viewController
    }

    func createPageView(with model: VM.PageModel) -> PageView? {
        guard let view = PageView.loadFromNib() else { return nil }

        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(with: model)

        return view
    }

    @objc
    private func handlePageControlValueChange() {
        let newPageIndex = pageControl.currentPage
        let direction: UIPageViewController.NavigationDirection = newPageIndex > currentPageIndex ? .forward : .reverse

        pageViewController.setViewControllers([pagesViewControllers[newPageIndex]], direction: direction, animated: false)
        currentPageIndex = newPageIndex
    }
}

// MARK: - Setup Page Control

private extension GenericPagerViewController {
    func setupPageControlIfNeeded() {
        guard viewModel.hasPageControl else { return }

        let holderView = UIView()

        pageControl.numberOfPages = viewModel.dataSource.count

        holderView.translatesAutoresizingMaskIntoConstraints = false
        holderView.addSubview(pageControl)

        stackView.addArrangedSubview(holderView)

        NSLayoutConstraint.activate([holderView.heightAnchor.constraint(equalToConstant: 20),
                                     pageControl.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),
                                     pageControl.centerYAnchor.constraint(equalTo: holderView.centerYAnchor),
                                     pageControl.heightAnchor.constraint(equalToConstant: 20)])

        pageControl.addTarget(self, action: #selector(handlePageControlValueChange), for: .touchUpInside)
        pageControl.addTarget(self, action: #selector(handlePageControlValueChange), for: .valueChanged)
    }

    func updatePageControlIfNeeded(newIndex: Int) {
        pageControl.currentPage = newIndex
        currentPageIndex = newIndex
    }
}
