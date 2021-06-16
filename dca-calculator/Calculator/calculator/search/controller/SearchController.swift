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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private let service = SearchService()
    private var viewModel: SearchViewModel!
    
    //MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
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
    
    func setupViewModel() {
        viewModel = SearchViewModel(service: service)
    }
    
    //MARK: - Services
    
    func observeForm() {
        guard  let viewModel = viewModel else {
            return
        }
        viewModel.$isLoading.sink { [unowned self] isLoading in
            if isLoading {
                showLoadingAnimation()
            } else {
                hideLoadingAnimation()
            }
        }.store(in: &viewModel.subscribers)
        
        viewModel.$mode.sink { [unowned self] mode in
            switch mode {
            case .onboarding:
                viewModel.results?.items = []
                searchBar.showsCancelButton = false
                tableView.backgroundView = SearchPlaceHolderView()
            case .searching:
                searchBar.showsCancelButton = true
                tableView.backgroundView = nil
            }
        }.store(in: &viewModel.subscribers)
        
        viewModel.$searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { query in
                guard let searchQuery = query, !searchQuery.isEmpty else { return }
                viewModel.searchCompany(keywords: searchQuery)
            }.store(in: &viewModel.subscribers)
        
        viewModel.$results
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] searchResults in
            viewModel.isLoading = false
            tableView.reloadData()
        }.store(in: &viewModel.subscribers)
        
        viewModel.$requestError.sink { requestError in
            guard let error = requestError else { return }
            print(error)
        }.store(in: &viewModel.subscribers)
        
       
        
    }
}


//MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text?.lowercased(), !query.isEmpty else { return }
        viewModel.mode = .searching
        viewModel.searchQuery = query
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.mode = .onboarding
        
    }
}


//MARK: - UITableViewDataSource

extension SearchController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results?.items.count ?? 00
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SEARCH_CELL_ID, for: indexPath) as! SearchCell
        viewModel.result = viewModel.results?.items[indexPath.row]
        cell.viewModel = viewModel
        return cell
    }
}

