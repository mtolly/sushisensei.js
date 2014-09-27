'use strict'

class Loader
  constructor: ->
    @queued = 0
    @waiting = []

  # Adds some object with a "load" method to the queue.
  # The load method should return immediately and call its callback when loaded.
  queue: (loadable) ->
    @queued++
    loadable.load =>
      @queued--
      if @queued is 0
        callback() for callback in @waiting
        @waiting = []

  # Makes a new image with the given URL and adds it to the loading queue.
  image: (url) ->
    img = new Image()
    @queue $(img)
    img.src = url
    img

  # Runs the callback the next time the queue is empty.
  afterLoad: (callback) ->
    if @queued is 0
      setTimeout callback, 0
    else
      @waiting.push callback

loadAll = (loadables, callback) ->
  loader = new Loader
  loader.queue x for x in loadables
  loader.afterLoad callback

window.Loader = Loader
window.loadAll = loadAll
