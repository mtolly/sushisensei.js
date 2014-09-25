contentLoad = (url) ->
  img = new Image()
  loaded = false
  events = []
  img.onload ->
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

class Question
  constructor: (@basename)

  load: (callback) ->
    [@question, e0] = contentLoad "#{@basename}q.jpg"
    [@left_answer, e1] = contentLoad "#{@basename}a.jpg"
    [@right_answer, e2] = contentLoad "#{@basename}p.jpg"
    events = [e0, e1, e2]
    @left_duds = []
    for i in [1..3]
      [dud, evt] = contentLoad "#{@basename}d#{i}.jpg"
      @left_duds.push dud
      events.push evt
    afterAll events, callback
