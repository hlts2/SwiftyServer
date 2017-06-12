import Foundation

public enum SocketError: Error {
    case socketCreateError
    case bindError
    case listenError
    case acceptError
}
