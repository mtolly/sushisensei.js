'use strict'

canvas = null
ctx    = null

keysDown = []
leftKey  = 37
rightKey = 39

class Posn
  constructor: (@x, @y) ->

sushiSensei  = null
sushiSensei2 = null
sushiSensei3 = null
sushiSensei4 = null
sushiSensei5 = null
leftSlap     = null
rightSlap    = null
background   = null
plate        = null
scoreboard   = null
logo         = null
leftStop     = false
rightStop    = false

currentScore = 0
winning      = false
gameEnd      = false

question      = null
left_correct  = null
right_correct = null
left_answers  = []
right_answers = []

allPlates =
  # Left plates
  [ new Plate(220, 30, -0.75, 2.25, 30, 220, null)
  , new Plate(265, -120, -0.75, 2.25, 30, 220, null)
  , new Plate(315, -270, -0.75, 2.25, 30, 220, null)
  , new Plate(370, -420, -0.75, 2.25, 30, 220, null)
  # Right plates
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
  loader = new Loader()
  sushiSensei = loader.image 'img/chinaman.png'
  sushiSensei2 = loader.image 'img/chinaman2.png'
  sushiSensei3 = loader.image 'img/chinaman3.png'
  sushiSensei4 = loader.image 'img/chinaman4.png'
  sushiSensei5 = loader.image 'img/chinaman5.png'
  leftSlap = loader.image 'img/left_slap.png'
  rightSlap = loader.image 'img/right_slap.png'
  background = loader.image 'img/background.jpg'
  plate = loader.image 'img/plate.png'
  scoreboard = loader.image 'img/scoreboard.jpg'
  logo = loader.image 'img/logo.png'
  new Howl
    urls: ['sound/japanmusic.ogg', 'sound/japanmusic.mp3']
    loop: true
    autoplay: true
  loader.afterLoad ->
    loadLang =
      if document.location.search.match /spanish$/
        loadLanguage 'spanish', 5
      else if document.location.search.match /german$/
        loadLanguage 'german', 5
      else
        loadLanguage 'japanese', 11
    loadLang ->
      loadPlates()
      callback()

loadLanguage = (folder, count) -> (callback) ->
  allQuestions = for i in [1 .. count]
    new Question "content/#{folder}/q#{i}"
  questionsToAsk = allQuestions[..]
  shuffle questionsToAsk
  loadAll allQuestions, callback

# True if the given keycode was pressed this frame and not last frame.
newPress = (key) ->
  thisKeys[key] and not lastKeys[key]

# Loads a new question onto the plates,
# or ends the game if there are no more questions.
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
    i for i in [0 ... allQuestions.length]
  shuffle indexes
  for i in [0..3]
    allPlates[i + 4].plateContents = allQuestions[indexes[i]].right_answer
  # hack to make sure the correct right_answer is actually in there
  b = false
  for i in [0..3]
    b ||= (allQuestions[indexes[i]].right_answer == asking.right_answer)
  if not b
    allPlates[randomInt(4) + 4].plateContents = asking.right_answer

# Randomizes the array's order in-place.
shuffle = (list) ->
  n = list.length
  while n > 1
    n--
    k = randomInt(n + 1)
    [list[k], list[n]] = [list[n], list[k]]

update = ->
  lastKeys = thisKeys
  thisKeys = keysDown[..]

  if newPress rightKey
    rightStop = not rightStop
  if newPress leftKey
    leftStop = not leftStop

  for i in [0 ... allPlates.length]
    if (not leftStop and i < 4) or (not rightStop && i >= 4)
      slidingBefore = slidingPlates > 0
      slidingPlates = allPlates[i].updatePlates slidingPlates
      slidingAfter = slidingPlates > 0
      if slidingBefore and not slidingAfter
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

# True if both the left and right plates are on the correct answer.
isCorrect = ->
  gotLeft = false
  gotRight = false
  for p in allPlates[0..3]
    if p.in_zone && p.plateContents == left_correct
      gotLeft = true
      break
  for p in allPlates[4..7]
    if p.in_zone && p.plateContents == right_correct
      gotRight = true
      break
  gotLeft and gotRight

# Draws the image such that its top-left corner is at the given position.
drawImage = (img, posn) ->
  ctx.drawImage img, posn.x, posn.y

# Draws the image such that its center is at the given position.
drawCenter = (img, posn) ->
  newX = posn.x - img.width / 2
  newY = posn.y - img.height / 2
  drawImage img, new Posn(newX, newY)

hiya    = new Howl urls: ['sound/hiya.wav']
correct = new Howl urls: ['sound/correct.wav']
washing = new Howl urls: ['sound/washing.wav']

draw = ->
  wheat = 'rgb(245, 222, 179)'
  # from http://www.foszor.com/blog/xna-color-chart/

  drawImage tintImage(background, wheat), new Posn(0, 0)
  if slidingPlates > 0
    drawCenter sushiSensei4, new Posn(430, 250)
    if newPress(leftKey) or newPress(rightKey)
      correct.play()
  else
    sensei = switch madFace
      when 0 then sushiSensei
      when 1 then sushiSensei2
      when 2 then sushiSensei3
      else        sushiSensei5
    drawCenter sensei, new Posn(430, 250)

  if leftStop
    drawCenter leftSlap, new Posn(430, 250)
    if newPress leftKey
      hiya.play()

  if rightStop
    drawCenter rightSlap, new Posn(430, 250)
    if newPress rightKey
      washing.play()

  if not gameEnd
    drawCenter logo, new Posn(400, 80)
  else
    drawCenter logo, new Posn(400, 300)
  for plt in allPlates
    scale_factor = (plt.y_value + 170) / 670
    ctx.globalAlpha = plt.opacity

    dx = Math.ceil plt.x_value
    dy = Math.ceil(plt.y_value - 100)
    dw = scale_factor * plate.width
    dh = scale_factor * plate.height
    ctx.drawImage tintImage(plate, plt.plateColor), dx, dy, dw, dh

    dx = Math.ceil(plt.x_value + (150 * scale_factor - (1.25 * plt.plateContents.width * scale_factor)))
    dy = Math.ceil(plt.y_value - 100)
    dw = scale_factor * plt.plateContents.width
    dh = scale_factor * plt.plateContents.height
    ctx.drawImage tintImage(plt.plateContents, plt.plateColor), dx, dy, dw, dh

  ctx.globalAlpha = 1

  drawImage question, new Posn(270, 125)

  drawImage scoreboard, new Posn(310, 15)
  ctx.font = '13pt Courier'
  ctx.fillStyle = 'rgb(245, 255, 250)' # XNA mint cream
  ctx.fillText "Score: #{currentScore}", 313, 33

# Returns a copy of the image/canvas, tinted with the given color.
tintImage = (img, color) ->
  return img if color is 'white'
  img.tints ?= {} # holds cached colored versions of this image
  cached = img.tints[color]
  return cached if cached?

  img_ = invert img
  rect = blankWithSize img
  rectx = rect.getContext '2d'
  rectx.fillStyle = color
  rectx.fillRect 0, 0, rect.width, rect.height
  rect_ = invert rect
  rect_x = rect_.getContext '2d'
  rect_x.globalCompositeOperation = 'lighter'
  rect_x.drawImage img_, 0, 0
  unclipped = invert rect_ # This is the tinted image, but with clear -> white
  clipped = copyImage img # So, we use the original image to mask it
  clippedx = clipped.getContext '2d'
  clippedx.globalCompositeOperation = 'source-atop'
  clippedx.drawImage unclipped, 0, 0
  clippedx.globalCompositeOperation = 'source-over' # reset to normal

  img.tints[color] = clipped # cache for later
  return clipped

# Returns a new copy of the given image/canvas with all colors inverted.
invert = (img) ->
  copy = copyImage img
  copyx = copy.getContext '2d'
  imageData = copyx.getImageData 0, 0, copy.width, copy.height
  data = imageData.data
  for i in [0 ... data.length] by 4
    data[i    ] = 255 - data[i    ]
    data[i + 1] = 255 - data[i + 1]
    data[i + 2] = 255 - data[i + 2]
  copyx.putImageData imageData, 0, 0
  copy

# Makes a new canvas with the dimensions and contents of the given image/canvas.
copyImage = (img) ->
  temp = blankWithSize img
  tempx = temp.getContext '2d'
  tempx.drawImage img, 0, 0
  temp

# Makes a blank canvas with the dimensions of the given image/canvas.
blankWithSize = (img) ->
  temp = document.createElement 'canvas'
  temp.width = img.width
  temp.height = img.height
  temp

# randomInt(n) returns a random integer between 0 and n-1.
randomInt = (n) ->
  Math.floor(Math.random() * n)

window.requestAnimFrame =
  window.      requestAnimationFrame or
  window.webkitRequestAnimationFrame or
  window.   mozRequestAnimationFrame or
  window.     oRequestAnimationFrame or
  window.    msRequestAnimationFrame or
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
