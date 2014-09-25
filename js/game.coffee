'use strict'

contentLoad = (url) ->
  img = new Image()
  loaded = false
  events = []
  $(img).load ->
    loaded = true
    evt() for evt in events
  img.src = url
  [img, (evt) -> if loaded then evt() else events.push(evt)]

afterAll = (events, callback) ->
  remaining = events.length
  decrement = ->
    remaining -= 1
    callback() if remaining is 0
  evt decrement for evt in events

canvas = null
ctx = null

keysDown = []
leftKey = 37
rightKey = 39

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

question = null
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

allQuestions = []
questionsToAsk = []

slidingPlates = 0
madFace = 0

lastKeys = []
thisKeys = []

loadContent = (callback) ->
  events = []
  [sushiSensei, events[events.length]] = contentLoad 'img/chinaman.png'
  [sushiSensei2, events[events.length]] = contentLoad 'img/chinaman2.png'
  [sushiSensei3, events[events.length]] = contentLoad 'img/chinaman3.png'
  [sushiSensei4, events[events.length]] = contentLoad 'img/chinaman4.png'
  [sushiSensei5, events[events.length]] = contentLoad 'img/chinaman5.png'
  [leftSlap, events[events.length]] = contentLoad 'img/left_slap.png'
  [rightSlap, events[events.length]] = contentLoad 'img/right_slap.png'
  [leftTable, events[events.length]] = contentLoad 'img/leftTable.bmp'
  [rightTable, events[events.length]] = contentLoad 'img/rightTable.bmp'
  [actionBox, events[events.length]] = contentLoad 'img/actionBox.bmp'
  [background, events[events.length]] = contentLoad 'img/background.jpg'
  [cursor, events[events.length]] = contentLoad 'img/cursor.png'
  [plate, events[events.length]] = contentLoad 'img/plate.png'
  [line, events[events.length]] = contentLoad 'img/line.png'
  [scoreboard, events[events.length]] = contentLoad 'img/scoreboard.jpg'
  [logo, events[events.length]] = contentLoad 'img/logo.png'
  ### TODO
  Song song = Content.Load<Song>("japanmusic");
  MediaPlayer.Play(song);
  font = this.Content.Load<SpriteFont>("Images/SpriteFont1");
  ###
  afterAll events, ->
    loadJapanese ->
      loadPlates()
      callback()

loadSpanish = (callback) ->
  # TODO
  callback()

loadJapanese = (callback) ->
  allQuestions = []
  questionsToAsk = []
  for i in [1..11]
    q = new Question "content/japanese/q#{i}"
    allQuestions.push q
    questionsToAsk.push q
  shuffle questionsToAsk
  # callbacks ahoy
  toLoad = allQuestions[..]
  keepLoading = ->
    if toLoad.length is 0
      callback()
    else
      toLoad.pop().load keepLoading
  keepLoading()

loadGerman = (callback) ->
  # TODO
  callback()

newPress = (key) ->
  thisKeys[key] and not lastKeys[key]

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
    rngNext4 = Math.floor(Math.random() * 4)
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

  if newPress rightKey
    rightStop = not rightStop
  if newPress leftKey
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

drawImage = (img, posn, color) ->
  ctx.drawImage img, posn.x, posn.y
  # TODO: color

drawCenter = (img, posn, color) ->
  newX = posn.x - img.width / 2
  newY = posn.y - img.height / 2
  drawImage img, new Posn(newX, newY), color

draw = ->
  ### TODO
  SoundEffect hiya = this.Content.Load<SoundEffect>("hiya");
  SoundEffect correct = this.Content.Load<SoundEffect>("correct");
  SoundEffect washing = this.Content.Load<SoundEffect>("washing");
  GraphicsDevice.Clear(Color.CornflowerBlue);
  ###

  wheat = null # TODO
  white = null # TODO

  drawImage background, new Posn(0, 0), wheat
  if slidingPlates > 0
    drawCenter sushiSensei4, new Posn(430, 250), white
    if newPress(leftKey) or newPress(rightKey)
      null
      ### TODO
      correct.Play();
      ###
  else if madFace is 0
    drawCenter sushiSensei, new Posn(430, 250), white
  else if madFace is 1
    drawCenter sushiSensei2, new Posn(430, 250), white
  else if madFace is 2
    drawCenter sushiSensei3, new Posn(430, 250), white
  else
    drawCenter sushiSensei5, new Posn(430, 250), white

  if leftStop
    drawCenter leftSlap, new Posn(430, 250), white
    if newPress leftKey
      null
      ### TODO
      hiya.Play();
      ###

  if rightStop
    drawCenter rightSlap, new Posn(430, 250), white
    if newPress rightKey
      null
      ### TODO
      washing.Play();
      ###

  if not gameEnd
    drawCenter logo, new Posn(400, 80), white
  else
    drawCenter logo, new Posn(400, 300), white
  for plate in allPlates
    # AllPlates[i] -> plate
    scale_factor = (plate.y_value + 170) / 670
    ### TODO
    spriteBatch.Draw(plate, new Vector2((int)Math.Ceiling(AllPlates[i].x_value), (int)Math.Ceiling(AllPlates[i].y_value - 100)), null, AllPlates[i].plateColor, 0f, Vector2.Zero, new Vector2((((float)AllPlates[i].y_value + 170) / (670)), (((float)AllPlates[i].y_value + 170) / (670))), SpriteEffects.None, 0f);
    spriteBatch.Draw(AllPlates[i].plateContents, new Vector2((int)Math.Ceiling(AllPlates[i].x_value + (150 * scale_factor - (1.25 * AllPlates[i].plateContents.Width * (scale_factor)))), (int)Math.Ceiling(AllPlates[i].y_value - 100)), null, AllPlates[i].plateColor, 0f, Vector2.Zero, new Vector2((((float)AllPlates[i].y_value + 170) / (670)), (((float)AllPlates[i].y_value + 170) / (670))), SpriteEffects.None, 0f);
    ###

  drawImage question, new Posn(270, 125), white

  drawImage scoreboard, new Posn(310, 15), white
  ### TODO
  spriteBatch.DrawString(font, "Score: " + currentScore, new Vector2(313, 15), Color.MintCream);
  ###

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
