'use strict'

canvas = null
ctx = null

keysDown = []

class Posn
  constructor: (@x, @y) ->

###
###

# TODO: texture variables

leftStop = false
rightStop = false

currentScore = 0
winning = false
gameEnd = false

left_correct = null
right_correct = null
left_answers = []
right_answers = []

# TODO: texture variables

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

loadContent = ->
  # TODO

loadSpanish = ->
  # TODO

loadJapanese = ->
  # TODO

loadGerman = ->
  # TODO

newPress = (key) ->
  thisKeys[key] and not lastKeys[key]

allQuestions = []
questionsToAsk = []

loadPlates = ->
  # TODO

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

  (animloop = ->
    requestAnimFrame animloop
    update()
    draw()
    null
  )()
