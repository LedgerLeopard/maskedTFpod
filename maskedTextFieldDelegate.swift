//
//  maskedTextFieldDelegate.swift
//  maskedTextField
//
//  Created by Юрий Гущин on 20.09.2018.
//


import Foundation
import UIKit

extension String {
    func getCharAtIndex(_ position: Int) -> Character {
        let strIndex = index(startIndex, offsetBy: position)
        return self[strIndex]
    }
}

public enum Action {
    case Delete, Insert
}

public struct symbolWithProperties {
    var editable : Bool
    var requiredToPresent : Bool
    var needToReturn : Bool
    var characterSet : CharacterSet?
    var symbol : Character?
    var position : Int?
    
    public init(editable: Bool, requiredToPresent: Bool, needToReturn: Bool, characterSet: CharacterSet?, symbol: Character?, position: Int?) {
        self.editable = editable
        self.requiredToPresent = requiredToPresent
        self.needToReturn = needToReturn
        self.characterSet = characterSet
        self.symbol = symbol
        self.position = position
    }
}

public class MaskedTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    private var arrayOfSymbolsWithProperties : [symbolWithProperties]!
    
    public typealias MaskResultClosure = ((_ maskedValue: String, _ clearValue: String) -> Void)
    public typealias MaskFocusClosure = (Bool)->Void
    
    private var truePosition = 0
    private var mask = ""
    @objc private var myTextField: UITextField!
    private var notValidCursorPositions: [Int]!
    private var emptyPositions = [Int]()
    
    public var resultCallback: MaskResultClosure?
    public var focusReceivedCallback: MaskFocusClosure?
    
    public var maskedValue : String? {
        get {
            return myTextField.text
        }
    }
    
    public var clearValue : String {
        get {
            var res = ""
            for i in arrayOfSymbolsWithProperties {
                if i.needToReturn{
                    if let character = i.symbol, character != "_"{
                        res += String(character)
                    }
                }
            }
            return res
        }
    }
    
    public init(_ TextField: UITextField,
         _ sourceMask : String,
         _ sourceValue: String,
         _ resultCallback : @escaping MaskResultClosure = { _ ,_ in },
         _ focusClosure : @escaping MaskFocusClosure = { _ in }) {
        
        super.init()
        
        self.resultCallback = resultCallback
        self.focusReceivedCallback = focusClosure
        
        self.myTextField = TextField
        arrayOfSymbolsWithProperties = setPositions(from: sourceMask)
        mask = getValueForPresent(from: arrayOfSymbolsWithProperties)
        insertAction(sourceValue, getFirstEnterablePosition(in : arrayOfSymbolsWithProperties))
        
        
        addObserver(self, forKeyPath: #keyPath(myTextField.selectedTextRange), options: [.new, .old], context: nil)
    }
    
    /// Функция анализирует полученную при инициализации делегата маску, получая на выходе массив symbolWithProperties
    ///
    /// - Parameters:
    ///   - sourceMask: Исходная маска
    /// - Returns: Массив символов со свойствами
    private func setPositions(from sourceMask: String ) -> [symbolWithProperties]{
        var arrayOfSymbols = [symbolWithProperties] ()
        var editable = false
        var needToReturnOnly = false
        var position = 0
        for index in 0..<sourceMask.count {
            let character = sourceMask.getCharAtIndex(index)
            //Ветвление - пиздец, а как иначе?
            switch character {
            case "[":
                editable = true
            case "]":
                editable = false
            case "{":
                needToReturnOnly = true
            case "}":
                needToReturnOnly = false
            default:
                
                if editable {
                    switch character{
                    case "0":
                        
                        arrayOfSymbols.append(symbolWithProperties(editable: true, requiredToPresent: true, needToReturn: true, characterSet: CharacterSet.init(charactersIn: "1234567890"), symbol: "_", position: position))
                        position = position + 1
                    case "9":
                        arrayOfSymbols.append(symbolWithProperties(editable: true, requiredToPresent: false, needToReturn: true, characterSet: CharacterSet.init(charactersIn: "1234567890"), symbol: nil, position: nil))
                    case "A":
                        arrayOfSymbols.append(symbolWithProperties(editable: true, requiredToPresent: true, needToReturn: true, characterSet: CharacterSet.init(charactersIn: "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMйцукенгшщзхъфывапролджэёячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ"), symbol: "_", position: position))
                        position = position + 1
                    case "a":
                        arrayOfSymbols.append(symbolWithProperties(editable: true, requiredToPresent: false, needToReturn: true, characterSet: CharacterSet.init(charactersIn: "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMйцукенгшщзхъфывапролджэёячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ"), symbol: nil, position: nil))
                    case "_":
                        arrayOfSymbols.append(symbolWithProperties(editable: true, requiredToPresent: true, needToReturn: true, characterSet: CharacterSet.init(charactersIn: "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMйцукенгшщзхъфывапролджэёячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ1234567890<!№%:,.;()_+@$%{}[]/"), symbol: "_", position: position))
                        position = position + 1
                    case "-":
                        arrayOfSymbols.append(symbolWithProperties(editable: true, requiredToPresent: false, needToReturn: true, characterSet: CharacterSet.init(charactersIn:
                            "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNMйцукенгшщзхъфывапролджэёячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЁЯЧСМИТЬБЮ1234567890<!№%:,.;()_+@$%{}[]/"), symbol: nil, position: nil))
                    default:
                        break
                    }
                    break
                } else if needToReturnOnly {
                    arrayOfSymbols.append(symbolWithProperties(editable: false, requiredToPresent: true, needToReturn: true, characterSet: nil, symbol: character, position: position))
                    position = position + 1
                } else {
                    arrayOfSymbols.append(symbolWithProperties(editable: false, requiredToPresent: true, needToReturn: false, characterSet: nil, symbol: character, position: position))
                    position = position + 1
                }
            }
        }
        return arrayOfSymbols
    }
    
    /// Функция устанавливает позиции элементов массива в отображаемой пользователю строке
    private func resetPositions(){
        var position = 0
        for i in 0..<arrayOfSymbolsWithProperties.count {
            if arrayOfSymbolsWithProperties[i].symbol != nil {
                arrayOfSymbolsWithProperties[i].position = position
                position += 1
            } else {
                arrayOfSymbolsWithProperties[i].position = nil
            }
        }
    }
    
    /// Функция собирает отображаемую пользователю строку из элементов массива
    ///
    /// - Parameter array: Массив символов с параметрами
    /// - Returns: String: Маска
    private func getValueForPresent(from array : [symbolWithProperties]) -> String {
        var mask = ""
        for i in array{
            if let symbol = i.symbol {
                mask = mask + String(symbol)
            }
        }
        return mask
    }
    
    //KVO
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let newPosition = change?[.newKey] as? UITextRange else {
            return
        }
        let newOffset = myTextField.offset(from: myTextField.beginningOfDocument, to: newPosition.start)
        
        if notValidCursorPositions.contains(newOffset) {
            setValidCursorPosition()
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textFieldIsEmpty = textField.text?.isEmpty, textFieldIsEmpty {
            textField.text = mask
            notValidCursorPositions = getNotValidCursorPosition(arrayOfSymbolsWithProperties)
            setValidCursorPositionAfterFocusReceived()
        } else {
            setValidCursorPositionAfterFocusReceived()
        }
        
        focusReceivedCallback?(true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        focusReceivedCallback?(false)
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        removeObserver(self, forKeyPath: #keyPath(myTextField.selectedTextRange))
        
        guard let selectionStart = textField.selectedTextRange?.start else {
            return false
        }
        let positionInArray = textField.offset(from: textField.beginningOfDocument, to: selectionStart)
        
        let action = getAction(string)
        switch action {
        case .Insert:
            insertAction(string, positionInArray)
        case .Delete:
            deleteAction(positionInArray)
        }
        
        resultCallback?(maskedValue!,clearValue)
        addObserver(self, forKeyPath: #keyPath(myTextField.selectedTextRange), options: [.new, .old], context: nil)
        return false
    }
    
    /// Функция определяет действие, совершенное пользователем
    ///
    /// - Returns: Delete/Insert
    private func getAction(_ string : String) -> Action {
        if string.count != 0 {
            return .Insert
        } else {
            return .Delete
        }
    }
    
    /// Функция отвечает за ввод символа/строки
    ///
    ///Считается количество невведенных необязательных элементов перед позицией курсора. Затем
    /// высчитывается позиция элемента массива, который будет изменен. После изменения из поля Symbol элементов массива собирается строка.
    /// - Parameters:
    ///   - input: символ или строка, полученные от пользователя
    ///   - position: номер элемента массива arrayOfSymbolsWithProperties, перед которым был установлен курсор
    private func insertAction(_ input: String,_ position: Int){
        var pos = position
        //        Высчитываем позицию в массиве по позиции в строке.
        for i in 0..<position{
            if arrayOfSymbolsWithProperties[i].symbol == nil {
                pos += 1
            }
        }
        for char in input{
            if pos < arrayOfSymbolsWithProperties.count{
                // Для начала нужно понять, является ли элемент в массиве, выбранный по нашему offset, изменяемым. Если нет то двигаемся вправо, пока не наткнемся на изменяемый. Что бы не уйти за пределы ставим условие.
                while !arrayOfSymbolsWithProperties[pos].editable {
                    pos += 1
                }
                //Здесь выбираем что будем делать: заменять или вставлять новый символ.
                let convertedChar = UnicodeScalar(String(char))
                if (arrayOfSymbolsWithProperties[pos].characterSet?.contains(convertedChar!))!{
                    arrayOfSymbolsWithProperties[pos].symbol = char
                } else {
                    pos -= 1
                }
                pos += 1
            }
        }
        truePosition = pos
        resetPositions()
        notValidCursorPositions = getNotValidCursorPosition(arrayOfSymbolsWithProperties)
        
        myTextField.text = getValueForPresent(from: arrayOfSymbolsWithProperties)
        
        guard let newPosition = myTextField.position(from: myTextField.beginningOfDocument, offset: pos) else { return }
        myTextField.selectedTextRange = myTextField.textRange(from: newPosition, to: newPosition)
    }
    
    /// Функция отвечает за удаление символа/нескольких символов
    ///
    ///Считается количество невведенных необязательных элементов перед позицией курсора. Затем
    /// высчитывается позиция элемента массива, который будет изменен.
    ///
    /// - Parameters:
    ///   - position: позиция, в которой находился курсор в начале удаления
    func deleteAction(_ position: Int) {
        var pos = position
        
        setEmptyPositions()
        var emptyPositionsCount = 0
        for i in emptyPositions{
            if i < pos - 1{
                emptyPositionsCount += 1
            }
        }
        pos = pos + emptyPositionsCount
        
        guard let selectionStart = myTextField.selectedTextRange?.start,
            let selectionEnd = myTextField.selectedTextRange?.end else {
                return
        }
        let offset = myTextField.offset(from: selectionStart, to: selectionEnd)
        //Если текст выделили перед удалением, то мы удаляем все deletable символы в нем, иначе перый попавшийся слева
        var count = 0
        if offset != 0 {
            for i in pos..<(pos + offset){
                if arrayOfSymbolsWithProperties[i].editable && arrayOfSymbolsWithProperties[i].symbol != nil {
                    count += 1
                }
            }
            //Если текст не был выбран, то просто удаляем один возможнодоступный элемент
        }else {
            count += 1
        }
        
        var newPosition: Int?
        newPosition = pos + offset
        for _ in 0..<count {
            print("shoud change in position \(newPosition!)")
            if (newPosition != nil){
                newPosition = choosePreviousDeletableElement(from: newPosition!)
            }
            if (newPosition != nil) {
                deleteElement(newPosition!)
                pos = newPosition!
            }
        }
        resetPositions()
        truePosition = pos
        myTextField.text = getValueForPresent(from: arrayOfSymbolsWithProperties)
        notValidCursorPositions = getNotValidCursorPosition(arrayOfSymbolsWithProperties)
        guard let cursorPosition = myTextField.position(from: myTextField.beginningOfDocument, offset: pos) else { return }
        myTextField.selectedTextRange = myTextField.textRange(from: cursorPosition, to: cursorPosition)
    }
    
    /// Функция заплоняет массив позиций необязательных, невведенных символов.
    private func setEmptyPositions(){
        emptyPositions.removeAll()
        var fullPositionInString = 0
        for i in (0..<arrayOfSymbolsWithProperties.count){
            if arrayOfSymbolsWithProperties[i].position == nil{
                emptyPositions.append(fullPositionInString)
            } else{
                fullPositionInString = arrayOfSymbolsWithProperties[i].position!
            }
        }
        print(emptyPositions)
    }
    
    /// получить массив позиций куда НЕЛЬЗЯ вставлять курсор
    ///
    /// - Parameter mask: mask
    /// - Returns: массив позиций куда НЕЛЬЗЯ вставлять курсор
    private func getNotValidCursorPosition(_ array : [symbolWithProperties]) -> [Int] {
        var res = [Int]()
        
        if !array[0].editable {
            res.append(array[0].position!)
        }
        for i in 1..<array.count {
            if !array[i].editable && !array[i-1].editable {
                res.append(array[i].position!)
            }
        }
        
        return res
    }
    
    ///Прозодит с конца строки и устанавливает курсор перед первым "_"
    private func setValidCursorPositionAfterFocusReceived() {
        var enterablePositions = getEmptyPosition(mask)
        var previousEmptyPosition = enterablePositions[0];
        for index in enterablePositions.reversed() {
            if myTextField.text?.getCharAtIndex(index) != "_" {
                break
            }
            previousEmptyPosition = index
        }
        
        if let newPosition = myTextField.position(from: myTextField.beginningOfDocument, offset: previousEmptyPosition) {
            myTextField.selectedTextRange = myTextField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    /// получить массив пустых позиций при нажатии на поле.
    ///
    /// - Parameter mask: mask
    /// - Returns: массив позиций куда МОЖНО вставлять курсор
    private func getEmptyPosition(_ mask: String) -> [Int] {
        var res = [Int]()
        for i in 0..<mask.count {
            if (mask.getCharAtIndex(i) == "_") {
                res.append(i)
            }
        }
        return res
    }
    
    /// Функция спользуется в KVO
    private func setValidCursorPosition() {
        guard let range = myTextField.selectedTextRange else {
            return
        }
        // преобразуем UITextPosition в int
        var pos = myTextField.offset(from: myTextField.beginningOfDocument, to: range.start)
        while notValidCursorPositions.contains(pos) {
            pos = pos + 1
        }
        
        if let newPosition = myTextField.position(from: myTextField.beginningOfDocument, offset: pos) {
            myTextField.selectedTextRange = myTextField.textRange(from: newPosition, to: newPosition)
            
        }
    }
    
    /// Выбираем предыдущий элемент, который можно удалить. Используется в DeleteAction
    ///
    /// - Parameter position: Позиция, перед которой будем искать элемент на удаление
    /// - Returns: Позиция элемента на удаление
    private func choosePreviousDeletableElement(from position: Int) -> Int? {
        var position = position - 1
        if position == (arrayOfSymbolsWithProperties.count){
            return position
        }
        while !arrayOfSymbolsWithProperties[position].editable && arrayOfSymbolsWithProperties[position].symbol != nil{
            position -= 1
            if position < 0 { return nil }
        }
        return position
    }
    
    /// Удаляем/заменяем элемен
    ///
    /// - Parameter position: Позиция элемента на удаление/замену
    private func deleteElement(_ position: Int) {
        if arrayOfSymbolsWithProperties[position].requiredToPresent{
            arrayOfSymbolsWithProperties[position].symbol = "_"
        } else {
            arrayOfSymbolsWithProperties[position].symbol = nil
        }
    }
    
    /// Нахедим первый изменяемый элемент. Используется при определении начального значения маски
    ///
    /// - Parameter array: массив элементов, по которому будем бегать
    /// - Returns: позиция первого изменяемого элемента
    private func getFirstEnterablePosition(in array : [symbolWithProperties]) -> Int{
        for i in 0..<array.count {
            if array[i].editable {
                return i
            }
        }
        return 0
    }
}
