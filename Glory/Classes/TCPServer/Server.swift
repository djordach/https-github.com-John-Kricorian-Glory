import Foundation
import Network

protocol ServerDelegate: AnyObject {
    func send(_ data: Data)
    func stop(id: Int)
}

internal class Server {
    let port: NWEndpoint.Port
    let listener: NWListener
    var delegate: ServerDelegate?
    
    private var connectionsByID: [Int: ServerConnection] = [:]
    
    public init(port: UInt16) {
        self.port = NWEndpoint.Port(rawValue: port)!
        listener = try! NWListener(using: .tcp, on: self.port)
    }
    
    public func start() throws {
        print("Server starting...")
        listener.stateUpdateHandler = self.stateDidChange(to:)
        listener.newConnectionHandler = self.didAccept(nwConnection:)
        listener.start(queue: .main)
    }
    
    func stateDidChange(to newState: NWListener.State) {
        switch newState {
        case .ready:
          print("Server ready.")
        case .failed(let error):
            print("Server failure, error: \(error.localizedDescription)")
            exit(EXIT_FAILURE)
        default:
            break
        }
    }
    
    private func didAccept(nwConnection: NWConnection) {
        let connection = ServerConnection(nwConnection: nwConnection)
        connection.delegate = self
        self.connectionsByID[connection.id] = connection
        connection.didStopCallback = { _ in
            self.connectionDidStop(connection)
        }
        connection.start()
//        connection.send(data: "Welcome you are connection: \(connection.id)".data(using: .utf8)!)
        print("server did open connection \(connection.id)")
    }
    
    private func connectionDidStop(_ connection: ServerConnection) {
        self.connectionsByID.removeValue(forKey: connection.id)
        print("server did close connection \(connection.id)")
    }
    
    func stopConnection() {
        self.listener.stateUpdateHandler = nil
        self.listener.newConnectionHandler = nil
        self.listener.cancel()
        for connection in self.connectionsByID.values {
            connection.didStopCallback = nil
            connection.connectionDidEnd()
        }
        self.connectionsByID.removeAll()
        
    }
}

extension Server: ServerConnectionDelegate {
    func send(_ data: Data) {
        delegate?.send(data)
    }
    
    func stop(id: Int) {
        print("connection \(id) will stop")
    }
}

