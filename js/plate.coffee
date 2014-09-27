'use strict'

class Plate
  constructor: (@x_origin, @y_origin, @x_speed, @y_speed, @y_reset, @x_reset, @plateContents) ->
    @x_value = @x_origin
    @y_value = @y_origin
    @plateColor = 'white'
    @opacity = 1
    @in_zone = false
    @finishedSliding = false

  origin: ->
    @x_value = @x_origin
    @y_value = @y_origin
    @finishedSliding = false

  reset: ->
    @x_value = @x_reset
    @y_value = @y_reset
    @finishedSliding = false

  updatePlates: (slidingPlates) ->
    sliding = slidingPlates != 0
    @x_value += (if sliding then 4 else 1) * @x_speed
    @y_value += (if sliding then 4 else 1) * @y_speed

    if @y_value >= 650
      if sliding
        if not @finishedSliding
          slidingPlates -= 1
        @finishedSliding = true
      else
        if @finishedSliding
          @origin()
        else
          @reset()

    @in_zone = 450 <= @y_value and @y_value < 575

    if @y_value >= 575 # fading out
      @opacity = 1 - ((@y_value - 575) / 50) * 1
      @opacity = 0 if @opacity < 0
      @plateColor = 'white'
    else if @y_value >= 450 # in zone
      @opacity = 1
      @plateColor = 'yellow'
    else # on track
      @opacity = 1
      @plateColor = 'white'

    slidingPlates

window.Plate = Plate
