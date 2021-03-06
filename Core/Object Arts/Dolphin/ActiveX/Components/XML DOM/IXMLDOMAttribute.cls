﻿"Filed out from Dolphin Smalltalk 7"!

IXMLDOMNode subclass: #IXMLDOMAttribute
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDOMAttribute guid: (IID fromString: '{2933BF85-7B36-11D2-B20E-00C04F983E60}')!
IXMLDOMAttribute comment: '<IXMLDOMAttribute> is a wrapper class for the COM interface ''MSXML.IXMLDOMAttribute'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized node type to represent DOM attributes.'!
!IXMLDOMAttribute categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLDOMAttribute methodsFor!

<= comperand 
	"Answer whether the receiver should be sorted before the <IXMLDOMAttribute> argument (see
	'Canonical XML', http://www.w3.org/TR/xml-c14n, for a description of the ordering
	convention."

	^self prefix = 'xmlns' 
		ifTrue: 
			[comperand prefix ~= 'xmlns' or: 
					["Both are namespace declarations, order by the namespace prefix so declared"
					self baseName <= comperand baseName]]
		ifFalse: 
			[comperand prefix ~= 'xmlns' and: 
					["Neither are namespace declarations, order by namespace URI
					(default namespace sorting first), and within that by
					attribute name"
					self namespaceURI <= comperand namespaceURI and: [self baseName <= comperand baseName]]]!

= anObject 
	^self class == anObject class and: [self key = anObject key and: [self value = anObject value]]!

get_name: attributeName
	"Private - Get the value of the 'name' property of the receiver.

		HRESULT __stdcall name(
			[out, retval]BSTR* attributeName);"

	<virtual stdcall: hresult 44 bstr*>
	^self invalidCall: _failureCode!

get_value: attributeValue
	"Private - Get the value of the 'value' property of the receiver.

		HRESULT __stdcall value(
			[out, retval]VARIANT* attributeValue);"

	<virtual stdcall: hresult 45 variant*>
	^self invalidCall: _failureCode!

key
	"Answer the <readableString> name of the receiver."

	^self nodeName!

key: arg1
	"This is part of the protocol <association>, but is not supported by 
	DOM attributes (the key is considered fixed)."

	^self shouldNotImplement!

name
	"Answer the <bstr> value of the 'name' property of the receiver.
	Helpstring: get name of the attribute"

	| answer |
	answer := BSTR new.
	self get_name: answer.
	^answer asObject
!

printValueOn: aStream
	[aStream nextPutAll: self xml] on: HRESULTError
		do: [:e | aStream print: bytes]!

put_value: attributeValue
	"Private - Set the value of the 'value' property of the object wrapped by the 
	 receiver to the <variant> argument, attributeValue.

		HRESULT __stdcall value(
			[in]VARIANT attributeValue);"

	<virtual stdcall: hresult 46 variant>
	^self invalidCall: _failureCode!

value
	"Answer the <variant> value of the 'value' property of the receiver.
	Helpstring: string value of the attribute"

	| answer |
	answer := VARIANT new.
	self get_value: answer.
	^answer asObject
!

value: attributeValue
	"Set the 'value' property of the receiver to the <variant> value of the argument.
	Helpstring: string value of the attribute"

	self put_value: attributeValue asVariant
! !
!IXMLDOMAttribute categoriesFor: #<=!comparing!public! !
!IXMLDOMAttribute categoriesFor: #=!comparing!public! !
!IXMLDOMAttribute categoriesFor: #get_name:!**auto generated**!COM Interfaces-IXMLDOMAttribute!private! !
!IXMLDOMAttribute categoriesFor: #get_value:!**auto generated**!COM Interfaces-IXMLDOMAttribute!private! !
!IXMLDOMAttribute categoriesFor: #key!accessing!public! !
!IXMLDOMAttribute categoriesFor: #key:!accessing!public! !
!IXMLDOMAttribute categoriesFor: #name!**auto generated**!properties!public! !
!IXMLDOMAttribute categoriesFor: #printValueOn:!printing!private! !
!IXMLDOMAttribute categoriesFor: #put_value:!**auto generated**!COM Interfaces-IXMLDOMAttribute!private! !
!IXMLDOMAttribute categoriesFor: #value!**auto generated**!properties!public! !
!IXMLDOMAttribute categoriesFor: #value:!**auto generated**!properties!public! !

IXMLDOMAttribute methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!IXMLDOMAttribute class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMAttribute'
		IXMLDOMAttribute defineTemplate"

	self
		defineFunction: #get_name:
			argumentTypes: 'bstr*';
		defineFunction: #get_value:
			argumentTypes: 'variant*';
		defineFunction: #put_value:
			argumentTypes: 'variant'
! !
!IXMLDOMAttribute class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

