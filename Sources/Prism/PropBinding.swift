import SwiftUI

public struct PropBinding<Prop, Action, Content>: View where Prop: ObservableObject, Content: View {
    private let buildFunc: (AnyViewModel<Prop, Action>) -> Content

    @ObservedObject private var prop: Prop
    @EnvironmentObject private var viewModel: LazyObject<AnyViewModel<Prop, Action>>

    public init(
        _: Action.Type,
        _ prop: Prop,
        @ViewBuilder _ build: @escaping (AnyViewModel<Prop, Action>) -> Content
    ) {
        self.prop = prop
        self.buildFunc = build
    }

    public var body: some View {
        buildFunc(viewModel.value)
            .onAppear { [weak viewModel] in
                guard let vm = viewModel?.value else { return }
                vm.bind(to: prop)
            }
            .onDisappear { [weak viewModel] in
                guard let vm = viewModel?.value else { return }
                vm.unbind()
            }
    }
}

public protocol PropBindable {
    associatedtype Action
    associatedtype Prop: ObservableObject
    associatedtype Content
    
    var prop: Prop { get }

    func bind(to viewModel: AnyViewModel<Prop, Action>) -> Content
}

extension View where Self: PropBindable, Self.Content: View {
    public var body: some View {
        PropBinding(Action.self, prop, bind)
    }
}
