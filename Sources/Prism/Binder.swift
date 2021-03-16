import SwiftUI

public final class Binder: ObservableObject {
    private var registration = [Key :() -> Any]()

    public init() {
    }

    public func register<VM>(_ viewModel: @autoclosure @escaping () -> VM) -> Binder where VM: ViewModel {
        registration[Key(propertyType: VM.Property.self, actionType: VM.Action.self)] = { viewModel().typeErased }
        return self
    }

    public func resolve<Property, Action>(_: Property.Type, _: Action.Type) -> AnyViewModel<Property, Action> {
        let key = Key(propertyType: Property.self, actionType: Action.self)
        switch registration[key] {
        case let .some(viewModel):
            return viewModel() as! AnyViewModel<Property, Action>
        case .none:
            fatalError("View model is not registered: State == \(Property.self), Action == \(Action.self)")
        }
    }

    @discardableResult
    public func bind<State, Action, Content>(
        _: State.Type,
        _: Action.Type,
        _ id: State.ID,
        @ViewBuilder _ build: @escaping (AnyViewModel<State, Action>) -> Content
    ) -> PropertyBinding<State, Action, Content> where Content: View {
        let viewModel = resolve(State.self, Action.self)
        viewModel.bind(to: id)
        return PropertyBinding(viewModel, build)
    }
}

struct Key {
    let propertyType: Any.Type
    let actionType: Any.Type

    init(propertyType: Any.Type, actionType: Any.Type) {
        self.propertyType = propertyType
        self.actionType = actionType
    }
}

extension Key: Hashable {
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(propertyType).hash(into: &hasher)
        ObjectIdentifier(actionType).hash(into: &hasher)
    }
}

func == (_ x: Key, _ y: Key) -> Bool {
    return
        x.propertyType == y.propertyType &&
        x.actionType == y.actionType
}
