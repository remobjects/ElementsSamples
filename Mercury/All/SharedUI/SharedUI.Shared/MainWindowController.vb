Public Partial Class MainWindowController

  <Notify>
  Public Property valueA As String
  <Notify>
  Public Property valueB As String

  <Notify>
  Public Property result As String = "N/A"

  Private Sub setup()
	'
	'  Do any shared initilaization, here
	'
  End Sub

  <IBAction>
  Public Sub calculateResult(sender As id)
	If (length(valueA) = 0) OrElse (length(valueB) = 0) Then
	  result = "(value required)"
	Else
	  Dim a = Convert.TryToDoubleInvariant(valueA)
	  Dim b = Convert.TryToDoubleInvariant(valueB)
	  If a IsNot Nothing AndAlso b IsNot Nothing Then
		result = Convert.ToString(a + b)
	  Else
		result = valueA + valueB
	  End If
	End If
  End Sub

End Class