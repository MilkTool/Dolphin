﻿"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #ClassHierarchyDiagram
	instanceVariableNames: 'classesPresenter commentPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassHierarchyDiagram guid: (GUID fromString: '{493664d4-3394-11d3-93bd-00a024ca708a}')!
ClassHierarchyDiagram comment: 'ClassHierarchyDiagram is a <SmalltalkToolShell> that displays the current class hierarchy in a graphical format using a <MoenTreeView>.

Instance Variables:
	classesPresenter	<TreePresenter> displaying the class hierarchy.
	commentPresenter	<SmalltalkWorkspace> displaying the comment of the selected class.

'!
!ClassHierarchyDiagram categoriesForClass!MVP-Presenters! !
!ClassHierarchyDiagram methodsFor!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	classesPresenter := self add: ClassHierarchySelector new name: 'classes'.
	commentPresenter := self add: self workspaceClass new name: 'comment'!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"
	
	super createSchematicWiring.

	classesPresenter 
		when: #actionPerformed send: #browseIt to: classesPresenter;
		when: #selectionChanged send: #onClassSelected to: self!

defaultHelpId
	^10892!

onClassSelected
	"A new class has been selected. Refresh the comment pane"

	commentPresenter clear.
	classesPresenter hasSelection ifTrue: [
		commentPresenter text: classesPresenter selection comment ]!

onViewOpened
	"Private - Received when the receiver's view is been connected. Since the complete hierarchy
	is large, let's occupy most of the available screen area."

	super onViewOpened.
	self view rectangle: (View desktop workArea insetBy: 50).
	classesPresenter expandAll: nil!

searchForClass: aClass 
	classesPresenter selection: aClass instanceClass ifAbsent: [super searchForClass: aClass]! !
!ClassHierarchyDiagram categoriesFor: #canSaveState!private!saved state! !
!ClassHierarchyDiagram categoriesFor: #createComponents!initializing!private! !
!ClassHierarchyDiagram categoriesFor: #createSchematicWiring!initializing!private! !
!ClassHierarchyDiagram categoriesFor: #defaultHelpId!public! !
!ClassHierarchyDiagram categoriesFor: #onClassSelected!event handling!public! !
!ClassHierarchyDiagram categoriesFor: #onViewOpened!event handling!private! !
!ClassHierarchyDiagram categoriesFor: #searchForClass:!private! !

!ClassHierarchyDiagram class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators 
		, #(#(#findClass 'Ctrl+Shift+F') #(#browseClassReferences 'Shift+F12') #(#browseIt 'Ctrl+B') #(#inspectIt 'Ctrl+I'))!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Class Diagram'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1903898080 170 192 34 6 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Search_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 615 1 882 437 51 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 63 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 976 992 nil 27 8 'imageTools' 170 192 976 138 144 976 nil nil 1 nil 882 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 1 882 2369 51 528 834 #updateSizePosted 976 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 160 4 0 0 25 0 0 0] 34 3 1264 1024 672 992 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1760 nil nil nil 7 nil nil nil 1760 738 ##(Smalltalk.ClassHierarchySelector) #resource_Moen_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 2369 1485 1760 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 160 4 0 0 255 2 0 0] 976 992 nil 27 170 192 34 4 1760 8 'classes' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2146 1 2178 #fileOpen 8 '&Open Workspace...' 9375 1 2226 nil true 2272 8 'OpenWorkspace.ico' 2320 nil nil 2146 1 2178 #fileFileIn 8 '&File In...' 1 1 2226 nil true 2272 8 'FileIn.ico' 2320 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2146 1 2178 #saveImage 8 'Sa&ve Image' 1 1 2226 nil true 2272 8 'Snapshot.ico' 2320 nil nil 2146 1 2178 #smalltalkExit 8 'E&xit Dolphin' 1 1 2226 nil true 2272 8 'PowerSwitch.ico' 2320 nil nil 2514 4097 2146 1 2178 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 64227 nil nil 2098 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 64229 nil nil 2098 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 64231 nil nil 2098 nil true 34 15 2146 1 2178 #helpContents 8 '&Contents' 1025 1 2226 nil true 2272 8 'Help.ico' 2320 nil nil 2146 1 2178 #help 8 'On this &Tool' 1249 1 nil nil nil 2146 1 2178 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2514 4097 2146 1 2178 #learnSmalltalk 8 'Learn Smalltalk' 1 1 2770 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 2514 4097 2146 1 2178 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2146 1 2178 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2146 1 2178 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2514 4097 2146 1 2178 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 2226 nil true 2272 8 '!!APPLICATION' 2320 nil nil 2146 1 2178 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2146 1 2178 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2514 4097 2146 1 2178 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2770 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 64255 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 3839 21 882 2401 1653 416 834 #text: 34 1 8 'Class Hierarchy Diagram' 416 834 #updateMenuBar 976 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 47 12 0 0 68 3 0 0] 34 2 528 1760 992 nil 27)!

toolsFolderHelpId
	^10590! !
!ClassHierarchyDiagram class categoriesFor: #defaultAdditionalAccelerators!initializing!private! !
!ClassHierarchyDiagram class categoriesFor: #displayOn:!displaying!public! !
!ClassHierarchyDiagram class categoriesFor: #icon!constants!public! !
!ClassHierarchyDiagram class categoriesFor: #initialize!initializing!private! !
!ClassHierarchyDiagram class categoriesFor: #publishedAspects!public! !
!ClassHierarchyDiagram class categoriesFor: #resource_Default_view!public!resources-views! !
!ClassHierarchyDiagram class categoriesFor: #toolsFolderHelpId!public! !

