//
//  VehicleListViewController.swift
//  FreeNowMvvm
//
//  Created by Systems Limited on 19/12/2020.
//

import UIKit
import Combine
import UICommon
class VehicleListViewController: UIViewController {

    private var cancellables: [AnyCancellable] = []
    @IBOutlet private var tableView: UITableView!
    private let viewModel: VehicleListViewModelType
    private lazy var dataSource = makeDataSource()
    private let appear = PassthroughSubject<(p2Lat: Double, p1Lon: Double, p1Lat: Double, p2Lon: Double), Never>()
    private let selection = PassthroughSubject<Void, Never>()
    private let search = PassthroughSubject<(p2Lat: Double, p1Lon: Double, p1Lat: Double, p2Lon: Double), Never>()
    init(viewModel: VehicleListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
        bind(to: viewModel)
        appear.send((53.394655, 9.757589, 53.694865, 10.099891))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        search.send("")
    }
    @objc func showMapScreen() {
        selection.send()
    }
    private func configureUI() {
        definesPresentationContext = true
        title = "Vehicles"
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "MAP", style: .plain, target: self, action: #selector(showMapScreen)), animated: true)
        
        ProgressHUD.fontStatus = .systemFont(ofSize: 15)
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .systemBlue
    
        tableView.register(VehicleCell.nib(), forCellReuseIdentifier: VehicleCell.identifier())
        tableView.dataSource = dataSource
        
    }
    private func bind(to viewModel: VehicleListViewModelType) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = VehicleListViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               search: search.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }
    private func render(_ state: VehicleListState) {
        switch state {
        case .idle:
            update(with: [], animate: true)
        case .loading:
            ProgressHUD.show("Loading...")
            update(with: [], animate: true)
        case .noResults:
            ProgressHUD.dismiss()
            update(with: [], animate: true)
        case .failure:
            ProgressHUD.dismiss()
            update(with: [], animate: true)
        case .success(let vehicles):
            ProgressHUD.dismiss()
            update(with: vehicles, animate: true)
        }
    }

}
fileprivate extension VehicleListViewController {
    enum Section: CaseIterable {
        case vehicles
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, VehicleViewModel> {
        return UITableViewDiffableDataSource(
            tableView: self.tableView,
            cellProvider: {  tableView, indexPath, vehicleViewModel in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleCell.identifier()) as? VehicleCell
                 //guard let cell = tableView.dequeueReusableCell(withClass: VehicleCell.self)
                 else {
                    assertionFailure("Failed to dequeue \(VehicleCell.self)!")
                    return UITableViewCell()
                }
                cell.bind(to: vehicleViewModel)
                return cell
            }
        )
    }

    func update(with vehicles: [VehicleViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, VehicleViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(vehicles, toSection: .vehicles)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}
extension VehicleListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        //selection.send(snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
