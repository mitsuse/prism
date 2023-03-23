import SwiftUI

public protocol ViewModel: ObservableObject where Prop: Identifiable {
    associatedtype Prop
    associatedtype Action

    var property: Prop { get }

    func callAsFunction(_ action: Action) async
    func bind(to id: Prop.ID)
}

extension ViewModel {
    public var typeErased: AnyViewModel<Prop, Action> {
        AnyViewModel(self)
    }
}

public final class AnyViewModel<Prop, Action>: ViewModel where Prop: Identifiable {
    private let propertyGetter: () -> Prop
    private let executeMethod: (Action) async -> Void
    private let bindToMethod: (Prop.ID) -> Void

    public var property: Prop {
        propertyGetter()
    }

    public init<VM>(_ viewModel: VM) where VM: ViewModel, VM.Prop == Prop, VM.Action == Action {
        self.propertyGetter = { viewModel.property }
        self.executeMethod = viewModel.callAsFunction
        self.bindToMethod = viewModel.bind
    }

    public func callAsFunction(_ action: Action) async {
        await executeMethod(action)
    }

    public func bind(to id: Prop.ID) {
        self.bindToMethod(id)
    }
}

public final class DummyViewModel<Prop, Action>: ViewModel where Prop: Identifiable {
    public let property: Prop

    public init(property: Prop) {
        self.property = property
    }

    public func callAsFunction(_ action: Action) { debugPrint("action:", action) }
    public func bind(to id: Prop.ID) {}
}
