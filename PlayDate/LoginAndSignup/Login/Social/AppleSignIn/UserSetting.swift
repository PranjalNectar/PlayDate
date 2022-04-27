

import Foundation
class UserSettings: ObservableObject {
    // 1 = Authorized, -1 = Revoked
    @Published var authorization: Int = 0
    @Published var name: String = ""
}
