'use strict'

canvas = null
ctx = null

keysDown = []

class Posn
  constructor: (@x, @y) ->

###
###

sushiSensei = null
sushiSensei2 = null
sushiSensei3 = null
sushiSensei4 = null
sushiSensei5 = null
leftSlap = null
rightSlap = null
leftTable = null
rightTable = null
actionBox = null
background = null
cursor = null
plate = null
scoreboard = null
logo = null
line = null
font = null
leftStop = false
rightStop = false

currentScore = 0
winning = false
gameEnd = false

left_correct = null
right_correct = null
left_answers = []
right_answers = []

allPlates =
  [ new Plate(220, 30, -0.75, 2.25, 30, 220, null)
  , new Plate(265, -120, -0.75, 2.25, 30, 220, null)
  , new Plate(315, -270, -0.75, 2.25, 30, 220, null)
  , new Plate(370, -420, -0.75, 2.25, 30, 220, null)

  , new Plate(540, 30, 0.4, 2.25, 30, 540, null)
  , new Plate(520, -120, 0.4, 2.25, 30, 540, null)
  , new Plate(500, -270, 0.4, 2.25, 30, 540, null)
  , new Plate(480, -420, 0.4, 2.25, 30, 540, null)
  ]

loadContent = (callback) ->
  # TODO
  callback()

loadSpanish = (callback) ->
  # TODO
  callback()

loadJapanese = (callback) ->
  # TODO
  callback()

loadGerman = (callback) ->
  # TODO
  callback()

newPress = (key) ->
  thisKeys[key] and not lastKeys[key]

allQuestions = []
questionsToAsk = []

loadPlates = ->
  if questionsToAsk.length is 0
    leftStop = true
    rightStop = true
    gameEnd = true
    return

  asking = questionsToAsk.pop()

  question = asking.question
  left_correct = asking.left_answer
  right_correct = asking.right_answer

  left_answers = []
  left_answers.push asking.left_answer
  for tex in asking.left_duds
    left_answers.push tex
  shuffle left_answers
  for i in [0..3]
    allPlates[i].plateContents = left_answers[i]

  right_answers = []
  indexes =
    i for i in [0 .. allQuestions.length - 1]
  shuffle indexes
  for i in [0..3]
    allPlates[i + 4].plateContents = allQuestions[indexes[i]].right_answer
  # hack to make sure the correct right_answer is actually in there
  b = false
  for i in [0..3]
    b ||= (allQuestions[indexes[i]].right_answer == asking.right_answer)
  if not b
    rngNext4 = Math.floor(Math.floor * 4)
    allPlates[rngNext4 + 4].plateContents = asking.right_answer

shuffle = (list) ->
  n = list.length
  while n > 1
    n--
    k = Math.floor(Math.random() * (n + 1))
    [list[k], list[n]] = [list[n], list[k]]

update = ->
  lastKeys = thisKeys
  thisKeys = keysDown[..]

  if newPress 39 # right arrow key
    rightStop = not rightStop
  if newPress 37 # left arrow key
    leftStop = not leftStop

  for i in [0 .. allPlates.length - 1]
    if (not leftStop and i < 4) or (not rightStop && i >= 4)
      slidingBefore = slidingPlates > 0
      slidingPlates = allPlates[i].updatePlates slidingPlates
      slidingAfter = slidingPlates > 0
      if slidingBefore and slidingAfter
        loadPlates()

  if leftStop and rightStop and not gameEnd
    winning = isCorrect()
    if winning
      currentScore += 200
      slidingPlates = 8
      madFace = 0
    else
      currentScore -= 100
      madFace++
    leftStop = false
    rightStop = false

  winning = isCorrect() and leftStop and rightStop
  if winning
    currentScore += 200

slidingPlates = 0
madFace = 0

# Omitted: mod

isCorrect = ->
  gotLeft = false
  gotRight = false
  for p in allPlates[0..3]
    if p.in_zone && p.plateContents == left_correct
      gotLeft = true
  for p in allPlates[4..7]
    if p.in_zone && p.plateContents == right_correct
      gotRight = true
  gotLeft and gotRight

lastKeys = []
thisKeys = []

drawCenter = (img, posn, color) ->
  # TODO

draw = ->
  # TODO
  console.log "Draw"

###
###

window.requestAnimFrame =
  window.requestAnimationFrame or
  window.webkitRequestAnimationFrame or
  window.mozRequestAnimationFrame or
  window.oRequestAnimationFrame or
  window.msRequestAnimationFrame or
  (callback) -> window.setTimeout callback, 1000 / 60

$(document).ready ->

  canvas = $('#canvas')[0]
  ctx = canvas.getContext '2d'

  $(document).keydown (evt) ->
    keysDown[evt.which] = true

  $(document).keyup (evt) ->
    delete keysDown[evt.which]

  loadContent ->
    (animloop = ->
      requestAnimFrame animloop
      update()
      draw()
      null
    )()
