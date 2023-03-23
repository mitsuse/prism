import SwiftUI

public final class Binder: ObservableObject {
    private var registration = [Key :() -> Any]()

    public init() {
    }

    public func register<VM>(_ viewModel: @autoclosure @escaping () -> VM) -> Binder where VM: ViewModel {
        registration[Key(propertyType: VM.Prop.self, actionType: VM.Action.self)] = { viewModel().typeErased }
        return self
    }

    public func resolve<Prop, Action>(_: Prop.Type, _: Action.Type) -> AnyViewModel<Prop, Action> {
        let key = Key(propertyType: Prop.self, actionType: Action.self)
        switch registration[key] {
        case let .some(viewModel):
            return viewModel() as! AnyViewModel<Prop, Action>
        case .none:
            fatalError("View model is not registered: Prop == \(Prop.self), Action == \(Action.self)")
        }
    }

    @discardableResult
    public func bind<Prop, Action, Content>(
        _: Prop.Type,
        _: Action.Type,
        _ id: Prop.ID,
        @ViewBuilder _ build: @escaping (AnyViewModel<Prop, Action>) -> Content
    ) -> PropBinding<Prop, Action, Content> where Content: View {
        let viewModel = resolve(Prop.self, Action.self)
        viewModel.bind(to: id)
        return PropBinding(viewModel, build)
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
