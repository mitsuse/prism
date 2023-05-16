import SwiftUI

import Dispatch

final class LazyObject<Value>: ObservableObject {
    private let semaphore = DispatchSemaphore(value: 1)

    private let create: () -> Value

    private(set) lazy var value: Value = { [unowned self] in
        self.semaphore.wait(); defer { self.semaphore.signal() }
        return self.create()
    }()

    init(_ create: @escaping () -> Value) {
        self.create = create
    }
}
