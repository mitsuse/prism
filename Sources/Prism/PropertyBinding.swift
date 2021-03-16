import SwiftUI

public struct PropertyBinding<Property, Action, Content>: View where Property: ObservableObject & Identifiable, Content: View {
    private let viewModel: AnyViewModel<Property, Action>
    private let buildFunc: (AnyViewModel<Property, Action>) -> Content

    @ObservedObject private var state: Property

    public init<VM>(
        _ viewModel: VM,
        @ViewBuilder _ build: @escaping (AnyViewModel<Property, Action>) -> Content
    ) where VM: ViewModel, VM.Property == Property, VM.Action == Action {
        self.viewModel = viewModel.typeErased
        self.state = viewModel.property
        self.buildFunc = build
    }

    public var body: some View { buildFunc(viewModel) }
}
