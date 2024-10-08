//
//  BaseViewController.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class BaseViewController<ContentView: UIView>: UIViewController {
    
    let contentView: ContentView
    let disposeBag = DisposeBag()
    
    init(contentView: ContentView = ContentView()) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    //MARK: - Overriding Methods
    func bindViewModel() {}
}

//MARK: - Utility Methods
extension BaseViewController {
    func addKeyboardDismissAction() {
        self.contentView.rx
            .tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.contentView.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - ViewController LifeCycle Control Event
extension Reactive where Base: UIViewController {
  var viewDidLoad: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    return ControlEvent(events: source)
  }

  var viewWillAppear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
  var viewDidAppear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }

  var viewWillDisappear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
  var viewDidDisappear: ControlEvent<Bool> {
    let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }

  var viewWillLayoutSubviews: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
    return ControlEvent(events: source)
  }
  var viewDidLayoutSubviews: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
    return ControlEvent(events: source)
  }

  var willMoveToParentViewController: ControlEvent<UIViewController?> {
    let source = self.methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
    return ControlEvent(events: source)
  }
  var didMoveToParentViewController: ControlEvent<UIViewController?> {
    let source = self.methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
    return ControlEvent(events: source)
  }

  var didReceiveMemoryWarning: ControlEvent<Void> {
    let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
    return ControlEvent(events: source)
  }

  /// Rx observable, triggered when the ViewController appearance state changes (true if the View is being displayed, false otherwise)
  var isVisible: Observable<Bool> {
      let viewDidAppearObservable = self.base.rx.viewDidAppear.map { _ in true }
      let viewWillDisappearObservable = self.base.rx.viewWillDisappear.map { _ in false }
      return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
  }

  /// Rx observable, triggered when the ViewController is being dismissed
  var isDismissing: ControlEvent<Bool> {
      let source = self.sentMessage(#selector(Base.dismiss)).map { $0.first as? Bool ?? false }
      return ControlEvent(events: source)
  }

}
