Public Class GameState

  ' We will store our current game state here
  Private fGameState(8) As Boolean?

  ' We will store our current player here, so we know who's turn it is
  Public Property CurrentPlayer As String

  ' We will use gameActive to pause the game in case of an end scenario
  Public Property IsActive As Boolean

  Public Property GameState(index As Integer) As Boolean?
    Get
      Return fGameState(index)
    End Get
    Set (Value As Boolean?)
      fGameState(index) = Value
    End Set
  End Property

End Class