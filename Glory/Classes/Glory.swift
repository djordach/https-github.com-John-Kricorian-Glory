//
//  Interactor.swift
//  GloryFramework
//
//  Created by John Kricorian on 30/07/2021.
//

import Foundation

 public protocol GloryDelegate: AnyObject {
    var currentTransaction: Transaction? { get set }
    
    func didStart(transaction: Transaction?)
    func didUpdate(transaction: Transaction?)
    func didSucceed(transaction: Transaction?)
    func didFail(transaction: Transaction?, error: Error)
    func eventError(url: String, hexaErrorCode: String)
    func didUpdate(status: Status)
}

 public class Glory: NSObject {
    
    // MARK: - Public Properties
     public var currentTransaction: Transaction?
     public var currentStatus: Status?
     public var statusCode: StatusCode = .unknown
     public var status: Status = Status(statusCode: .unknown) {
        didSet {
            gloryDelegate?.didUpdate(status: status)
        }
    }

    // MARK: - Private Properties
    private weak var gloryDelegate: GloryDelegate?
    private var user: String = ""
    private var pwd: String = ""
    private var sessionId: String = ""
    private var amount: Int = 0
    private let clientIP: String
    private var lastReceivedMessage: Date?
    private var server: Server?
    private var billDevStatus: DeviceStatus = .state_idle
    private var coinDevStatus: DeviceStatus = .state_idle

    private var error: Error?
    private var emptyMoneyItems: [MoneyItem] = []
    private var isFlaggedStacker = false
    private let service = Service(apiClient: ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default,
                                                                     completionHandlerQueue: OperationQueue.main))
    
     public init(clientIP: String, gloryDelegate: GloryDelegate, user: String, pwd: String) {
        self.clientIP = clientIP
        self.user = user
        self.pwd = pwd
        self.gloryDelegate = gloryDelegate
        super.init()
        
        if statusCode == .notConnected {
            gloryDelegate.didFail(transaction: nil, error: NotConnectedError(statusCode: statusCode, message: statusCode.rawValue))
        }
        
        initOperations(gloryDelegate: gloryDelegate)
    }

    // MARK: - Public Properties
    public var isConnected: Bool  {
        return getConnectedState()
    }

    // MARK: - Public Methods
     public func stopConnection() {
        server?.stopConnection()
    }
    
    public func adjustTime(completionHandler: @escaping AdjustTimeStatusUseCase) {
        let calendarComponent = CalendarComponent(sessionId: sessionId, clientIP: clientIP)
        let request = calendarComponent.adjustTimeRequest
        service.getDataFromXML(tagName: Tag.adjustTime.name, request: request) { result in
            switch result {
            case .success(let nodes):
                guard let nodes = nodes else { return }
                guard let rawValue = nodes.first?.getAttribute("n:result"),
                      let adjustTimeStatus = AdjustTimeStatus(rawValue: rawValue) else { return }
                completionHandler(adjustTimeStatus)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func getStatus(completionHandler: @escaping GetStatusUseCase) {
        let request = GetStatusRequest(sessionId: sessionId, parameter: .status, operation: .status, clientIP: clientIP)
        service.getDataFromXML(tagName: Tag.status.name, request: request) { result in
            switch result {
            case .success(let nodes):
                self.setStatus(nodes: nodes, completionHandler: completionHandler)
            case .failure(let error):
                let status = Status(statusCode: self.statusCode, error: error)
                completionHandler(status)
            }
        }
    }
    
    public func openOperation(user: String, pwd: String, completionHandler: @escaping OpenOperationUseCase) {
        let request = OpenOperationRequest(parameter: .open, operation: .open, clientIP: clientIP, user: user, pwd: pwd)
        service.getDataFromXML(tagName: Tag.open.name, request: request) { result in
            switch result {
            case .success(let nodes):
                guard let node = nodes?.first?.childNodes[3] else { return }
                self.sessionId = node.data
                completionHandler(node.data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func occupyOperation(sessionId: String, completionHandler: OccupyOperationUseCase = nil) {
        let request = OccupyOperationRequest(sessionId: sessionId, parameter: .occupy, operation: .occupy, clientIP: self.clientIP)
        self.service.getDataFromXML(tagName: Tag.occupy.name, request: request) { result in
            switch result {
            case .success(let response):
                let result = self.result(response: response)
                guard let occupyStatus = OccupyStatus(rawValue: result) else { return }
                completionHandler?(occupyStatus)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
        
    public func releaseOperation(sessionId: String, completionHandler: OccupyOperationUseCase = nil) {
        let request = ReleaseOperationRequest(sessionId: sessionId, operation: .release, requestParameter: .release, clientIP: clientIP)
        service.getDataFromXML(tagName: Tag.release.name, request: request) { result in
            switch result {
            case .success(let response):
                let result = self.result(response: response)
                guard let occupyStatus = OccupyStatus(rawValue: result) else { return }
                completionHandler?(occupyStatus)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func closeOperation(sessionId: String, completionHandler: OccupyOperationUseCase = nil) {
        let request = CloseOperationRequest(sessionId: sessionId, operation: .close, requestParameter: .close, clientIP: clientIP)
        service.getDataFromXML(tagName: Tag.close.name, request: request) { result in
            switch result {
            case .success(let response):
                let result = self.result(response: response)
                guard let occupyStatus = OccupyStatus(rawValue: result) else { return }
                completionHandler?(occupyStatus)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func changeOperation(user: String, amount: Int, gloryDelegate: GloryDelegate, completionHandler: @escaping ChangeOperationUseCase) {
        let transaction = Transaction(user: user, amount: amount, manualDeposite: 0, insertedCash: [], sentBackCash: [])
        if statusCode != .waitingInsertionOfCashByChange || statusCode != .counting || statusCode != .waitingRemovalOfCashOut {
            openOperation(user: user, pwd: pwd) { sessionId in
                self.occupyOperation(sessionId: sessionId) { occupyStatus in
                    if occupyStatus != .success && occupyStatus != .occupiedByItself {
                        gloryDelegate.didFail(transaction: nil, error: OccupyStatusError())
                    } else {
                        self.gloryDelegate = gloryDelegate
                        self.currentTransaction = transaction
                        gloryDelegate.didStart(transaction: self.currentTransaction)
                        gloryDelegate.didUpdate(status: self.status)
                        let request = ChangeOperationRequest(sessionId: self.sessionId, amount: String(amount), parameter: .change, operation: .change, clientIP: self.clientIP)
                        self.amount = amount
                        self.service.getDataFromXML(tagName: Tag.change.name, request: request) { result in
                            switch result {
                            case .success(let response):
                                guard let response = response,
                                      let transaction = self.parseTransaction(response: response) else {
                                          let error = FormatError()
                                          gloryDelegate.didFail(transaction: nil, error: error)
                                          return
                                      }
                                completionHandler(transaction)
                                self.parseChangeResponse(response: response, gloryDelegate: gloryDelegate)
                                self.releaseAndClose(sessionId: sessionId)
                            case .failure(let error):
                                gloryDelegate.didFail(transaction: nil, error: error)
                            }
                        }
                    }
                }
            }
        } else {
            gloryDelegate.didFail(transaction: nil, error: ExclusiveError(responseResult: nil, message: nil))
        }
    }
    
    public func changeCancelOperation(completionHandler: ChangeCancelOperationUseCase = nil) {
        occupyOperation(sessionId: self.sessionId) { occupyStatus in
            if occupyStatus != .success && occupyStatus != .occupiedByItself {
                self.gloryDelegate?.didFail(transaction: nil, error: OccupyStatusError())
            } else {
                let request = CancelOperationRequest(sessionId: self.sessionId, operation: .changeCancel, requestParameter: .cancel, clientIP: self.clientIP)
                self.service.getDataFromXML(tagName: Tag.changeCancel.name, request: request) { result in
                    switch result {
                    case .success(let nodes):
                        guard let nodes = nodes,
                              let node = nodes.first(where: { node in return true }),
                              let rawValue = node.getAttribute("n:result"),
                              let occupyStatus = OccupyStatus(rawValue: rawValue) else { return }
                        completionHandler?(occupyStatus)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self.releaseAndClose(sessionId: self.sessionId)
                }
            }
        }
    }
    
    public func registerEventOperation(sessionId: String, completionHandler: RegisterEventOperationUseCase = nil) {
            let request = RegisterEventOperationRequest(sessionId: sessionId, operation: .registerEvent, requestParameter: .registerEvent, destination: .tcp, clientIP: self.clientIP)
            self.service.getDataFromXML(tagName: Tag.registerEvent.name, request: request) { result in
                switch result {
                case .success(let response):
                    let result = self.result(response: response)
                    guard let registerEventStatus = StatusResponse(rawValue: result) else { return }
                    completionHandler?(registerEventStatus)
                    if registerEventStatus == .success {
                        self.startServer(port: UInt16(10000))
                    } else {
                        print("Fail to register events")
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
        
    public func unregisterEventOperation(completionHandler: UnRegisterEventOperationUseCase = nil ) {
        let request = UnRegisterEventOperationRequest(operation: .unregisterEvent, requestParameter: .unregisterEvent, id: "azerty", sessionId: sessionId, clientIP: clientIP)
        service.getDataFromXML(tagName: Tag.unregisterEvent.name, request: request) { result in
            switch result {
            case .success(let response):
                let result = self.result(response: response)
                guard let unRegisterEventStatus = UnRegisterEventStatus(rawValue: result) else { return }
                completionHandler?(unRegisterEventStatus)
                if unRegisterEventStatus == .success {
                    self.stopConnection()
                } else {
                    print("Fail to unregister events")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    public func inventoryOperation(sessionId: String, inventoryOption: String, completionHandler: @escaping InventoryOperationUseCase) {
        let request = InventoryOperationRequest(sessionId: sessionId, operation: .inventory, requestParameter: .inventory, inventoryOption: inventoryOption, clientIP: self.clientIP)
        service.getDataFromXML(tagName: Tag.inventory.name, request: request) { result in
            switch result {
            case .success(let response):
                guard let response = response else { return }
                let moneyItems = self.parseMoneyItems(response, attributePrefix: "n:")
                completionHandler(moneyItems)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func resetOperation(completionHandler: OccupyOperationUseCase = nil) {
        occupyOperation(sessionId: self.sessionId) { occupyStatus in
            let request = ResetOperationRequest(sessionId: self.sessionId, operation: .reset, requestParameter: .reset, clientIP: self.clientIP)
            self.service.getDataFromXML(tagName: Tag.reset.name, request: request) { result in
                switch result {
                case .success(let response):
                    let result = self.result(response: response)
                    guard let occupyStatus = OccupyStatus(rawValue: result) else { return }
                    completionHandler?(occupyStatus)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func openCoverExitOperation(completionHandler: ExitCoverOperationUseCase = nil) {
        let request = OpenExitCoverOperationRequest(sessionId: self.sessionId, operation: .openCoverExit, requestParameter: .openCoverExit, clientIP: self.clientIP)
        self.service.getDataFromXML(tagName: Tag.openCoverExit.name, request: request) { result in
            switch result {
            case .success(let response):
                let result = self.result(response: response)
                guard let exitCoverStatus = ExitCoverStatus(rawValue: result) else { return }
                completionHandler?(exitCoverStatus)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func closeCoverExitOperation(completionHandler: OpenCoverOperationUseCase = nil) {
        let request = CloseExitCoverOperationRequest(sessionId: self.sessionId, operation: .closeCoverExit, requestParameter: .closeCoverExit, clientIP: self.clientIP)
        self.service.getDataFromXML(tagName: Tag.closeCoverExit.name, request: request) { result in
            switch result {
            case .success(let response):
                let result = self.result(response: response)
                guard let occupyStatus = OccupyStatus(rawValue: result) else { return }
                completionHandler?(occupyStatus)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Private Methods
    private func initOperations(gloryDelegate: GloryDelegate) {
        self.openOperation(user: user, pwd: pwd) { sessionId in
            self.occupyOperation(sessionId: sessionId) { occupyStatus in
                if occupyStatus == .success || occupyStatus == .occupiedByItself {
                    self.registerEventOperation(sessionId: sessionId) { _ in
                        self.inventoryOperation(sessionId: sessionId, inventoryOption: "2") { moneyItems in
                            self.adjustTime { adjustTimeStatus in
                                if adjustTimeStatus == .success {
                                    self.getStatus { status in
                                        self.statusCode = status.statusCode
                                        self.emptyMoneyItems = self.filterEmptyMoneyItems(moneyItems)
                                        self.status = Status(statusCode: self.statusCode, emptyMoneyItems: self.emptyMoneyItems, isFlaggedStatus: self.isFlaggedStacker)
                                        self.releaseOperation(sessionId: sessionId) { occupyStatus in
                                            if occupyStatus == .success || occupyStatus == .occupiedByItself {
                                                self.closeOperation(sessionId: sessionId)
                                            } else {
                                                gloryDelegate.didFail(transaction: nil, error: ReleaseError())
                                            }
                                        }
                                    }
                                } else {
                                    gloryDelegate.didFail(transaction: nil, error: AdjustTimeError())
                                }
                            }
                        }
                    }
                } else {
                    gloryDelegate.didFail(transaction: nil, error: OccupyStatusError())
                }
            }
        }
    }
    
    private func result(response: [XMLNode]?) -> String {
        guard let result = response?.first?.attributes["n:result"] else { return "" }
        return result
    }
    
    private func parseTransaction(response: [XMLNode]) -> Transaction? {
        guard let node = response.first, let manualDeposit = node.getElementsByTagName("n:ManualDeposit").first?.data else { return nil}
        currentTransaction?.manualDeposit = manualDeposit.toInt()
        for node in node.getElementsByTagName("Cash") {
            if node.attributes["n:type"] == "1" {
                currentTransaction?.insertedCash = parseDepositNodes(nodes: node.childNodes, attributePrefix: "n:")
            } else if node.attributes["n:type"] == "2" {
                currentTransaction?.sentBackCash = parseDepositNodes(nodes: node.childNodes, attributePrefix: "n:")
            }
        }
        return currentTransaction
    }
    
    private func updateInsertedCash(nodes: [XMLNode]) {
        currentTransaction?.insertedCash = parseDepositNodes(nodes: nodes)
        gloryDelegate?.didUpdate(transaction: currentTransaction)
    }
        
    private func releaseAndClose(sessionId: String) {
        releaseOperation(sessionId: sessionId) { _ in
            self.closeOperation(sessionId: sessionId) { _ in
                self.currentTransaction = nil
            }
        }
    }
    
    private func parseDepositNodes(nodes: [XMLNode], attributePrefix: String = "") -> [Cash] {
        var cashList: [Cash] = []
        for node in nodes {
            guard let currency = node.getAttribute("\(attributePrefix)cc"),
                  let facialValue = node.getAttribute("\(attributePrefix)fv"),
                  let piece = node.getElementsByTagName("Piece").first?.data else { return [] }
            let cash = Cash(piece: Int(piece) ?? 0, facialValue: facialValue, currency: currency)
            cashList.append(cash)
        }
        return cashList
    }
    
    private func startServer(port: UInt16) {
        server = Server(port: port)
        server?.delegate = self
        do {
            try server?.start()
        } catch let error {
            print(error)
        }
    }
        
    private func getConnectedState() -> Bool {
        guard let lastReceivedMessage = lastReceivedMessage,
              let dateAddedByOneMinute = Calendar.current.date(byAdding: .minute, value: +1, to: lastReceivedMessage) else { return false }
        return Date() < dateAddedByOneMinute
    }
    
    private func manageReceivedData(message: String, data: Data) {
        if let node = XMLCustomParser().parseData(data: data) {
            guard !node.childNodes[0].childNodes.isEmpty else { return }
            guard let rawValue = node.childNodes[safe:0]?.tag,
                  let event = Event(rawValue: rawValue) else { return }
            switch event {
            case .statusChangeEvent:
                guard let rawValue = node.childNodes[safe:0]?.childNodes[safe:0]?.data,
                      let statusCode = StatusCode(rawValue: rawValue) else { return }
                self.statusCode = statusCode
                status = Status(statusCode: statusCode, emptyMoneyItems: emptyMoneyItems)
            case .statusResponse:
                updateFlaggedStackers(node: node)
                updateDevicesStatus(node: node)
            case .inventoryResponse:
                emptyMoneyItems = filterEmptyMoneyItems(parseMoneyItems(node.childNodes))
                status = Status(statusCode: self.statusCode, emptyMoneyItems: emptyMoneyItems, isFlaggedStatus: isFlaggedStacker)
            case .glyCashierEvent:
                guard let rawValue = node.childNodes[safe:0]?.childNodes[safe:0]?.tag else { return }
                let glyCashierEvent = GlyCashierEvent(rawValue: rawValue)
                switch glyCashierEvent {
                case .eventRequireVerifyDenomination:
                    if let childNodes = node.childNodes[safe:0]?.childNodes[safe:0]?.childNodes[safe:0]?.childNodes {
                        if childNodes.isEmpty {
                            isFlaggedStacker = false
                        } else {
                            isFlaggedStacker = true
                        }
                    }
                case .eventDepositCountChange:
                    guard let nodes = XMLCustomParser().getElementsByTagName(data: data, tagName: "Denomination"), !nodes.isEmpty else { return }
                    updateInsertedCash(nodes: nodes)
                case .eventError:
                    guard let node = node.childNodes[safe:0],
                          let errorCode = node.getElementsByTagName("ErrorCode")[safe:0]?.data,
                          let url = node.getElementsByTagName("RecoveryURL")[safe:0]?.data else { return }
                    gloryDelegate?.eventError(url: url, hexaErrorCode: String(format:"%02X", errorCode))
                case .eventOpened:
                    self.updateDoorId(node: node, glyCashierEvent: glyCashierEvent)
                case .eventClosed:
                    self.updateDoorId(node: node, glyCashierEvent: glyCashierEvent)
                }
            case .incompleteTransaction:
                guard let committedInventoryNodes = node.childNodes[safe:0]?.childNodes[safe:5]?.childNodes[safe:0]?.childNodes,
                      let currentInventoryNodes = node.childNodes[safe:0]?.childNodes[safe:6]?.childNodes[safe:0]?.childNodes else { return }
                let insertedCashAmount = self.computeInventoryDelta(committedInventoryNodes: committedInventoryNodes, currentInventoryNodes: currentInventoryNodes)
                currentTransaction?.insertedCashAmount = insertedCashAmount
                currentTransaction?.sentBackCash = []
                gloryDelegate?.didFail(transaction: currentTransaction, error: IncompleteTransactionError())
            }
        }
    }
        
    private func filterEmptyMoneyItems(_ moneyItems: [MoneyItem]) -> [MoneyItem] {
        return moneyItems
            .filter { $0.status == .nearEmpty || $0.status == .empty }
    }
    
    private func computeInventoryDelta(committedInventoryNodes: [XMLNode], currentInventoryNodes: [XMLNode]) -> Int {
        let committedStackers = parseDepositNodes(nodes: committedInventoryNodes)
        let currentStackers = parseDepositNodes(nodes: currentInventoryNodes)
        var currentInventoryOutput = 0
        var commitedInventoryOutput = 0
        currentStackers.forEach { currentInventoryOutput += $0.facialValue * $0.piece }
        committedStackers.forEach { commitedInventoryOutput += $0.facialValue * $0.piece }

        return currentInventoryOutput - commitedInventoryOutput
    }
    
    private func parseMoneyItems(_ moneyItemResponse: [XMLNode], attributePrefix: String = "") -> [MoneyItem]  {
        guard let childNodes = moneyItemResponse[safe:0]?.getElementsByTagName("Cash")[safe:0]?.getElementsByTagName("Denomination") else { return [] }
        var moneyItems: [MoneyItem] = []
        for childNode in childNodes {
            guard let facialValue = childNode.attributes["\(attributePrefix)fv"]?.format(),
                  let devid = childNode.attributes["\(attributePrefix)devid"],
                  let currency = childNode.attributes["\(attributePrefix)cc"],
                  let piece = childNode.childNodes[safe:0]?.data,
                  let rawValue = childNode.childNodes[safe:1]?.data,
                  let status = InventoryStatus(rawValue: rawValue) else { return [] }
            let item = MoneyItem(facialValue: facialValue, devid: devid, currency: currency, piece: piece, status: status)
            moneyItems.append(item)
        }
        return moneyItems
    }
        
    private func setStatus(nodes: [XMLNode]?, completionHandler: @escaping GetStatusUseCase) {
        guard let rawValue = nodes?.first?.childNodes.first?.data,
              let statusCode = StatusCode(rawValue: rawValue),
              let billRawValue = nodes?.first?.getElementsByTagName("DevStatus")[safe:0]?.getAttribute("n:st"),
              let coinRawValue = nodes?.first?.getElementsByTagName("DevStatus")[safe:1]?.getAttribute("n:st"),
              let billDevStatus = DeviceStatus(rawValue: billRawValue),
              let coinDevStatus = DeviceStatus(rawValue: coinRawValue) else { return }
        self.billDevStatus = billDevStatus
        self.coinDevStatus = coinDevStatus
        if billDevStatus == .state_idle && coinDevStatus == .state_idle {
            let status = Status(statusCode: statusCode, billDevStatus: billDevStatus, coinDevStatus: coinDevStatus)
            completionHandler(status)
        } else {
            let status = Status(statusCode: .inoperative_Cash_Recycler, billDevStatus: billDevStatus, coinDevStatus: coinDevStatus)
            completionHandler(status)
        }
    }
    
    private func updateDoorId(node: XMLNode, glyCashierEvent: GlyCashierEvent) {
        guard let rawValue = node.childNodes[safe:0]?.getAttribute("devid"),
              let devId = DevId(rawValue: rawValue) else { return }
        switch devId {
        case .bill:
            if glyCashierEvent == .eventClosed {
                billDevStatus = .state_idle
            } else if glyCashierEvent == .eventOpened {
                billDevStatus = .state_busy
            }
        case .coin:
            if glyCashierEvent == .eventClosed {
                coinDevStatus = .state_idle
            } else if glyCashierEvent == .eventOpened {
                coinDevStatus = .state_busy
            }
        }
        if billDevStatus == .state_idle && coinDevStatus == .state_idle {
            statusCode = .idle
        } else {
            statusCode = .inoperative_Cash_Recycler
        }
        self.status = Status(statusCode: statusCode, billDevStatus: billDevStatus, coinDevStatus: coinDevStatus, emptyMoneyItems: status.emptyMoneyItems, error: nil)
    }
    
    private func parseChangeResponse(response: [XMLNode], gloryDelegate: GloryDelegate) {
        guard let rawValue = response[safe:0]?.getAttribute("n:result"),
                let responseResult = ResponseResult(rawValue: rawValue) else {
                    let error = FormatError()
                    gloryDelegate.didFail(transaction: nil, error: error)
                    return
                }
        switch responseResult {
        case .success:
            gloryDelegate.didSucceed(transaction: currentTransaction)
        case .cancel:
            gloryDelegate.didSucceed(transaction: currentTransaction)
        case .cancelChangeShortage:
            gloryDelegate.didSucceed(transaction: currentTransaction)
        default: break
        }
        currentTransaction = nil
    }
        
    private func updateDevicesStatus(node: XMLNode) {
        guard let billRawValue = node.childNodes[0].childNodes[3].childNodes[1].getAttribute("st"),
              let billDevStatus = DeviceStatus(rawValue: billRawValue),
              let coinRawValue = node.childNodes[0].childNodes[3].childNodes[2].getAttribute("st"),
              let coinDevStatus = DeviceStatus(rawValue: coinRawValue) else { return }
        self.billDevStatus = billDevStatus
        self.coinDevStatus = coinDevStatus
    }
    
    private func updateFlaggedStackers(node: XMLNode) { 
        for node in node.childNodes[0].getElementsByTagName("RequireVerifyDenomination") {
            if node.attributes["val"] == "1" {
                isFlaggedStacker = true
            }
        }
        status = Status(statusCode: statusCode, emptyMoneyItems: emptyMoneyItems, isFlaggedStatus: isFlaggedStacker)
    }
}


// MARK: - ServerDelegate
extension Glory: ServerDelegate {
    func stop(id: Int) {
        print("connection \(id) will stop")
    }

    func send(_ data: Data) {
        lastReceivedMessage = Date()
        guard let message = String(data: data, encoding: .utf8) else { return }
        print("string: \(message)")
        manageReceivedData(message: message, data: data)
    }
}


