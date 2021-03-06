﻿"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #NUMBERFMTW
	instanceVariableNames: 'decimalSeparator numberGrouping thousandSeparator'
	classVariableNames: '_OffsetOf_Grouping _OffsetOf_LeadingZero _OffsetOf_lpDecimalSep _OffsetOf_lpThousandSep _OffsetOf_NegativeOrder _OffsetOf_NumDigits'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NUMBERFMTW guid: (GUID fromString: '{0a4bf3f8-997a-4704-98b0-05a904564613}')!
NUMBERFMTW addClassConstant: '_OffsetOf_Grouping' value: 16r8!
NUMBERFMTW addClassConstant: '_OffsetOf_LeadingZero' value: 16r4!
NUMBERFMTW addClassConstant: '_OffsetOf_lpDecimalSep' value: 16rC!
NUMBERFMTW addClassConstant: '_OffsetOf_lpThousandSep' value: 16r10!
NUMBERFMTW addClassConstant: '_OffsetOf_NegativeOrder' value: 16r14!
NUMBERFMTW addClassConstant: '_OffsetOf_NumDigits' value: 16r0!
NUMBERFMTW comment: '`NUMBERFMTW` is an `ExternalStructure` class to wrap the struct NUMBERFMTW from type information in the ''Win32 API'' library.

NUMBERFMTW is used in conjunction with the GetNumberFormat API to produce localised representations of printed decimal numbers.

IDL definition follows:
```
typedef [uuid(0a4bf3f8-997a-4704-98b0-05a904564613)]
struct tagNUMBERFMTW {
	[helpstring("number of decimal digits")] unsigned int NumDigits;
	[helpstring("if leading zero in decimal fields")] unsigned int LeadingZero;
	[helpstring("group size left of decimal")] unsigned int Grouping;
	[helpstring("ptr to decimal separator string")] LPWSTR lpDecimalSep;
	[helpstring("ptr to thousand separator string")] LPWSTR lpThousandSep;
	[helpstring("negative number ordering")] unsigned int NegativeOrder;
} NUMBERFMTW;
```'!
!NUMBERFMTW categoriesForClass!Win32-Structs! !
!NUMBERFMTW methodsFor!

decimalPlaces
	^self NumDigits!

decimalPlaces: anInteger 
	(anInteger between: 0 and: 9) ifFalse: [self error: 'Number of decimal places must be between 0 and 9 inclusive'].
	self NumDigits: anInteger!

decimalSeparator
	^decimalSeparator ifNil: [decimalSeparator := self lpDecimalSep]!

decimalSeparator: aString
	decimalSeparator := aString asUtf16String.
	self lpDecimalSep: decimalSeparator!

Grouping
	"Answer the <Integer> value of the receiver's 'Grouping' field."

	^bytes dwordAtOffset: _OffsetOf_Grouping!

Grouping: anInteger
	"Set the receiver's 'Grouping' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Grouping put: anInteger!

hasLeadingZero
	^self LeadingZero asBoolean!

hasLeadingZero: aBoolean
	self LeadingZero: aBoolean asParameter!

LeadingZero
	"Answer the <Integer> value of the receiver's 'LeadingZero' field."

	^bytes dwordAtOffset: _OffsetOf_LeadingZero!

LeadingZero: anInteger
	"Set the receiver's 'LeadingZero' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_LeadingZero put: anInteger!

lpDecimalSep
	"Answer the <Utf16String> value of the receiver's 'lpDecimalSep' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpDecimalSep)!

lpDecimalSep: anUtf16String
	"Set the receiver's 'lpDecimalSep' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpDecimalSep put: anUtf16String yourAddress!

lpThousandSep
	"Answer the <Utf16String> value of the receiver's 'lpThousandSep' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpThousandSep)!

lpThousandSep: anUtf16String
	"Set the receiver's 'lpThousandSep' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpThousandSep put: anUtf16String yourAddress!

negativeNumberMode 
	^self NegativeOrder!

negativeNumberMode: anInteger 
	self NegativeOrder: anInteger!

NegativeOrder
	"Answer the <Integer> value of the receiver's 'NegativeOrder' field."

	^bytes dwordAtOffset: _OffsetOf_NegativeOrder!

NegativeOrder: anInteger
	"Set the receiver's 'NegativeOrder' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_NegativeOrder put: anInteger!

numberGrouping
	^numberGrouping
		ifNil: 
			[numberGrouping := AnsiString streamContents: 
							[:stream |
							| digits |
							digits := self Grouping printString.
							digits do: [:each | stream nextPut: each] separatedBy: [stream nextPut: $;].
							"Rather perversely the meaning of a trailing zero is inverted vs the meaning in the string format"
							(digits size > 1 and: [digits last = $0]) ifTrue: [stream nextPutAll: ';0']]]!

numberGrouping: aString
	| groups |
	numberGrouping := nil.
	groups := $; split: aString.
	groups last = '0' ifTrue: [groups := groups resize: groups size - 1].
	self Grouping: (groups inject: 0
				into: 
					[:grouping :each |
					| group |
					group := Integer fromString: each.
					grouping * 10 + group])!

NumDigits
	"Answer the <Integer> value of the receiver's 'NumDigits' field."

	^bytes dwordAtOffset: _OffsetOf_NumDigits!

NumDigits: anInteger
	"Set the receiver's 'NumDigits' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_NumDigits put: anInteger!

thousandSeparator
	^thousandSeparator ifNil: [thousandSeparator := self lpThousandSep]!

thousandSeparator: aString
	thousandSeparator := aString asUtf16String.
	self lpThousandSep: thousandSeparator! !
!NUMBERFMTW categoriesFor: #decimalPlaces!accessing!public! !
!NUMBERFMTW categoriesFor: #decimalPlaces:!accessing!public! !
!NUMBERFMTW categoriesFor: #decimalSeparator!accessing!public! !
!NUMBERFMTW categoriesFor: #decimalSeparator:!accessing!public! !
!NUMBERFMTW categoriesFor: #Grouping!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #Grouping:!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #hasLeadingZero!accessing!public! !
!NUMBERFMTW categoriesFor: #hasLeadingZero:!accessing!public! !
!NUMBERFMTW categoriesFor: #LeadingZero!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #LeadingZero:!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #lpDecimalSep!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #lpDecimalSep:!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #lpThousandSep!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #lpThousandSep:!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #negativeNumberMode!accessing!public! !
!NUMBERFMTW categoriesFor: #negativeNumberMode:!accessing!public! !
!NUMBERFMTW categoriesFor: #NegativeOrder!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #NegativeOrder:!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #numberGrouping!accessing!public! !
!NUMBERFMTW categoriesFor: #numberGrouping:!accessing!public! !
!NUMBERFMTW categoriesFor: #NumDigits!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #NumDigits:!**compiled accessors**!public! !
!NUMBERFMTW categoriesFor: #thousandSeparator!accessing!public! !
!NUMBERFMTW categoriesFor: #thousandSeparator:!accessing!public! !

!NUMBERFMTW class methodsFor!

defineFields
	"Define the fields of the NUMBERFMTW structure.

	Win32NUMBERFMTW compileDefinition

		typedef [uuid(0a4bf3f8-997a-4704-98b0-05a904564613)]
		struct tagNUMBERFMTW {
			[helpstring('number of decimal digits')] unsigned int NumDigits;
			[helpstring('if leading zero in decimal fields')] unsigned int LeadingZero;
			[helpstring('group size left of decimal')] unsigned int Grouping;
			[helpstring('ptr to decimal separator string')] LPWSTR lpDecimalSep;
			[helpstring('ptr to thousand separator string')] LPWSTR lpThousandSep;
			[helpstring('negative number ordering')] unsigned int NegativeOrder;
		} NUMBERFMTW;
"

	self
		defineField: #NumDigits type: DWORDField new offset: 0;
		defineField: #LeadingZero type: DWORDField new offset: 4;
		defineField: #Grouping type: DWORDField new offset: 8;
		defineField: #lpDecimalSep type: (PointerField type: Utf16String) offset: 12;
		defineField: #lpThousandSep type: (PointerField type: Utf16String) offset: 16;
		defineField: #NegativeOrder type: DWORDField new offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#NumDigits #LeadingZero #Grouping #lpDecimalSep #lpThousandSep #NegativeOrder)! !
!NUMBERFMTW class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!NUMBERFMTW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

