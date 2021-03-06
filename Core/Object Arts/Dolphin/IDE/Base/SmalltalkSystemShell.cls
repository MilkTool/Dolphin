﻿"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #SmalltalkSystemShell
	instanceVariableNames: 'systemFolderPresenter'
	classVariableNames: 'Backcolor BackImage BackImageAlphaPercent BackImageIsTiled Default HotKey PlaySystemSounds ResetWhenInvisible Textcolor ViewMode'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkSystemShell guid: (GUID fromString: '{87b4c6c3-026e-11d3-9fd7-00a0cc3e4a32}')!
SmalltalkSystemShell comment: 'SmalltalkSystemShell is a <SmalltalkToolShell> that implements the user interface onto theDolphin Smalltalk system folder. This an iconic daunting point for all of the installed tools, sample applications etc.

Instance Variables:
	systemFolderPresenter		<FolderPresenter> displaying the system folder hierarchy.

Class Variables:
	Default				<SmalltalkSystemShell> which is the singleton instance.
	DefaultBackcolor			<color> for the background of the folder.




'!
!SmalltalkSystemShell categoriesForClass!MVP-Presenters! !
!SmalltalkSystemShell methodsFor!

addToCommandRoute: route 
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer the next <Presenter> to visit. The receiver is
	guaranteed not to be on the command path already."

	"Implementation Note: We add folder presenter to the command route so that the navigation
	buttons and view options are enabled even whent the search field has focus."

	| next |
	next := super addToCommandRoute: route.
	systemFolderPresenter addToCommandRoute: route.
	^next!

applyOptions
	"Private - Apply the class options to the receiver"

	super applyOptions.
	(systemFolderPresenter view)
		backcolor: self class backcolor;
		backImage: self class backImage;
		backImageIsTiled: self class backImageIsTiled;
		backImageAlphaPercent: self class backImageAlphaPercent;
		forecolor: self class textcolor;
		viewMode: self class viewMode!

browseCompilationFailures
	"Open a method browser on all methods in the system which have failed compilation (i.e.
	which are instances of CompileFailedMethod)."

	self systemModel browseCompilationFailuresIn: self searchEnvironment!

browseCompilationIssues
	"Open a method browser on all methods in the system which have failed compilation (i.e.
	which are instances of CompileFailedMethod)."

	self systemModel browseCompilationIssuesIn: self searchEnvironment!

browseDeprecatedMethods
	self browseMethodCategory: '*-deprecated'!

browseMessageDefinitions
	"Prompt for a selector and open a method browser displaying the implementors of that
	selector."

	self model browseMessageDefinitionsIn: self searchEnvironment!

browseMessageReferences
	"Prompt for a selector and open a method browser displaying the references to that
	selector, using the the first word of the clipboard text as the initial suggestion."

	self model browseMessageReferencesIn: self searchEnvironment!

browseMethodCategory: aMethodCategory
	self model browseMethodCategories: {aMethodCategory} in: self searchEnvironment!

browseNotYetImplemented
	self browseMethodCategory: '*-not yet implemented'!

browseUnclassifiedMethods
	self browseMethodCategory: '*-unclassified'!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	systemFolderPresenter := (self
				add: (FolderPresenter new beSorted: [:a :b | a description < b description])
				name: 'systemFolder')
				openBlock: [:presenter :item | item openIn: presenter];
				yourself!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self.
	SessionManager current 
		when: #imageSaveCompleted
		send: #updateCaption
		to: self!

defaultHelpId
	^10626!

initialize
	"Private - Initialize the receiver. 
	Ensure the Transcript is available"

	super initialize.
	TranscriptShell current!

inspectSystemOptions
	"Open a <PropertyInspector> on the system options."

	^(self model inspectSystemOptions)
		selectionOrNil: self class;
		yourself!

model: aSmalltalkSystem
	"Connects the receiver to aSmalltalkSystem.
	The systemFolderPresenter displays the contents of the #systemFolder
	aspect of the model"

	super model: aSmalltalkSystem.
	systemFolderPresenter model: aSmalltalkSystem systemFolder!

onCloseRequested: aBooleanValue
	"Private - Request to shut the session down. If the request is unacceptable then
	set the value of the out parameter, aBooleanValue to false"

	self == self class default ifTrue: [
		"This is the root system shell closing then shut down system"
		self model smalltalkExit.
		aBooleanValue value: false ]!

onHotKey: anInteger 
	anInteger = 1000 ifTrue: [self view show; beForeground].
	super onHotKey: anInteger!

onPositionChanged: aPositionEvent
	"Private - Handler for a change in position (resize or move) of the receiver's view."

	(aPositionEvent isResize and: [aPositionEvent  isVisibilityChange not]) ifTrue: [self rememberThisSize].
	^super onPositionChanged: aPositionEvent!

onViewCreated
	"Private - The receiver's has been created (that is the CreateWindow() API call has returned), but may
	not yet be connected to the receiver (if the view-presenter pair is being instantiated, then
	the connection will not have been made, but if the view is being restored from saved state
	in the image then the presenter will be connected). This is an appropriate point for
	subclasses to apply any dynamic view configuration that must be performed every time the
	view is created. Typically this might involve customising some feature of the view that it
	does not itself save, perhaps because a feature of the underlying control does not have full
	support in the wrapper class. Note that one should normally override #onViewAvailable to
	restore user configuration settings, since the views will normally save and restore all
	relevant settings across an image save."

	self registerHotKey.
	^super onViewCreated!

onViewDestroyed
	"Private - Handler for view final view destruction. This is sent on receipt of WM_NCDESTROY,
	and is expected to be the last communication from Windows. There is nothing
	more we can do to save the patient. No event is triggered."

	SessionManager current removeEventsTriggeredFor: self.
	self unregisterHotKey.
	self == Default ifTrue: [Default := nil].
	super onViewDestroyed!

onViewModeChanged
	"Private - Event handler for view mode changed. Save the new mode to the user preferences"

	self class viewMode: systemFolderPresenter view viewMode!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	| toolbar |
	super onViewOpened.
	systemFolderPresenter selectionByIndex: 1.
	toolbar := self view viewNamed: 'systemShellTools'.
	toolbar presenterConnectionPoint 
		when: #dropDown:
		send: #onDropDown:
		to: systemFolderPresenter view.
	systemFolderPresenter view 
		when: #viewModeChanged
		send: #onViewModeChanged
		to: self!

properties
	^systemFolderPresenter selection tool inspect!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector |
	selector := aCommandQuery commandSymbol.
	selector == #properties 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (systemFolderPresenter hasSelection and: [systemFolderPresenter selection tool notNil]).
			^true].
	selector == #whatsThis 
		ifTrue: 
			[aCommandQuery isEnabled: systemFolderPresenter hasSelection.
			^true].
	^super queryCommand: aCommandQuery!

registerHotKey
	| codes flags modifiers |
	HotKey isNil ifTrue: [^self].
	codes := AcceleratorTable splitKeyCode: HotKey.
	flags := codes last.
	modifiers := 0.
	(flags allMask: FALT) ifTrue: [modifiers := modifiers bitOr: MOD_ALT].
	(flags allMask: FCONTROL) ifTrue: [modifiers := modifiers bitOr: MOD_CONTROL].
	(flags allMask: FSHIFT) ifTrue: [modifiers := modifiers bitOr: MOD_SHIFT].
	self view 
		registerHotKeyId: 1000
		modifiers: modifiers
		vkey: codes first!

resetSelection
	"Private - Reset any selection in the receiver."

	systemFolderPresenter selectionByIndex: 1
!

resetWhenInvisible
	"Answer whether the SystemFolder should be reset (i.e. a new launcher opened) when there are no visible windows.
	Note that this can be triggered by virtual desktop managers such as MSVDM, as these work by either hiding or moving
	the windows entirely off screen. The system detects this as having no visible windows, and therefore "!

searchEnvironment
	^self model systemEnvironment!

systemFolderPresenter
	^systemFolderPresenter!

unregisterHotKey
	self view unregisterHotKeyId: 1000
!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	| sesh txt |
	sesh := SessionManager current.
	txt := '<1s> - <2s>' expandMacrosWith: sesh applicationName
				with: (File splitFilenameFrom: sesh imageFileName).
	SessionManager current bootInfo ifNotNil: [:info | txt := txt , ' - ' , info].
	self caption: txt!

whatsThis
	systemFolderPresenter selection whatsThis ! !
!SmalltalkSystemShell categoriesFor: #addToCommandRoute:!commands!public! !
!SmalltalkSystemShell categoriesFor: #applyOptions!operations!options!private! !
!SmalltalkSystemShell categoriesFor: #browseCompilationFailures!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseCompilationIssues!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseDeprecatedMethods!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseMessageDefinitions!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseMessageReferences!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseMethodCategory:!browsing!private! !
!SmalltalkSystemShell categoriesFor: #browseNotYetImplemented!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #browseUnclassifiedMethods!browsing!commands!public! !
!SmalltalkSystemShell categoriesFor: #createComponents!**auto generated**!initializing!public! !
!SmalltalkSystemShell categoriesFor: #createSchematicWiring!initializing!public! !
!SmalltalkSystemShell categoriesFor: #defaultHelpId!constants!public! !
!SmalltalkSystemShell categoriesFor: #initialize!initializing!private! !
!SmalltalkSystemShell categoriesFor: #inspectSystemOptions!commands!public! !
!SmalltalkSystemShell categoriesFor: #model:!accessing!public! !
!SmalltalkSystemShell categoriesFor: #onCloseRequested:!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onHotKey:!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onPositionChanged:!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onViewCreated!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onViewDestroyed!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onViewModeChanged!event handling!private! !
!SmalltalkSystemShell categoriesFor: #onViewOpened!event handling!private! !
!SmalltalkSystemShell categoriesFor: #properties!commands!public! !
!SmalltalkSystemShell categoriesFor: #queryCommand:!commands!private! !
!SmalltalkSystemShell categoriesFor: #registerHotKey!helpers!private! !
!SmalltalkSystemShell categoriesFor: #resetSelection!event handling!private! !
!SmalltalkSystemShell categoriesFor: #resetWhenInvisible!options!public! !
!SmalltalkSystemShell categoriesFor: #searchEnvironment!commands!public! !
!SmalltalkSystemShell categoriesFor: #systemFolderPresenter!accessing!private! !
!SmalltalkSystemShell categoriesFor: #unregisterHotKey!helpers!private! !
!SmalltalkSystemShell categoriesFor: #updateCaption!public!updating! !
!SmalltalkSystemShell categoriesFor: #whatsThis!commands!public! !

!SmalltalkSystemShell class methodsFor!

applyOptions
	self allSubinstances do: [:each | each applyOptions]!

backcolor
	"Answer the default background to use for instances of the receiver"

	^self getBackcolor actualColor!

backcolor: aColorOrNil
	"Set the background to use for instances of the receiver"

	self getBackcolor actualColor: (aColorOrNil ifNil: [self defaultBackcolor]).
	self applyOptions!

backImage
	"Answe the background image to use for instances of the receiver"

	^BackImage!

backImage: aBitmapOrNil 
	"Set the background image to use for instances of the receiver"

	BackImage := aBitmapOrNil.
	self applyOptions!

backImageAlphaPercent
	"Answer the background image alpha for instances of the receiver"

	BackImageAlphaPercent ifNil: [BackImageAlphaPercent := 80].
	^BackImageAlphaPercent!

backImageAlphaPercent: anInteger 
	"Set the background image alpha for instances of the receiver"

	BackImageAlphaPercent := anInteger.
	self applyOptions!

backImageIsTiled
	"Answer the tiling mode to use for the background image of instances of the receiver"

	BackImageIsTiled ifNil: [BackImageIsTiled := true].
	^BackImageIsTiled!

backImageIsTiled: aBoolean 
	"Set the tiling mode to use for the background image of instances of the receiver"

	BackImageIsTiled := aBoolean.
	self applyOptions!

default
	"Answer the default instance of the receiver

	SmalltalkSystemShell default
"

	Default isNil ifTrue: [Default := self show].
	^Default!

defaultBackcolor
	"Private - Answer the default background to use for instances of the receiver"

	^Color
		r: 41
		g: 124
		b: 182!

defaultBackImage
	^nil!

defaultTextcolor
	^Color brightness: 243/255!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'System Folder'!

firstReset
	"Private - Reset the class for first use. 
	Force the creation of an new default instance of the receiver
	
	self firstReset
	"

	self reset.
	self default systemModel helpContents!

free
	"Close and release the current system shell (e.g. to create a runtime image).
	Also close the associated Transcript"

	TranscriptShell free.
	Default notNil
		ifTrue: 
			[Default view destroy.
			Default := nil]!

getBackcolor
	^Backcolor ifNil: [Backcolor := ThemeColor addNamed: #smalltalkSystem color: self defaultBackcolor]!

hotKey
	"Answer the hot key that can be used to bring the system shell into the foreground even when
	minimised or if another application is active."

	^HotKey ?? 0!

hotKey: anInteger 
	"Set the hot key that can be used to bring the system shell into the foreground even when
	minimised or if another application is active."

	| open |
	open := Default notNil and: [Default isOpen].
	open ifTrue: [Default unregisterHotKey].
	HotKey := anInteger = 0 ifFalse: [anInteger].
	open ifTrue: [Default registerHotKey]!

icon
	"Answers an Icon that can be used to represent this class"

	^Smalltalk developmentSystem icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	Smalltalk developmentSystem
		registerTool: self;
		systemFolderClass: self.
	self backImage: self defaultBackImage.
	self backcolor: self defaultBackcolor.
	self textcolor: self defaultTextcolor.
	self viewMode: #thumbnails.
	self playSystemSounds: true.
	self resetWhenInvisible: false.
	HotKey := AcceleratorTable keyCodeFromInvariantString: 'CTRL+ALT+D'!

onNoVisibleWindows
	"The system has detected that there are no visible windows. If so configured, open a new
	launcher. This is off by default because certain virtual desktop managers may otherwise
	cause the launcher to be reset each time the user switches to a new desktop, causing the
	launcher to appear to follow the user around between desktops."

	self resetWhenInvisible ifTrue: [self reset]!

onStartup
	"Private - The development system is starting, perform initialization actions.
	Sent after windows are restored."

	"Cause the desktop icon title font to be picked up correctly"
	SmalltalkSystem current defaultFont isNil ifTrue: [SmalltalkSystem current defaultFont: nil].

	"Update the SmalltalkSystemShell caption to show current image file name. This
	may have changed if the .img/.exe has been copied outside of Dolphin.
	Have to perform this after windows have been recreated or else they
	will just show the caption when the image was saved."
	self default updateCaption.


!

playSystemSounds
	"Answer true if the IDE sounds are turned on"

	^PlaySystemSounds
		
!

playSystemSounds: aBoolean
	"Sets wherher the IDE sounds are turned on"

	PlaySystemSounds := aBoolean
		
!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published the receiver."

	^(super publishedAspects)
		removeKey: #reuseIfOpen;
		add: (Aspect color: #backcolor);
		add: (Aspect color: #textcolor);
		add: (Aspect bitmap: #backImage);
		add: (Aspect boolean: #backImageIsTiled);
		add: (Aspect integer: #backImageAlphaPercent);
		add: (Aspect choice: #viewMode from: #(#smallIcons #largeIcons #tileIcons #list #report));
		add: (Aspect boolean: #playSystemSounds);
		add: (Aspect hotkey: #hotKey);
		add: (Aspect boolean: #resetWhenInvisible);
		yourself!

reset
	"Private - Reset the class. 
	Force the creation of an new default instance of the receiver

	self reset
	"

	self
		free;
		default.
!

resetWhenInvisible
	^ResetWhenInvisible!

resetWhenInvisible: aBoolean 
	ResetWhenInvisible := aBoolean!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 37 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853572 131073 528 nil nil nil 519 nil nil nil 528 nil 8 1867527152 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 850 63 51 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 850 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 992 nil nil nil 7 nil nil nil 992 706 ##(Smalltalk.Toolbar) #resource_Search_tools nil 738 138 144 34 1 802 #createAt:extent: 34 2 850 615 1 850 437 51 992 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 944 960 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 706 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 738 138 144 34 1 802 #createAt:extent: 34 2 850 63 1 850 553 51 1232 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 944 960 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853572 65 1472 nil nil nil 519 nil nil nil 1472 nil 8 1867527152 170 192 944 170 192 34 8 39729 1115206 1 ##(Smalltalk.ToolbarIconButton) 1472 17 1180998 4 ##(Smalltalk.CommandDescription) #viewModeSelect 8 'Views' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ViewMode.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 39729 39727 1602 1472 1 1634 #historyForward 8 'Forward' 1 1 1682 nil true 1728 8 'HistoryForward.ico' 1776 39727 39725 1602 1472 1 1634 #historyBack 8 'Back' 1 1 1682 nil true 1728 8 'HistoryBack.ico' 1776 39725 39723 1602 1472 1 1634 #up 8 'Up' 1 1 1682 nil true 1728 8 'FolderUp.ico' 1776 39723 34 6 1968 1888 1808 1049158 1 ##(Smalltalk.ToolbarSeparator) 1472 1 1616 2066 1472 1 nil nil 1 nil nil nil nil nil 738 138 144 34 1 802 #createAt:extent: 34 2 850 1051 1 850 247 51 1472 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 8 #() 960 nil 27 8 'systemShellTools' 170 192 944 138 144 944 nil nil 1 nil 850 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 850 1 1 850 1509 51 528 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 2 0 0 25 0 0 0] 34 4 640 1232 992 1472 960 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2528 nil nil nil 7 nil nil nil 2528 498 1 1 nil nil nil nil 410 ##(Smalltalk.ListView) 34 45 nil 2528 34 2 8 1140937036 1 2608 590662 2 ##(Smalltalk.ListModel) 138 144 944 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 3 984134 2 ##(Smalltalk.CommandMenuItem) 1 1634 #properties 8 '&Properties' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2834 1 1634 #whatsThis 8 '&What''s This?' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2608 nil 8 1867533600 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 106 8 'Dolphin List Presenter' 8 'BasicListAbstract' 8 'doIt' 8 '[:item | item description]' 8 #[30 105 17 158 106] #description 3024 7 257 nil ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 850 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 1119 #left 3010 0 nil 3042 2 1 3072 8 'doIt' 8 '[:item | item description]' 8 #[30 105 17 158 106] #description 3296 7 257 nil 459270 ##(Smalltalk.Message) #<= 8 #() 3378 #yourself 8 #() nil 2608 3248 3 nil nil #thumbnails 944 850 241 241 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 850 1 1 850 1509 713 2608 802 #contextMenu: 34 1 2800 2608 802 #text: 34 1 8 'Column 1' 2608 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 242 2 0 0 100 1 0 0] 8 #() 960 nil 35 170 192 34 2 2608 8 'systemFolder' nil 738 138 144 34 1 802 #createAt:extent: 34 2 850 1 51 850 1509 713 2528 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 242 2 0 0 125 1 0 0] 34 1 2608 960 nil 27 170 192 34 2 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 5 2786 nil true 34 10 2834 1 1634 #newWorkspace 8 '&New Workspace' 9373 1 1682 nil true 1728 8 'NewWorkspace.ico' 1776 nil nil 2834 1 1634 #openWorkspace 8 '&Open Workspace...' 9375 1 1682 nil true 1728 8 'OpenWorkspace.ico' 1776 nil nil 2834 1 1634 #fileFileIn 8 '&File In...' 1 1 1682 nil true 1728 8 'FileIn.ico' 1776 nil nil 2898 4097 2834 1 1634 #saveImage 8 'Sa&ve Image' 1 1 1682 nil true 1728 8 'Snapshot.ico' 1776 nil nil 2834 1 1634 #saveImageAs 8 'Save Image As...' 1 1 nil nil nil 2834 1 1634 #compressChanges 8 '&Compress Changes...' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $\x1F5DC nil nil 2754 #navy nil nil 1 nil nil nil nil 2834 1 1634 #compressSources 8 'Co&mpress Sources...' 1 1 nil nil nil 2898 4097 2834 1 1634 #smalltalkExit 8 'E&xit Dolphin' 1 1 1682 nil true 1728 8 'PowerSwitch.ico' 1776 nil nil 8 '&File' nil 134217729 nil nil 39747 nil nil 2786 nil true 34 12 2834 1 1634 #browseHierarchy 8 '&Classes' 1 1 1682 nil true 1728 8 'ClassBrowserShell.ico' 1776 nil nil 2834 1 1634 #browsePackages 8 '&Packages' 1 1 1682 nil true 1728 8 'Package.ico' 1776 nil nil 2834 1 1634 #browseProtocols 8 'Pr&otocols' 1 1 1682 nil true 1728 8 'MethodProtocol.ico' 1776 nil nil 2834 1 1634 #browseResources 8 '&Resources' 1 1 1682 nil true 1728 8 'ResourceBrowser.ico' 1776 nil nil 2834 1 1634 #browseSystem 8 'S&ystem' 1 1 1682 nil true 1728 8 'SystemBrowserShell.ico' 1776 nil nil 2898 4097 2834 1 1634 #browseMessageDefinitions 8 'All &Definitions Of...' 1 1 nil nil nil 2834 1 1634 #browseMessageReferences 8 'All Re&ferences To...' 1 1 nil nil nil 2834 1 1634 3378 #browseReferencesToGlobal: 34 1 8 '' 8 'References to Global...' 1 1 nil nil nil 2834 1 1634 #browseContainingText 8 'Containing &Text...' 1 1 1682 nil true 1728 47 786694 ##(Smalltalk.ShellLibrary) nil nil 2834 1 1634 #browseAllUnimplementedSelectors 8 'All &Unimplemented' 1 1 nil nil nil 2786 nil true 34 5 2834 1 1634 #browseCompilationFailures 8 '&Compilation Failures' 1 1 1682 nil true 1728 8 'CompileFailedMethod.ico' 1776 nil nil 2834 1 1634 #browseDeprecatedMethods 8 '&Deprecated' 1 1 1682 nil true 1728 65031 1 nil nil 2834 1 1634 #browseNotYetImplemented 8 '&Not Yet Implemented' 1 1 nil nil nil 2834 1 1634 #browseUnclassifiedMethods 8 '&Unclassified' 1 1 nil nil nil 2834 1 1634 #browseMethodCategory 8 '&Other...' 1 1 nil nil nil 8 'Method Cate&gory' nil 134217729 1682 nil true 1728 8 'Category.ico' 1776 nil 39779 nil nil 8 '&Browse' nil 134217729 nil nil 39781 nil nil 2786 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 39783 nil nil 2786 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 39785 nil nil 2786 nil true 34 15 2834 1 1634 #helpContents 8 '&Contents' 1025 1 1682 nil true 1728 8 'Help.ico' 1776 nil nil 2834 1 1634 #help 8 'On this &Tool' 1249 1 nil nil nil 2834 1 1634 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 2898 4097 2834 1 1634 #learnSmalltalk 8 'Learn Smalltalk' 1 1 4482 $\x1F393 nil 2754 #orchid 2754 #white nil nil 1 nil nil nil nil 2898 4097 2834 1 1634 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 2834 1 1634 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 2834 1 1634 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 2898 4097 2834 1 1634 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1682 nil true 1728 8 '!!APPLICATION' 1776 nil nil 2834 1 1634 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 2834 1 1634 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 2898 4097 2834 1 1634 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4482 $\x1F42C nil nil 2754 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 39809 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil 850 2049 2049 nil 1 nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 850 7039 21 850 1541 881 416 802 #text: 34 1 8 'Dolphin Smalltalk' 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 193 16 0 0 194 1 0 0] 34 2 528 2528 960 nil 27 )!

textcolor
	"Answer the text color to use for instances of the receiver"

	^Textcolor!

textcolor: aColorOrNil
	"Set the text color to use for instances of the receiver"

	Textcolor := aColorOrNil.
	self applyOptions
	!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	| devsys |
	Color removeNamed: #smalltalkSystem.
	self free.
	devsys := Smalltalk developmentSystem.
	devsys systemFolderClass == self ifTrue: [devsys systemFolderClass: nil]!

viewMode
	"Answer the view mode of the reciver.
	This can be one of:
		#report 
		#extraLargeIcons 
		#thumbnails 
		#tileIcons 
		#largeIcons 
		#smallIcons"

	^ViewMode
		
!

viewMode: aSymbol
	"Sets the view mode of the reciver to aSymbol.
	This can be one of:
		#smallIcons
		#largeIcons
		#tileIcons
		#list
		#report"

	ViewMode := aSymbol.
	self applyOptions! !
!SmalltalkSystemShell class categoriesFor: #applyOptions!accessing!options!private! !
!SmalltalkSystemShell class categoriesFor: #backcolor!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backcolor:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImage!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImage:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImageAlphaPercent!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImageAlphaPercent:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImageIsTiled!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #backImageIsTiled:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #default!instance creation!public! !
!SmalltalkSystemShell class categoriesFor: #defaultBackcolor!accessing!options!private! !
!SmalltalkSystemShell class categoriesFor: #defaultBackImage!private! !
!SmalltalkSystemShell class categoriesFor: #defaultTextcolor!private! !
!SmalltalkSystemShell class categoriesFor: #displayOn:!displaying!public! !
!SmalltalkSystemShell class categoriesFor: #firstReset!private! !
!SmalltalkSystemShell class categoriesFor: #free!public!realizing/unrealizing! !
!SmalltalkSystemShell class categoriesFor: #getBackcolor!accessing!options!private! !
!SmalltalkSystemShell class categoriesFor: #hotKey!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #hotKey:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #icon!constants!public! !
!SmalltalkSystemShell class categoriesFor: #initialize!initializing!private! !
!SmalltalkSystemShell class categoriesFor: #onNoVisibleWindows!public! !
!SmalltalkSystemShell class categoriesFor: #onStartup!events-session!private! !
!SmalltalkSystemShell class categoriesFor: #playSystemSounds!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #playSystemSounds:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #publishedAspects!constants!public! !
!SmalltalkSystemShell class categoriesFor: #reset!operations!public! !
!SmalltalkSystemShell class categoriesFor: #resetWhenInvisible!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #resetWhenInvisible:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #resource_Default_view!public!resources-views! !
!SmalltalkSystemShell class categoriesFor: #textcolor!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #textcolor:!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!SmalltalkSystemShell class categoriesFor: #viewMode!accessing!options!public! !
!SmalltalkSystemShell class categoriesFor: #viewMode:!accessing!options!public! !

