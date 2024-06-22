import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Utility

public struct KeyboardState: Equatable {
    public let isShow: Bool
    public let height: CGFloat
}

public final class HomeReactor: Reactor {
    public var initialState: State
    
    public enum Action {
        case viewDidLoad
        case keyboardWillShow(CGFloat)
        case keyboardWillHide
        case todayAgendaDidTap
        case growUpDidTap
        case calendarVisibleButtonDidTap
        case dateDidSelect(Date)
        case itemMoved(ItemMovedEvent)
        case textFieldEditingDidEnd([AgendaSectionItem])
        case unCheckButtonDidTap(unCompletedAgendaDataSource: [AgendaSectionItem], completedAgendaDataSource: [AgendaSectionItem])
        case checkButtonDidTap(unCompletedAgendaDataSource: [AgendaSectionItem], completedAgendaDataSource: [AgendaSectionItem])
    }
    
    public enum Mutation {
        case setKeyboardState(KeyboardState)
        case updateCalendarVisibie(Bool)
        case updateUncompletedAgendaDataSource([AgendaSectionItem])
        case updateCompletedAgendaDataSource([AgendaSectionItem])
        case updateSelectedDate(Date)
    }
    
    public struct State {
        var keyboardState: KeyboardState
        @Pulse var isVisibleCalendar: Bool?
        var uncompletedAgendaDataSource: [AgendaSectionItem]
        var completedAgendaDataSource: [AgendaSectionItem]
        var selectedDate: Date
    }
    
    public init() {
        self.initialState = .init(
            keyboardState: KeyboardState(isShow: false, height: 0),
            isVisibleCalendar: false,
            uncompletedAgendaDataSource: [],
            completedAgendaDataSource: [],
            selectedDate: Date()
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        //print("🚀 mutate")
        switch action {
        case .viewDidLoad:
            return fetchData()
            
        case .keyboardWillShow(let height):
            return .just(.setKeyboardState(KeyboardState(isShow: true, height: height)))
            
        case .keyboardWillHide:
            return .just(.setKeyboardState(KeyboardState(isShow: false, height: 0)))
            
        case .todayAgendaDidTap:
            return .empty()
            
        case .growUpDidTap:
            return .empty()
            
        case .calendarVisibleButtonDidTap:
            return toggleCalendarVisible()
        
        case .dateDidSelect(let date):
            return .empty()
            
        case .itemMoved((let sourceIndex, let destinationIndex)):
            return .empty()
            
        case .textFieldEditingDidEnd(let dataSource):
            return updateDataSource(dataSource: dataSource, type: .uncompleted)
            
        case .unCheckButtonDidTap(let unCompletedDataSource, let completedDataSource):
            return updateDataSources(unCompletedDataSource: unCompletedDataSource, completedDataSource: completedDataSource)

        case .checkButtonDidTap(let unCompletedDataSource, let completedDataSource):
            return updateDataSources(unCompletedDataSource: unCompletedDataSource, completedDataSource: completedDataSource)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setKeyboardState(let keyboardState):
            newState.keyboardState = keyboardState
            
        case .updateCalendarVisibie(let isVisibleCalendar):
            newState.isVisibleCalendar = isVisibleCalendar
            
        case .updateUncompletedAgendaDataSource(let uncompletedAgendaDataSource):
            newState.uncompletedAgendaDataSource = uncompletedAgendaDataSource
        
        case .updateCompletedAgendaDataSource(let completedAgendaDataSource):
            newState.completedAgendaDataSource = completedAgendaDataSource
            
        case .updateSelectedDate(let selectedDate):
            newState.selectedDate = selectedDate
        }
        return newState
    }
    
}

private extension HomeReactor {
    func fetchData() -> Observable<Mutation> {
        return .concat(
            fetchCalendarVisiblity(),
            fetchDataSource(type: .uncompleted),
            fetchDataSource(type: .completed)
        )
    }
    
    func fetchCalendarVisiblity() -> Observable<Mutation> {
        let calendarIsOpen = PreferenceManager.calendarIsOpen ?? false
        return .just(.updateCalendarVisibie(calendarIsOpen))
    }
    
    func fetchDataSource(type: AgendaType) -> Observable<Mutation> {
        var dict: [AgendaDate : [AgendaInfo]] = [:]
        switch type {
        case .uncompleted:
            dict = PreferenceManager.uncompletedAgendaList ?? [:]
        case .completed:
            dict = PreferenceManager.completedAgendaList ?? [:]
        }
        
        let date = Date()
        let today = AgendaDate(year: date.year(), month: date.month(), day: date.day())
        let list = dict[today] ?? []
        let datasource = list.map { AgendaSectionItem(title: $0.title) }
        
        switch type {
        case .uncompleted:
            return .just(.updateUncompletedAgendaDataSource(datasource))
        case .completed:
            return .just(.updateCompletedAgendaDataSource(datasource))
        }
        
    }
    
    func updateDataSource(dataSource: [AgendaSectionItem], type: AgendaType) -> Observable<Mutation> {
        let selected = currentState.selectedDate
        let agendaDate = AgendaDate(year: selected.year(), month: selected.month(), day: selected.day())
        let agendaInfos = dataSource.map { AgendaInfo(title: $0.title) }
        switch type {
        case .uncompleted:
            var temp: [AgendaDate: [AgendaInfo]] = [:]
            temp = PreferenceManager.uncompletedAgendaList ?? [:]
            temp.updateValue(agendaInfos, forKey: agendaDate)
            PreferenceManager.uncompletedAgendaList = temp
        case .completed:
            var temp: [AgendaDate: [AgendaInfo]] = [:]
            temp = PreferenceManager.completedAgendaList ?? [:]
            temp.updateValue(agendaInfos, forKey: agendaDate)
            PreferenceManager.completedAgendaList = temp
        }
 
        return .empty()
    }
    
    func updateDataSources(unCompletedDataSource: [AgendaSectionItem], completedDataSource: [AgendaSectionItem]) -> Observable<Mutation> {
        return .concat(
            updateDataSource(dataSource: unCompletedDataSource, type: .uncompleted),
            updateDataSource(dataSource: completedDataSource, type: .completed)
        )
    }

    func toggleCalendarVisible() -> Observable<Mutation> {
        guard let prev = currentState.isVisibleCalendar else { return .empty() }
        PreferenceManager.calendarIsOpen = !prev
        return .just(.updateCalendarVisibie(!prev))
    }
}
