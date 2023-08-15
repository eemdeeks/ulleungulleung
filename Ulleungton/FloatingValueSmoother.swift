//
//  FloatingValueSmoother.swift
//  Ulleungton
//
//  Created by byo on 2023/08/15.
//

import Combine
import Foundation

final class FloatingValueSmoother<Value: FloatingPoint> {
    let maxValuesCount: Int
    let completion: (Value) -> Void
    private let valuesSubject: CurrentValueSubject<[Value], Never> = .init([])
    private var cancellable = Set<AnyCancellable>()
    
    init(maxValuesCount: Int,
         completion: @escaping (Value) -> Void) {
        self.maxValuesCount = maxValuesCount
        self.completion = completion
        setupCompletion()
    }
    
    func append(_ value: Value) {
        let values = getValuesAppended(value)
        valuesSubject.send(values)
    }
    
    private func setupCompletion() {
        valuesSubject
            .filter { $0.count == self.maxValuesCount }
            .sink { [unowned self] _ in
                completion(getAverageOfValues())
            }
            .store(in: &cancellable)
    }
    
    private func getValuesAppended(_ newValue: Value) -> [Value] {
        var values = valuesSubject.value.suffix(maxValuesCount - 1)
        values.append(newValue)
        return Array(values)
    }
    
    private func getAverageOfValues() -> Value {
        let total = valuesSubject.value
            .reduce(0, +)
        return total / Value(valuesSubject.value.count)
    }
}
