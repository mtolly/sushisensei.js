'use strict'

class Question
  constructor: (@basename) ->

  load: (callback) ->
    loader = new Loader
    @question = loader.image "#{@basename}q.jpg"
    @left_answer = loader.image "#{@basename}a.jpg"
    @right_answer = loader.image "#{@basename}p.jpg"
    @left_duds = for i in [1..3]
      loader.image "#{@basename}d#{i}.jpg"
    loader.afterLoad callback

window.Question = Question
