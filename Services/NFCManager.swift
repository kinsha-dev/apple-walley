
import Foundation

#if canImport(CoreNFC)
import CoreNFC

class NFCManager: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    var session: NFCNDEFReaderSession?
    @Published var scannedData: String? // New published property

    func beginScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC is not available on this device")
            return
        }

        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near the card to scan."
        session?.begin()
    }

    // MARK: - NFCNDEFReaderSessionDelegate

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Handle errors
        print("The session was invalidated: \(error.localizedDescription)")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Handle successful scans
        var result = ""
        for payload in messages[0].records {
            result += String(data: payload.payload, encoding: .utf8) ?? ""
        }
        DispatchQueue.main.async {
            self.scannedData = result // Update the published property
        }
    }
}
#else
class NFCManager: ObservableObject {
    @Published var scannedData: String?

    func beginScanning() {
        print("NFC is not supported on this platform.")
        self.scannedData = "NFC Not Supported"
    }
}
#endif
