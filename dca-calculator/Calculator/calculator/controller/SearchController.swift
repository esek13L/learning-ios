//
//  SearchController.swift
//  calculator
//
//  Created by Esekiel Surbakti on 05/06/21.
//

import UIKit
import Combine
import core

private let SEARCH_CELL_ID = "searchCell"

public class SearchController: UIViewController, UIAnimatable {
    
    //MARK: - Properties
    
    private enum Mode {
        case onboarding
        case search
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let searchService = SearchService()
    private var subscribers = Set<AnyCancellable>()
    @Published  private var searchQuery = String()
    private var searchResults: SearchResults? {
        didSet { tableView.reloadData() }
    }
    @Published private var mode: Mode = .onboarding
    
    //MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeForm()
    }
    
    //MARK: - Helpers
    
    func setupView() {
        navigationItem.title = "Search"
        
        searchBar.placeholder = "Enter a company name or symbol"
        searchBar.autocapitalizationType = .allCharacters
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: "SearchCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: SEARCH_CELL_ID)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
    }
    
    //MARK: - Services
    
    func observeForm() {
        
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (query) in
                guard !searchQuery.isEmpty else { return }
                showLoadingAnimation()
                self.searchService.fetchSymbolsPublisher(keywords: query).sink { (completion) in
                    hideLoadingAnimation()
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .finished:
                        break
                    }
                } receiveValue: { (searchResults) in
                    self.searchResults = searchResults
                }.store(in: &subscribers)
            }.store(in: &subscribers)
        
        $mode.sink { [unowned self](mode) in
            switch mode {
            case .onboarding:
                self.searchBar.showsCancelButton = false
                self.tableView.backgroundView = SearchPlaceHolderView()
            case .search:
                self.searchBar.showsCancelButton = true
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
}

//MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text?.lowercased(), !query.isEmpty else { return }
        mode = .search
        searchQuery = query
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        mode = .onboarding
    }
}


//MARK: - UITableViewDataSource

extension SearchController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SEARCH_CELL_ID, for: indexPath) as! SearchCell
        if let results = searchResults {
            cell.configure(with: results.items[indexPath.row])
        }
        return cell
    }
}
