//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Erik Kamalov <ekamalov967@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

final public class CountryViewController: UIViewController {
    // MARK: - Properties
    private lazy var momentumView: UIView = .build {
        $0.backgroundColor = preferences.momentView.backgroundColor
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = preferences.momentView.cornerRadius
    }
    
    lazy var tableView:UITableView = .build { tableView in
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = .build {
        $0.delegate = self
        $0.addTarget(self, action: #selector(handleGesture(_:)))
    }
    
    // MARK:  Appearance
    private var preferences: Preferences.CountryView
    private var wrapperViewHeader: CountryWrapperHeader
    
    // MARK: - Animation
    private var animator = UIViewPropertyAnimator()
    private var animationProgress: CGFloat = 0
    private var closedTransform: CGAffineTransform = .identity
    private var keyboardVisible: Bool = false
    
    // MARK: - DataSource
    private var countries:[(key: String, value: [Country])] = [] { didSet { tableView.reloadData() }}
    private var selected:(_ item: Country) -> Void?
    
    // MARK: - Initializers
    init(preferences: Preferences.CountryView, selected: @escaping (_ item: Country) -> Void) {
        self.preferences = preferences
        self.selected = selected
        self.wrapperViewHeader = .init(preferences: self.preferences.tableView.header)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        // FIXME: add support dark mode
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        wrapperViewHeader.searchTextField.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        
        self.countries = CountryService.shared.countriesByRelated(related: preferences.relatedCountries)
        
        view.addSubviews(momentumView)
        momentumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: preferences.momentView.padding).isActive = true
        momentumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -preferences.momentView.padding).isActive = true
        momentumView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10).isActive = true
        momentumView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.2).isActive = true
        
        closedTransform = CGAffineTransform(translationX: 0, y: view.bounds.height * 0.8)
        momentumView.transform = closedTransform
        
    }
    public override func viewWillAppear(_ animated: Bool) {
        startAnimationIfNeeded(show: true) {
            self.momentumView.addGestureRecognizer(self.panGestureRecognizer)
            self.tableView.panGestureRecognizer.require(toFail: self.panGestureRecognizer)
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewDidLayoutSubviews() {
        wrapperViewHeader.frame = .init(x: 0, y: 0, width: momentumView.frame.width, height: 150)
        
        tableView.frame.origin = .init(x: preferences.contentMargin, y: wrapperViewHeader.frame.maxY)
        tableView.frame.size = .init(width: momentumView.frame.width - (preferences.contentMargin * 2), height: momentumView.frame.height - tableView.frame.maxY)
        
        momentumView.addSubviews(wrapperViewHeader,tableView)
    }
    
    @objc private func handleGesture(_ recognizer: UIPanGestureRecognizer) {
        if keyboardVisible {
            view.endEditing(true)
            return
        }
        switch recognizer.state {
        case .began:
            startAnimationIfNeeded(show: false) { self.animator.isReversed.toggle() }
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
            self.wrapperViewHeader.dropDownIcon.image = UIImage(named: "arrowLine", in: Bundle.resource, compatibleWith: nil)
        case .changed:
            var fraction = recognizer.translation(in: momentumView).y / closedTransform.ty
            if animator.isReversed { fraction *= -1 }
            animator.fractionComplete = fraction + animationProgress
        case .ended, .cancelled:
            let yVelocity = recognizer.velocity(in: momentumView).y
            if !(yVelocity > 0) && !animator.isReversed {
                animator.isReversed.toggle()
            }
            if !animator.isReversed {
                animator.addCompletion { _ in self.dismiss(animated: false, completion: nil) }
            }
            self.wrapperViewHeader.dropDownIcon.image = self.preferences.tableView.header.dropDownIcon
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0.8)
        default: break
        }
    }
    
    // FIXME: fix this method
    private func startAnimationIfNeeded(show:Bool, duration:Double = 0.7, _ completion: (() -> Void)? = nil) {
        if animator.isRunning { return }
        animator = .init(duration: duration, dampingRatio: 0.85)
        animator.addAnimations {
            self.momentumView.transform = !show ? self.closedTransform : .identity
            self.view.backgroundColor = !show ? .clear : UIColor.black.withAlphaComponent(0.8)
        }
        
        animator.addCompletion { _ in completion?() }
        animator.startAnimation()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CountryViewController:UIGestureRecognizerDelegate {
  
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        if self.tableView.contentOffset.y == 0.0 {
            return gestureRecognizer.velocity(in: gestureRecognizer.view!).y > 0
        }
        return self.tableView.contentOffset.y < 0.0
    }
}

// MARK: - TableView datasource and prepareData
extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
   
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.removeObserver(self)
        view.endEditing(true)
        Haptic.selection.impact()
        self.selected(self.countries[indexPath.section].value[indexPath.row])
        self.startAnimationIfNeeded(show: false,duration: 1.2) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries[section].value.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.countries.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        let country = self.countries[indexPath.section].value[indexPath.row]
        cell.update(country, preferences: self.preferences.tableView.cell)
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return preferences.tableView.cell.height
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return preferences.tableView.sectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let title:UILabel = .build {
            $0.text = self.countries[section].key
            $0.font = preferences.tableView.header.font
            $0.textColor = preferences.tableView.header.textColor
            $0.frame.origin = .init(x: 0, y: 30 - (preferences.tableView.header.searchBar.font.lineHeight / 2))
            $0.sizeToFit()
        }
        view.backgroundColor = .white
        let seperatorLine:UIView = .build {
            $0.frame = .init(x: 0, y: preferences.tableView.sectionHeaderHeight - 1, width: tableView.bounds.width, height: 1)
            $0.backgroundColor = preferences.tableView.header.seperatorLineColor
        }
        view.addSubviews(title,seperatorLine)
        return view
    }
}

// MARK: - Keyboard notification & searchTextField delegate
extension CountryViewController: UITextFieldDelegate {
   
    @objc func textFieldTextDidChange(_ textField: UITextField){
        self.countries = CountryService.shared.search(textField.text ?? "")
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            self.momentumView.transform = .identity
            self.keyboardVisible = false
        } else {
            self.keyboardVisible = true
            self.momentumView.transform = .init(translationX: 0, y: -80)
        }
    }
}
