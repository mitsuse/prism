import SwiftUI

public protocol ViewModel: ObservableObject where Property: Identifiable {
    associatedtype Property
    associatedtype Action

    var property: Property { get }

    func callAsFunction(_ action: Action)
    func bind(to id: Property.ID)
}

extension ViewModel {
    public var typeErased: AnyViewModel<Property, Action> {
        AnyViewModel(self)
    }
}

public final class AnyViewModel<Property, Action>: ViewModel where Property: Identifiable {
    private let propertyGetter: () -> Property
    private let executeMethod: (Action) -> Void
    private let bindToMethod: (Property.ID) -> Void

    public var property: Property {
        propertyGetter()
    }

    public init<VM>(_ viewModel: VM) where VM: ViewModel, VM.Property == Property, VM.Action == Action {
        self.propertyGetter = { viewModel.property }
        self.executeMethod = viewModel.callAsFunction
        self.bindToMethod = viewModel.bind
    }

    public func callAsFunction(_ action: Action) {
        executeMethod(action)
    }

    public func bind(to id: Property.ID) {
        self.bindToMethod(id)
    }
}

public final class DummyViewModel<Property, Action>: ViewModel where Property: Identifiable {
    public let property: Property

    public init(property: Property) {
        self.property = property
    }

    public func callAsFunction(_ action: Action) { debugPrint("action:", action) }
    public func bind(to id: Property.ID) {}
}
