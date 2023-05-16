import SwiftUI

public protocol ViewModel: ObservableObject {
    associatedtype Prop
    associatedtype Action

    func callAsFunction(_ action: Action) async
    func bind(to prop: Prop)
    func unbind()
}

extension ViewModel {
    public var typeErased: AnyViewModel<Prop, Action> {
        AnyViewModel(self)
    }
}

public final class AnyViewModel<Prop, Action>: ViewModel {
    private let executeMethod: (Action) async -> Void
    private let bindToMethod: (Prop) -> Void
    private let unbindMethod: () -> Void

    public init<VM>(_ viewModel: VM) where VM: ViewModel, VM.Prop == Prop, VM.Action == Action {
        self.executeMethod = viewModel.callAsFunction
        self.bindToMethod = viewModel.bind
        self.unbindMethod = viewModel.unbind
    }

    public func callAsFunction(_ action: Action) async {
        await executeMethod(action)
    }

    public func bind(to prop: Prop) {
        self.bindToMethod(prop)
    }
    
    public func unbind() {
        self.unbindMethod()
    }
}

extension View {
    public func viewModel<VM>(
        _ create: @autoclosure @escaping () -> VM
    ) -> some View where VM: ViewModel, VM: ObservableObject {
        self
            .environmentObject(LazyObject({ create().typeErased }))
    }
}
