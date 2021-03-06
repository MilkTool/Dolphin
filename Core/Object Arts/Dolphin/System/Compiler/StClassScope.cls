﻿"Filed out from Dolphin Smalltalk 7"!

StSemanticScope subclass: #StClassScope
	instanceVariableNames: 'methodClass instanceVariables selfVariable superVariable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StClassScope guid: (GUID fromString: '{b221d07f-4ae8-400c-b48e-28b90fca0050}')!
StClassScope comment: ''!
!StClassScope categoriesForClass!Kernel-Objects! !
!StClassScope methodsFor!

lookupVariable: anStVariableNode
	"Lookup and return an <StVariable> describing the variable definition in this scope matching
	the variable reference specified by the <StVariableNode> argument."

	| identifier |
	identifier := anStVariableNode name.
	anStVariableNode isSpecialVariable ifTrue: [^anStVariableNode specialVariableInScope: self].
	instanceVariables isNil
		ifTrue: 
			[instanceVariables := LookupTable new: 5.
			methodClass allInstVarNames
				keysAndValuesDo: [:i :v | instanceVariables at: v put: (StInstanceVariable index: i name: v)]].
	^(instanceVariables lookup: identifier)
		ifNil: 
			[(methodClass fullBindingFor: identifier) ifNotNil: [:b | StStaticVariable scope: self binding: b]]!

methodClass
	^methodClass!

selfVariable
	^selfVariable
		ifNil: 
			[selfVariable := (StSelfVariable new)
						scope: self;
						yourself]!

setMethodClass: aClassDescription
	methodClass := aClassDescription.
	self initialize!

superVariable
	^superVariable
		ifNil: 
			[superVariable := (StSuperVariable new)
						scope: self;
						yourself]! !
!StClassScope categoriesFor: #lookupVariable:!operations!public! !
!StClassScope categoriesFor: #methodClass!accessing!public! !
!StClassScope categoriesFor: #selfVariable!operations!public! !
!StClassScope categoriesFor: #setMethodClass:!accessing!initializing!private! !
!StClassScope categoriesFor: #superVariable!operations!public! !

!StClassScope class methodsFor!

methodClass: aClassDescription
	^self new setMethodClass: aClassDescription! !
!StClassScope class categoriesFor: #methodClass:!instance creation!public! !

