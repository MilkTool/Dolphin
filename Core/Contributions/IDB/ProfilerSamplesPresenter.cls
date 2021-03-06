﻿"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #ProfilerSamplesPresenter
	instanceVariableNames: 'selectorFilter filterTarget index frame'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProfilerSamplesPresenter guid: (GUID fromString: '{425d0eb4-542e-11d3-998b-d5ca2c3c1d61}')!
ProfilerSamplesPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!ProfilerSamplesPresenter categoriesForClass!IDB Goodies! !
!ProfilerSamplesPresenter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self add: TextPresenter new name: 'sampleIndicator'.
	self add: NumberPresenter new name: 'sampleSelector'.
	self add: ListPresenter new name: 'frames'.
	self add: MethodWorkspace new name: 'workspace'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self presenterNamed: 'frames') 
		when: #selectionChanged
		send: #onFrameSelectionChanged
		to: self.
	(self presenterNamed: 'sampleSelector') 
		when: #valueChanged
		send: #onSampleIndexChanged
		to: self!

filterNext
	"Find the next sample that answer true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	self model samplesSize ~= 0 
		ifTrue: 
			[index := (index + 1 to: self model samplesSize) 
						detect: [:each | selectorFilter value: (self model sampleAt: each)]
						ifNone: 
							[Sound beep.
							index]].
	self filterStopped!

filterPrevious
	"Find the previous sample that answer true to the selectorFilter, starting at the current index.
	Beep if no more can be found and leave the selection at the current value"

	self model samplesSize ~= 0 
		ifTrue: 
			[index := (index - 1 to: 1 by: -1) 
						detect: [:each | selectorFilter value: (self model sampleAt: each)]
						ifNone: 
							[Sound beep.
							index]].
	self filterStopped!

filterSelector: aCompiledCodeOrNil 
	"Set the filterSelector up to look for any sample that contains a frame that matches
	the class/selector of aCompiledMethod. Move to the start and find the first match.
	If the argument is nil then the filter just steps one sample at a time"

	selectorFilter := aCompiledCodeOrNil isNil 
				ifTrue: [[:o | true]]
				ifFalse: 
					[(aCompiledCodeOrNil isKindOf: CompiledMethod) 
						ifTrue: [[:o | o isChildOfFrameFor: aCompiledCodeOrNil]]
						ifFalse: [[:o | false]]].
	filterTarget := aCompiledCodeOrNil.
	index := 0.
	self filterNext!

filterStopped
	"The filter has selected sample index as the one to display. If either the filterTarget was 
	nil (filter turned off) or the target cannot be found in the frame then set frame to  nil which
	means the active frame will be selected, otherwise select the first frame that matches"

	frame := filterTarget isNil 
				ifFalse: 
					[(self model sampleAt: index) frames detect: [:each | each doClassAndSelectorMatch: filterTarget]
						ifNone: []].
	self showSample!

initialize
	"Initialize the reciver"

	super initialize.
	selectorFilter := [:o | true].
	index := 0.
	^self!

model: aProfilerSampleSet 
	"Set the model for the receiver. The test is needed to ensure that the sub views are all
	updated when the model is changed but prevent a walkback the first time the model is set, as
	part of the window creation procedure. The walkback occurs because the scroll bar subview
	is not ready, at that stage, to have its range set (also see #onViewOpened)"

	super model: aProfilerSampleSet.
	((self presenterNamed: 'sampleSelector') view isKindOf: DeafObject) ifFalse: [self setSampleRange]!

onFrameSelectionChanged
	"The frame selection has changed so update the source view accordingly"

	| selection text selectionRange styler |
	selection := (self presenterNamed: 'frames') selectionOrNil.
	selection isNil 
		ifTrue: 
			[text := String new.
			selectionRange := 0 to: 0.
			styler := NullScintillaStyler]
		ifFalse: 
			[text := selection coloredSource.
			styler := selection compiledCode stylerClass.
			selectionRange := selection selectionRange].
	(self presenterNamed: 'workspace')
		text: text;
		stylerClass: styler;
		selectionRange: selectionRange!

onSampleIndexChanged
	"The sample index has changed, the slider has been moved. Set the sample index and 
	show the sample"

	index := (self presenterNamed: 'sampleSelector') value.
	self showSample!

onViewOpened
	"When the view has been opened, and the sub views created, we can set the selection range. On
	subsequent model changes (therefore range changes) we have to use the #model: method as this
	method is never used again"

	super onViewOpened.
	self setSampleRange.
	(self presenterNamed: 'workspace') view isReadOnly: true!

parseContext
	^self selectedMethod ifNotNil: [:method | method methodClass]!

sampleIndicator: anInteger 
	"Answer a String describing the position of the current sample in its world"

	^(String writeStream)
		nextPutAll: 'Sample ';
		print: anInteger;
		nextPutAll: ' out of ';
		print: self model samplesSize;
		contents!

selectedMethod
	^(self presenterNamed: 'frames') selectionOrNil ifNotNil: [:f | f compiledCode]!

setSampleRange
	"Set the range and initial index of the sampleSelector, the values reflecting the model"

	index := self model samplesSize = 0 ifTrue: [0] ifFalse: [1].
	((self presenterNamed: 'sampleSelector') view)
		range: (index to: self model samplesSize);
		pageSize: self model samplesSize // 10.
	self showSample!

showSample
	"The sample selected has changed. If index is 0 it means thare are no
	samples available (no sample set selected or an empty set) so just clear all
	the sub views. If it is a valid sample index the find and display the frames for
	the sample. Select either the frame set in frame "

	(self presenterNamed: 'sampleIndicator') value: (self sampleIndicator: index).
	(self presenterNamed: 'sampleSelector') view scrollPosition: index.
	index = 0 
		ifTrue: 
			[(self presenterNamed: 'frames') list: OrderedCollection new.
			self onFrameSelectionChanged]
		ifFalse: 
			[| frames |
			frames := (self model sampleAt: index) frames.
			frame isNil ifTrue: [frame := frames first].
			(self presenterNamed: 'frames')
				list: frames;
				selection: frame	"reverse"].
	(self presenterNamed: 'frames') view layout.
	frame := nil! !
!ProfilerSamplesPresenter categoriesFor: #createComponents!initializing!public! !
!ProfilerSamplesPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!ProfilerSamplesPresenter categoriesFor: #filterNext!filtering!public! !
!ProfilerSamplesPresenter categoriesFor: #filterPrevious!filtering!public! !
!ProfilerSamplesPresenter categoriesFor: #filterSelector:!filtering!public! !
!ProfilerSamplesPresenter categoriesFor: #filterStopped!filtering!public! !
!ProfilerSamplesPresenter categoriesFor: #initialize!initializing!public! !
!ProfilerSamplesPresenter categoriesFor: #model:!accessing!public! !
!ProfilerSamplesPresenter categoriesFor: #onFrameSelectionChanged!event handling!public! !
!ProfilerSamplesPresenter categoriesFor: #onSampleIndexChanged!event handling!public! !
!ProfilerSamplesPresenter categoriesFor: #onViewOpened!event handling!public! !
!ProfilerSamplesPresenter categoriesFor: #parseContext!public! !
!ProfilerSamplesPresenter categoriesFor: #sampleIndicator:!helpers!private! !
!ProfilerSamplesPresenter categoriesFor: #selectedMethod!public! !
!ProfilerSamplesPresenter categoriesFor: #setSampleRange!helpers!private! !
!ProfilerSamplesPresenter categoriesFor: #showSample!helpers!private! !

!ProfilerSamplesPresenter class methodsFor!

defaultModel
	^ProfilerSampleSet name: 'None'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 327686 ##(Smalltalk.Color) #face3d nil 5 nil nil nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 576 nil 482 #default nil 5 nil nil nil 576 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 576 34 2 8 1140850688 1 720 nil 640 nil 5 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 720 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 818 9 9 nil 832 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 818 1 287 818 1021 7 720 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 0 0 0 254 1 0 0 146 0 0 0] 8 #() 818 193 193 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 576 34 2 8 1140850688 131073 1120 nil 482 #window nil 5 nil nil nil 1120 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 866 138 144 34 1 930 #createAt:extent: 34 2 818 1 293 818 1021 289 1120 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 146 0 0 0 254 1 0 0 34 1 0 0] 8 #() 1072 nil 27 8 'workspace' 410 ##(Smalltalk.ListView) 34 30 nil 576 34 2 8 1140953165 1025 1408 590662 2 ##(Smalltalk.ListModel) 138 144 1376 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 640 nil 5 nil nil nil 1408 nil 8 1891845904 ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #profilerIconIndex 8 #() 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Frame' 1013 #left ##(Smalltalk.BasicListAbstract) 1570 #<= 8 #() 1570 #yourself 8 #() nil 1408 1680 3 nil nil #report 1376 nil 131169 nil 34 4 nil nil 818 1 1 nil 866 138 144 34 2 930 #createAt:extent: 34 2 818 1 1 818 1021 287 1408 930 #text: 34 1 8 'Frame' 1408 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 1 0 0 143 0 0 0] 8 #() 1072 nil 27 8 'frames' nil 866 138 144 34 1 930 #createAt:extent: 34 2 818 1 51 818 1021 581 576 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 254 1 0 0 59 1 0 0] 34 3 1408 720 1120 1072 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 2242 #fixedParentRight 1 2242 #fixedParentTop 51 2242 #fixedParentBottom 1 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2320 nil 496 nil 5 nil nil nil 2320 nil 170 192 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 2320 34 2 8 1140850945 1 2416 nil nil nil 5 nil nil nil 2416 nil 8 1891791312 852486 ##(Smalltalk.NullConverter) nil nil nil 866 138 144 34 1 930 #createAt:extent: 34 2 818 1 9 818 351 47 2416 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 4 0 0 0 175 0 0 0 27 0 0 0] 8 #() 1072 nil 27 8 'sampleIndicator' 410 ##(Smalltalk.ScrollBar) 34 16 nil 2320 34 2 8 1140916224 1 2704 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 1570 #= 8 #() 1570 #hash 8 #() 1 640 nil 5 nil nil nil 2704 nil 8 1891970592 2498 nil nil true 866 138 144 34 3 930 #createAt:extent: 34 2 818 471 3 818 431 47 2704 930 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 2704 930 #pageSize: 8 #(0) 2704 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 1 0 0 0 194 1 0 0 24 0 0 0] 8 #() 1072 nil 27 8 'sampleSelector' nil 866 138 144 34 1 930 #createAt:extent: 34 2 818 1 1 818 1021 49 2320 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 254 1 0 0 24 0 0 0] 34 4 2416 410 ##(Smalltalk.PushButton) 34 20 nil 2320 34 2 8 1140924416 1 3360 nil 640 818 81 47 5 nil nil nil 3360 nil 8 1891826416 1180998 4 ##(Smalltalk.CommandDescription) #filterPrevious 8 '<<?' 1 1 nil nil false nil nil nil 866 138 144 34 3 930 #createAt:extent: 34 2 818 381 3 818 81 47 3360 930 #isEnabled: 8 #(false) 3360 930 #text: 34 1 8 '<<?' 3360 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 0 0 0 1 0 0 0 230 0 0 0 24 0 0 0] 8 #() 1072 nil 29 2704 410 ##(Smalltalk.PushButton) 34 20 nil 2320 34 2 8 1140924416 1 3744 nil 640 818 81 47 5 nil nil nil 3744 nil 8 1891826416 3458 #filterNext 8 '?>>' 1 1 nil nil false nil nil nil 866 138 144 34 3 930 #createAt:extent: 34 2 818 911 3 818 81 47 3744 930 #isEnabled: 8 #(false) 3744 930 #text: 34 1 8 '?>>' 3744 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 199 1 0 0 1 0 0 0 239 1 0 0 24 0 0 0] 8 #() 1072 nil 29 1072 nil 27 2210 2256 1 2272 1 2288 1 2288 49 170 192 1376 590342 ##(Smalltalk.Rectangle) 818 1 1 818 1 1 866 138 144 34 1 930 #createAt:extent: 34 2 818 3839 21 818 1021 631 416 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 125 9 0 0 69 1 0 0] 34 2 2320 576 1072 nil 27 )! !
!ProfilerSamplesPresenter class categoriesFor: #defaultModel!models!public! !
!ProfilerSamplesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

