//
//  MainViewController.swift
//  Fetchr-App-Assignment
//
//  Created by Hashaam Siddiq on 8/5/17.
//  Copyright © 2017 Hashaam. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedPickerViewIndex = 0
    
    var refreshTimer: Timer!
    
    var times = [
        30, 300, 900, 0
    ]
    
    var timeInSeconds = 0
    
    var viewModel: MainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MainViewModel(updateViewHandler: { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success:
                strongSelf.tableView.reloadData()
                
            case .failure(let error):
                if let error = error {
                    strongSelf.handle(error: error)
                }
                
            }
            
        })
        
        setupTableView()
        
        setupNavigationItems()
        
        searchPreviousString()
        
    }
    
    func setupTableView() {
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func setupNavigationItems() {
        
        let rightBarButtonItem = UIBarButtonItem(title: "\u{2699}\u{0000FE0E}", style: .plain, target: self, action: #selector(settingsButtonHandler(btn:)))
        rightBarButtonItem.setTitleTextAttributes([
            NSFontAttributeName: UIFont.systemFont(ofSize: 28.0)
            ], for: .normal)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func searchPreviousString() {
        
        guard let searchString = UserDefaults.standard.string(forKey: USER_DEFAULTS_SEARCH_STRING_KEY) else { return }
        guard searchString.characters.count > 0 else { return }
        
        searchBar.text = searchString
        
        searchFromSearchBarText()
        
    }
    
    func setupTimer() {

        let timeInterval = TimeInterval(times[selectedPickerViewIndex])
        refreshTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] timer in
            
            guard let strongSelf = self else { return }
            
            strongSelf.viewModel.search()
            
        })
        
    }
    
    deinit {
        refreshTimer.invalidate()
    }
    
    func settingsButtonHandler(btn: UIBarButtonItem) {
        
        performSegue(withIdentifier: "Show Picker View", sender: self)
        
    }
    
    func updateView() {
        
        tableView.reloadData()
        
    }
    
    func setColorFor(attributedString: NSMutableAttributedString, color: UIColor, indexStart: Int, indexEnd: Int) {
        
        attributedString.addAttribute(
            NSForegroundColorAttributeName,
            value: color,
            range: NSMakeRange(indexStart, indexEnd - indexStart)
        )
        
    }
    
    func configure(cell: StatusCell, atIndex index: Int) {
        
        guard let status = viewModel.statusAt(index) else { return }
        
        let statusText = status.text ?? ""
        let attributedString = NSMutableAttributedString(string: statusText)
        
        let hashTags = status.hashTags ?? []
        hashTags.forEach { hashTag in
            
            let indexStart = hashTag.indexStart ?? 0
            let indexEnd = hashTag.indexEnd ?? 0
            
            setColorFor(attributedString: attributedString, color: .orange, indexStart: indexStart, indexEnd: indexEnd)
            
        }
        
        let userMentions = status.userMentions ?? []
        userMentions.forEach { userMention in
            
            let indexStart = userMention.indexStart ?? 0
            let indexEnd = userMention.indexEnd ?? 0
            
            setColorFor(attributedString: attributedString, color: .blue, indexStart: indexStart, indexEnd: indexEnd)
            
        }
        
        cell.statusLabel.attributedText = attributedString
        
    }
    
    func setSearchTextAndPerformSearch(_ text: String) {
        
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height ?? 0.0
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        
        let adjustingHeight = navigationBarHeight + statusBarHeight
        tableView.setContentOffset(CGPoint(x: 0.0, y: -adjustingHeight), animated: true)
        
        searchBar.text = text
        
        searchFromSearchBarText()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Picker View" {
            
            guard let navigationController = segue.destination as? UINavigationController else { return }
            guard let pickerViewController = navigationController.topViewController as? PickerViewController else { return }
            pickerViewController.delegate = self
            pickerViewController.selectedRowIndex = selectedPickerViewIndex
            
        }
        
    }
    
    func handle(error: Error) {
        
        let alertController = UIAlertController(
            title: "Error Occured", message: "Failed to search. Please try again later.", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(
            title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func searchFromSearchBarText() {
        
        if refreshTimer != nil {
            refreshTimer.invalidate()
        }
        
        let searchString = searchBar.text ?? ""
        
        UserDefaults.standard.set(searchString, forKey: USER_DEFAULTS_SEARCH_STRING_KEY)
        
        viewModel.searchString = searchString
        
        viewModel.search()
        
        setupTimer()
        
    }

}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchFromSearchBarText()
        
        searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
}

extension MainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.statusesCount
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Status Cell", for: indexPath) as! StatusCell
        
        configure(cell: cell, atIndex: indexPath.row)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let status = viewModel.statusAt(indexPath.row) else { return }
        guard status.isSearchable else { return }
        
        let hashTags = status.hashTags ?? []
        let userMentions = status.userMentions ?? []
        
        let alertController = UIAlertController(title: "Search", message: "Select one of the following hashtag or user mention", preferredStyle: .actionSheet)
        
        hashTags.forEach { hashTag in
            
            let hashTagText = "#\(hashTag.text ?? "")"
            
            alertController.addAction(
                UIAlertAction(title: hashTagText, style: .default, handler: { [weak self] action in
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.dismiss(animated: true, completion: nil)
                    
                    strongSelf.setSearchTextAndPerformSearch(hashTagText)

                })
            )
            
        }
        
        userMentions.forEach { userMention in
            
            let userMentionText = "@\(userMention.text ?? "")"
            
            alertController.addAction(
                UIAlertAction(title: userMentionText, style: .default, handler: { [weak self] action in
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.dismiss(animated: true, completion: nil)
                    
                    strongSelf.setSearchTextAndPerformSearch(userMentionText)
                    
                })
            )
            
        }
        
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.present(alertController, animated: true, completion: nil)
        }
        
    }
    
}

extension MainViewController: PickerViewDelegate {
    
    func didSelectRowAt(_ index: Int) {
        
        selectedPickerViewIndex = index
        
        refreshTimer.invalidate()
        
        if times[selectedPickerViewIndex] != 0 {
            setupTimer()
        }
        
    }
    
}
