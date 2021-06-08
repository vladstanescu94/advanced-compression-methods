import Foundation

public protocol FileServiceProtocol {
    func openFile()
    func writeByteToFile(data: Data) throws
    func readByteFromFile() throws -> Data?
    func closeFile()
}
