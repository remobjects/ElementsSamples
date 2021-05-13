Imports RemObjects.Elements.WebAssembly.DOM

Public class index
  ' The game state
  Dim gs As GameState

  ' The win conditions
  Private WinCondition(7)(2) As Integer = {{0, 1, 2},
                                           {3, 4, 5},
                                           {6, 7, 8},
                                           {0, 3, 6},
                                           {1, 4, 7},
                                           {2, 5, 8},
                                           {0, 4, 8},
                                           {2, 4, 6}}

  Public Sub New()
    ' make sure this is the first call in the sub new (after a call to MyBase.New if that is needed)
    InitializeComponents
    ' start the game
    HandleRestartGame(Nothing, Nothing)
  End Sub

  Private Sub HandleRestartGame(sender As HTMLElement, e As MouseEvent) Handles btnRestart.onclick
    Cell0.innerText = ""
    Cell1.innerText = ""
    Cell2.innerText = ""
    Cell3.innerText = ""
    Cell4.innerText = ""
    Cell5.innerText = ""
    Cell6.innerText = ""
    Cell7.innerText = ""
    Cell8.innerText = ""
    ' Empty the game state
    gs = New GameState
    ' Set turn to X and show this
    gs.CurrentPlayer = "O"
    PlayerChange
    ' Set the game active
    gs.IsActive = True
    btnRestart.hidden = True
  End Sub

  Private Sub PlayerChange()
    ' Show who's turn it is
    gs.CurrentPlayer = if(gs.CurrentPlayer = "O", "X", "O")
    StatusDisplay.innerHTML = $"It's {gs.CurrentPlayer}'s turn"
  End Sub

  Public Sub HandleCellClick(sender as HTMLElement, e As MouseEvent) Handles Cell0.onclick, Cell1.onclick, Cell2.onclick, Cell3.onclick, Cell4.onclick,
                                                                             Cell5.onclick, Cell6.onclick, Cell7.onclick, Cell8.onclick
    ' Here we will grab the 'data-cell-index' attribute from the clicked cell to identify where that cell is in our grid.
    Dim clickedCellIndex As Integer = CInt(Val(sender.getAttribute("data-cell-index")))

    ' We need to check whether the call has already been played, or if the game is inactive.
    ' If either of those is true we will simply ignore the click.
    If gs.GameState(clickedCellIndex).HasValue OrElse Not gs.IsActive Then
      Exit Sub
    End If

    ' Place the X or the O in the GameState
    gs.GameState(clickedCellIndex) = (gs.CurrentPlayer = "X")
    ' Set the X or O in the clicked cell
    sender.innerHTML = gs.CurrentPlayer

    ' See if someone has won the game after this click
    HandleResultValidation()
  End Sub

  Private Sub HandleResultValidation()
    ' Will become true if there are empty cells left
    Dim FieldsLeftToPlay As Boolean = False

    ' Check all 7 win conditions
    for i As Integer = 0 To 7

      Dim a = gs.GameState(WinCondition(i)(0))
      Dim b = gs.GameState(WinCondition(i)(1))
      Dim c = gs.GameState(WinCondition(i)(2))

      If Not (a.HasValue AndAlso b.HasValue AndAlso c.HasValue) Then
        ' not all fields are filled in; one of more of those doesn't contain an X or O
        FieldsLeftToPlay = True
        Continue For
      Elseif a = b AndAlso b = c Then
        ' the round was won
        StatusDisplay.innerHTML = $"Player {gs.CurrentPlayer} has won!"

        ' deactivate the game as it has ended
        gs.IsActive = False
        btnRestart.hidden = False
        Exit Sub
      End If
    Next

    If FieldsLeftToPlay Then
      ' Nobody won and not all cells are played yet, so next player
      PlayerChange()
    Else
      ' This was a draw
      StatusDisplay.innerHTML = "Game ended in a draw!"

      ' deactivate the game as it has ended
      gs.IsActive = false
      btnRestart.hidden = False
      Exit Sub
    End If
  End Sub

End class