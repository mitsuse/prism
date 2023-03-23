import SwiftUI

public struct PropBinding<Id, Prop, Action, Content>: View where Prop: ObservableObject, Content: View {
    private let viewModel: AnyViewModel<Id, Prop, Action>
    private let buildFunc: (AnyViewModel<Id, Prop, Action>) -> Content

    @ObservedObject private var state: Prop

    public init<VM>(
        _ viewModel: VM,
        @ViewBuilder _ build: @escaping (AnyViewModel<Id, Prop, Action>) -> Content
    ) where VM: ViewModel, VM.Id == Id, VM.Prop == Prop, VM.Action == Action {
        self.viewModel = viewModel.typeErased
        self.state = viewModel.property
        self.buildFunc = build
    }

    public var body: some View { buildFunc(viewModel) }
}
