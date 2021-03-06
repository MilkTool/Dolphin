﻿"Filed out from Dolphin Smalltalk 7"!

ADODB_ADO subclass: #ADODBConnection15
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBConnection15 guid: (IID fromString: '{00000515-0000-0010-8000-00AA006D2EA4}')!
ADODBConnection15 comment: '<ADODBConnection15> is a wrapper class for the COM interface ''ADODB.Connection15'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBConnection15 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBConnection15 methodsFor!

attributes
	"Answer the <sdword> value of the 'Attributes' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Attributes: answer.
	^answer asObject
!

attributes: plAttr
	"Set the 'Attributes' property of the receiver to the <sdword> value of the argument."

	self put_Attributes: plAttr
!

beginTrans
	"Answer the <SDWORD> result of invoking the BeginTrans() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self BeginTrans: answer.
	^answer asObject
!

BeginTrans: transactionLevel
	"Private - Invoke the BeginTrans() method of the COM object.

		HRESULT __stdcall BeginTrans(
			[out, retval] long* TransactionLevel);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall: _failureCode!

Close
	"Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 16>
	^self invalidCall: _failureCode!

commandTimeout
	"Answer the <sdword> value of the 'CommandTimeout' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_CommandTimeout: answer.
	^answer asObject
!

commandTimeout: plTimeout
	"Set the 'CommandTimeout' property of the receiver to the <sdword> value of the argument."

	self put_CommandTimeout: plTimeout
!

CommitTrans
	"Invoke the CommitTrans() method of the COM object.

		HRESULT __stdcall CommitTrans();"

	<virtual stdcall: hresult 19>
	^self invalidCall: _failureCode!

connectionString
	"Answer the <bstr> value of the 'ConnectionString' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_ConnectionString: answer.
	^answer asObject
!

connectionString: pbstr
	"Set the 'ConnectionString' property of the receiver to the <bstr> value of the argument."

	self put_ConnectionString: pbstr
!

connectionTimeout
	"Answer the <sdword> value of the 'ConnectionTimeout' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_ConnectionTimeout: answer.
	^answer asObject
!

connectionTimeout: plTimeout
	"Set the 'ConnectionTimeout' property of the receiver to the <sdword> value of the argument."

	self put_ConnectionTimeout: plTimeout
!

cursorLocation
	"Answer the <sdword> value of the 'CursorLocation' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_CursorLocation: answer.
	^answer asObject
!

cursorLocation: plCursorLoc
	"Set the 'CursorLocation' property of the receiver to the <sdword> value of the argument."

	self put_CursorLocation: plCursorLoc
!

defaultDatabase
	"Answer the <bstr> value of the 'DefaultDatabase' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_DefaultDatabase: answer.
	^answer asObject
!

defaultDatabase: pbstr
	"Set the 'DefaultDatabase' property of the receiver to the <bstr> value of the argument."

	self put_DefaultDatabase: pbstr
!

errors
	"Answer the <ADODBErrors> value of the 'Errors' property of the receiver."

	| answer |
	answer := ADODBErrors newPointer.
	self get_Errors: answer.
	^answer asObject
!

execute: commandText
	"Invoke the Execute() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 execute: commandText
		 options: -1!

execute: commandText options: options
	"Invoke the Execute() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: VARIANT new;
				basicAt: 2 put: ADODB_Recordset newPointer;
				yourself.
	self
		Execute: commandText
		RecordsAffected: (answer basicAt: 1)
		Options: options
		ppiRset: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

Execute: commandText RecordsAffected: recordsAffected Options: options ppiRset: ppiRset
	"Private - Invoke the Execute() method of the COM object.

		HRESULT __stdcall Execute(
			[in] BSTR CommandText,
			[out, optional] VARIANT* RecordsAffected,
			[in, optional, defaultvalue(-1)] long Options,
			[out, retval] _Recordset** ppiRset);"

	<virtual stdcall: hresult 17 bstr variant* sdword ADODB_Recordset**>
	^self invalidCall: _failureCode!

get_Attributes: plAttr
	"Private - Get the value of the 'Attributes' property of the receiver.
				HRESULT __stdcall Attributes(
			[out, retval] long* plAttr);"

	<virtual stdcall: hresult 27 sdword*>
	^self invalidCall: _failureCode!

get_CommandTimeout: plTimeout
	"Private - Get the value of the 'CommandTimeout' property of the receiver.
				HRESULT __stdcall CommandTimeout(
			[out, retval] long* plTimeout);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_ConnectionString: pbstr
	"Private - Get the value of the 'ConnectionString' property of the receiver.
				HRESULT __stdcall ConnectionString(
			[out, retval] BSTR* pbstr);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

get_ConnectionTimeout: plTimeout
	"Private - Get the value of the 'ConnectionTimeout' property of the receiver.
				HRESULT __stdcall ConnectionTimeout(
			[out, retval] long* plTimeout);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall: _failureCode!

get_CursorLocation: plCursorLoc
	"Private - Get the value of the 'CursorLocation' property of the receiver.
				HRESULT __stdcall CursorLocation(
			[out, retval] CursorLocationEnum* plCursorLoc);"

	<virtual stdcall: hresult 29 sdword*>
	^self invalidCall: _failureCode!

get_DefaultDatabase: pbstr
	"Private - Get the value of the 'DefaultDatabase' property of the receiver.
				HRESULT __stdcall DefaultDatabase(
			[out, retval] BSTR* pbstr);"

	<virtual stdcall: hresult 23 bstr*>
	^self invalidCall: _failureCode!

get_Errors: ppvObject
	"Private - Get the value of the 'Errors' property of the receiver.
				HRESULT __stdcall Errors(
			[out, retval] Errors** ppvObject);"

	<virtual stdcall: hresult 22 ADODBErrors**>
	^self invalidCall: _failureCode!

get_IsolationLevel: level
	"Private - Get the value of the 'IsolationLevel' property of the receiver.
				HRESULT __stdcall IsolationLevel(
			[out, retval] IsolationLevelEnum* Level);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall: _failureCode!

get_Mode: plMode
	"Private - Get the value of the 'Mode' property of the receiver.
				HRESULT __stdcall Mode(
			[out, retval] ConnectModeEnum* plMode);"

	<virtual stdcall: hresult 31 sdword*>
	^self invalidCall: _failureCode!

get_Provider: pbstr
	"Private - Get the value of the 'Provider' property of the receiver.
				HRESULT __stdcall Provider(
			[out, retval] BSTR* pbstr);"

	<virtual stdcall: hresult 33 bstr*>
	^self invalidCall: _failureCode!

get_State: plObjState
	"Private - Get the value of the 'State' property of the receiver.
				HRESULT __stdcall State(
			[out, retval] long* plObjState);"

	<virtual stdcall: hresult 35 sdword*>
	^self invalidCall: _failureCode!

get_Version: pbstr
	"Private - Get the value of the 'Version' property of the receiver.
				HRESULT __stdcall Version(
			[out, retval] BSTR* pbstr);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^true!

isolationLevel
	"Answer the <sdword> value of the 'IsolationLevel' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_IsolationLevel: answer.
	^answer asObject
!

isolationLevel: level
	"Set the 'IsolationLevel' property of the receiver to the <sdword> value of the argument."

	self put_IsolationLevel: level
!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the
	type library, and must perform a run-time check for the _NewEnum property."

	^self has_NewEnum!

mode
	"Answer the <sdword> value of the 'Mode' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Mode: answer.
	^answer asObject
!

mode: plMode
	"Set the 'Mode' property of the receiver to the <sdword> value of the argument."

	self put_Mode: plMode
!

open
	"Invoke the Open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 Open: ''
		 UserID: ''
		 Password: ''
		 Options: -1!

open: aString 
	"Open the database using the specified connection string."

	^self 
		Open: aString
		UserID: ''
		Password: ''
		Options: -1!

Open: connectionString UserID: userID Password: password Options: options
	"Invoke the Open() method of the COM object.

		HRESULT __stdcall Open(
			[in, optional, defaultvalue("

	")] BSTR ConnectionString,
			[in, optional, defaultvalue("

	")] BSTR UserID,
			[in, optional, defaultvalue("

	")] BSTR Password,
			[in, optional, defaultvalue(-1)] long Options);"

	<virtual stdcall: hresult 21 bstr bstr bstr sdword>
	^self invalidCall: _failureCode!

openSchema: schema
	"Answer the <ADODB_Recordset> result of invoking the OpenSchema() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 openSchema: schema
		 restrictions: VARIANT unspecified
		 schemaID: VARIANT unspecified!

openSchema: schema restrictions: restrictions schemaID: schemaID
	"Answer the <ADODB_Recordset> result of invoking the OpenSchema() method of the COM object."

	| answer |
	answer := ADODB_Recordset newPointer.
	self
		OpenSchema: schema
		Restrictions: restrictions asVariant
		SchemaID: schemaID asVariant
		pprset: answer.
	^answer asObject
!

OpenSchema: schema Restrictions: restrictions SchemaID: schemaID pprset: pprset
	"Private - Invoke the OpenSchema() method of the COM object.

		HRESULT __stdcall OpenSchema(
			[in] SchemaEnum Schema,
			[in, optional] VARIANT Restrictions,
			[in, optional] VARIANT SchemaID,
			[out, retval] _Recordset** pprset);"

	<virtual stdcall: hresult 36 sdword variant variant ADODB_Recordset**>
	^self invalidCall: _failureCode!

provider
	"Answer the <bstr> value of the 'Provider' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Provider: answer.
	^answer asObject
!

provider: pbstr
	"Set the 'Provider' property of the receiver to the <bstr> value of the argument."

	self put_Provider: pbstr
!

put_Attributes: plAttr
	"Private - Set the value of the 'Attributes' property of the object wrapped by the 
	 receiver to the <sdword> argument, plAttr.
				HRESULT __stdcall Attributes(
			[in] long plAttr);"

	<virtual stdcall: hresult 28 sdword>
	^self invalidCall: _failureCode!

put_CommandTimeout: plTimeout
	"Private - Set the value of the 'CommandTimeout' property of the object wrapped by the 
	 receiver to the <sdword> argument, plTimeout.
				HRESULT __stdcall CommandTimeout(
			[in] long plTimeout);"

	<virtual stdcall: hresult 12 sdword>
	^self invalidCall: _failureCode!

put_ConnectionString: pbstr
	"Private - Set the value of the 'ConnectionString' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.
				HRESULT __stdcall ConnectionString(
			[in] BSTR pbstr);"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall: _failureCode!

put_ConnectionTimeout: plTimeout
	"Private - Set the value of the 'ConnectionTimeout' property of the object wrapped by the 
	 receiver to the <sdword> argument, plTimeout.
				HRESULT __stdcall ConnectionTimeout(
			[in] long plTimeout);"

	<virtual stdcall: hresult 14 sdword>
	^self invalidCall: _failureCode!

put_CursorLocation: plCursorLoc
	"Private - Set the value of the 'CursorLocation' property of the object wrapped by the 
	 receiver to the <sdword> argument, plCursorLoc.
				HRESULT __stdcall CursorLocation(
			[in] CursorLocationEnum plCursorLoc);"

	<virtual stdcall: hresult 30 sdword>
	^self invalidCall: _failureCode!

put_DefaultDatabase: pbstr
	"Private - Set the value of the 'DefaultDatabase' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.
				HRESULT __stdcall DefaultDatabase(
			[in] BSTR pbstr);"

	<virtual stdcall: hresult 24 bstr>
	^self invalidCall: _failureCode!

put_IsolationLevel: level
	"Private - Set the value of the 'IsolationLevel' property of the object wrapped by the 
	 receiver to the <sdword> argument, level.
				HRESULT __stdcall IsolationLevel(
			[in] IsolationLevelEnum Level);"

	<virtual stdcall: hresult 26 sdword>
	^self invalidCall: _failureCode!

put_Mode: plMode
	"Private - Set the value of the 'Mode' property of the object wrapped by the 
	 receiver to the <sdword> argument, plMode.
				HRESULT __stdcall Mode(
			[in] ConnectModeEnum plMode);"

	<virtual stdcall: hresult 32 sdword>
	^self invalidCall: _failureCode!

put_Provider: pbstr
	"Private - Set the value of the 'Provider' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.
				HRESULT __stdcall Provider(
			[in] BSTR pbstr);"

	<virtual stdcall: hresult 34 bstr>
	^self invalidCall: _failureCode!

query: aString 
	"Execute the SQL in aString.
	Answer an <ADODB_Recordset> representing the resultant result set."

	^(self execute: aString options: adCmdText) second!

RollbackTrans
	"Invoke the RollbackTrans() method of the COM object.

		HRESULT __stdcall RollbackTrans();"

	<virtual stdcall: hresult 20>
	^self invalidCall: _failureCode!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_State: answer.
	^answer asObject
!

value
	"Answer the <bstr> value of the 'ConnectionString' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self connectionString
!

value: pbstr
	"Set the 'ConnectionString' property of the receiver to the <bstr> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self connectionString: pbstr
!

version
	"Answer the <bstr> value of the 'Version' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Version: answer.
	^answer asObject
! !
!ADODBConnection15 categoriesFor: #attributes!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #attributes:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #beginTrans!**auto generated**!methods!public! !
!ADODBConnection15 categoriesFor: #BeginTrans:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #Close!**auto generated**!COM Interfaces-Connection15!public! !
!ADODBConnection15 categoriesFor: #commandTimeout!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #commandTimeout:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #CommitTrans!**auto generated**!COM Interfaces-Connection15!public! !
!ADODBConnection15 categoriesFor: #connectionString!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #connectionString:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #connectionTimeout!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #connectionTimeout:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #cursorLocation!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #cursorLocation:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #defaultDatabase!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #defaultDatabase:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #errors!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #execute:!**auto generated**!methods!public! !
!ADODBConnection15 categoriesFor: #execute:options:!**auto generated**!methods!public! !
!ADODBConnection15 categoriesFor: #Execute:RecordsAffected:Options:ppiRset:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_Attributes:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_CommandTimeout:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_ConnectionString:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_ConnectionTimeout:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_CursorLocation:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_DefaultDatabase:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_Errors:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_IsolationLevel:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_Mode:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_Provider:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_State:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #get_Version:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODBConnection15 categoriesFor: #isolationLevel!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #isolationLevel:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODBConnection15 categoriesFor: #mode!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #mode:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #open!**auto generated**!methods!public! !
!ADODBConnection15 categoriesFor: #open:!operations!public! !
!ADODBConnection15 categoriesFor: #Open:UserID:Password:Options:!**auto generated**!COM Interfaces-Connection15!public! !
!ADODBConnection15 categoriesFor: #openSchema:!**auto generated**!methods!public! !
!ADODBConnection15 categoriesFor: #openSchema:restrictions:schemaID:!**auto generated**!methods!public! !
!ADODBConnection15 categoriesFor: #OpenSchema:Restrictions:SchemaID:pprset:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #provider!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #provider:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #put_Attributes:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #put_CommandTimeout:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #put_ConnectionString:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #put_ConnectionTimeout:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #put_CursorLocation:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #put_DefaultDatabase:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #put_IsolationLevel:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #put_Mode:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #put_Provider:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODBConnection15 categoriesFor: #query:!executing!public! !
!ADODBConnection15 categoriesFor: #RollbackTrans!**auto generated**!COM Interfaces-Connection15!public! !
!ADODBConnection15 categoriesFor: #state!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #value!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #value:!**auto generated**!properties!public! !
!ADODBConnection15 categoriesFor: #version!**auto generated**!properties!public! !

!ADODBConnection15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Connection15'
		ADODBConnection15 defineTemplate"

	self
		defineFunction: #get_ConnectionString:
			argumentTypes: 'bstr*';
		defineFunction: #put_ConnectionString:
			argumentTypes: 'bstr';
		defineFunction: #get_CommandTimeout:
			argumentTypes: 'sdword*';
		defineFunction: #put_CommandTimeout:
			argumentTypes: 'sdword';
		defineFunction: #get_ConnectionTimeout:
			argumentTypes: 'sdword*';
		defineFunction: #put_ConnectionTimeout:
			argumentTypes: 'sdword';
		defineFunction: #get_Version:
			argumentTypes: 'bstr*';
		defineFunction: #Close;
		defineFunction: #Execute:RecordsAffected:Options:ppiRset:
			argumentTypes: 'bstr variant* sdword ADODB_Recordset**';
		defineFunction: #BeginTrans:
			argumentTypes: 'sdword*';
		defineFunction: #CommitTrans;
		defineFunction: #RollbackTrans;
		defineFunction: #Open:UserID:Password:Options:
			argumentTypes: 'bstr bstr bstr sdword';
		defineFunction: #get_Errors:
			argumentTypes: 'ADODBErrors**';
		defineFunction: #get_DefaultDatabase:
			argumentTypes: 'bstr*';
		defineFunction: #put_DefaultDatabase:
			argumentTypes: 'bstr';
		defineFunction: #get_IsolationLevel:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsolationLevel:
			argumentTypes: 'sdword';
		defineFunction: #get_Attributes:
			argumentTypes: 'sdword*';
		defineFunction: #put_Attributes:
			argumentTypes: 'sdword';
		defineFunction: #get_CursorLocation:
			argumentTypes: 'sdword*';
		defineFunction: #put_CursorLocation:
			argumentTypes: 'sdword';
		defineFunction: #get_Mode:
			argumentTypes: 'sdword*';
		defineFunction: #put_Mode:
			argumentTypes: 'sdword';
		defineFunction: #get_Provider:
			argumentTypes: 'bstr*';
		defineFunction: #put_Provider:
			argumentTypes: 'bstr';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #OpenSchema:Restrictions:SchemaID:pprset:
			argumentTypes: 'sdword variant variant ADODB_Recordset**'
! !
!ADODBConnection15 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

