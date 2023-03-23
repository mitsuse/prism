import SwiftUI

public struct PropBinding<Prop, Action, Content>: View where Prop: ObservableObject & Identifiable, Content: View {
    private let viewModel: AnyViewModel<Prop, Action>
    private let buildFunc: (AnyViewModel<Prop, Action>) -> Content

    @ObservedObject private var state: Prop

    public init<VM>(
        _ viewModel: VM,
        @ViewBuilder _ build: @escaping (AnyViewModel<Prop, Action>) -> Content
    ) where VM: ViewModel, VM.Prop == Prop, VM.Action == Action {
        self.viewModel = viewModel.typeErased
        self.state = viewModel.property
        self.buildFunc = build
    }

    public var body: some View { buildFunc(viewModel) }
}
