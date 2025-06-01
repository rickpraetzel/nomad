#tag Module
Protected Module Module1
	#tag Method, Flags = &h0
		Sub LoadDeusDefaultConstants()
		  dim sqlstring as string
		  dim rs as rowset
		  dim givendeus as deusclass
		  
		  sqlstring = "SELECT * from deussettings"
		  
		  TRY
		    rs = MySQLdb.SelectSQL(sqlstring)
		    if rs <> nil then
		      if not rs.afterlastrow then
		        while not rs.AfterLastRow
		          givendeus = new DeusClass
		          givendeus.serial = rs.Column("deusserial").StringValue
		          givendeus.defaultdrop = rs.Column("deusdefaultdrop").IntegerValue
		          givendeus.defaultweight = rs.Column("deusdefaultweight").IntegerValue
		          deuslist.append givendeus
		          rs.MoveToNextRow
		        wend
		      end if
		    end if
		  CATCH err as DatabaseException
		    MessageBox "Failed to load deus settings."
		  END TRY
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		dbhost As string
	#tag EndProperty

	#tag Property, Flags = &h0
		dbname As string
	#tag EndProperty

	#tag Property, Flags = &h0
		dbpassword As string
	#tag EndProperty

	#tag Property, Flags = &h0
		dbport As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		dbtestname As string
	#tag EndProperty

	#tag Property, Flags = &h0
		dbtimeout As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		dbusername As string
	#tag EndProperty

	#tag Property, Flags = &h0
		deuslist() As deusclass
	#tag EndProperty

	#tag Property, Flags = &h0
		mysqldb As MySQLCommunityServer
	#tag EndProperty

	#tag Property, Flags = &h0
		operations As string = "app.kNormalMode"
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="dbusername"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dbpassword"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dbhost"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dbname"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dbport"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="dbtestname"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="operations"
			Visible=false
			Group="Behavior"
			InitialValue="app.kNormalMode"
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="dbtimeout"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
