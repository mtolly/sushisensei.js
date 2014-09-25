// Generated by CoffeeScript 1.7.1
(function() {
  var Plate;

  Plate = (function() {
    function Plate(x_origin, y_origin, x_speed, y_speed, y_reset, x_reset, plateContents) {
      this.x_origin = x_origin;
      this.y_origin = y_origin;
      this.x_speed = x_speed;
      this.y_speed = y_speed;
      this.y_reset = y_reset;
      this.x_reset = x_reset;
      this.plateContents = plateContents;
      this.x_value = this.x_origin;
      this.y_value = this.y_origin;
      this.plateColor = 'white';
      this.opacity = 1;
      this.in_zone = false;
      this.finishedSliding = false;
    }

    Plate.prototype.origin = function() {
      this.x_value = this.x_origin;
      this.y_value = this.y_origin;
      return this.finishedSliding = false;
    };

    Plate.prototype.reset = function() {
      this.x_value = this.x_reset;
      this.y_value = this.y_reset;
      return this.finishedSliding = false;
    };

    Plate.prototype.updatePlates = function(slidingPlates) {
      var sliding;
      sliding = slidingPlates !== 0;
      this.x_value += (sliding ? 4 : 1) * this.x_speed;
      this.y_value += (sliding ? 4 : 1) * this.y_speed;
      if (this.y_value >= 650) {
        if (sliding) {
          if (!this.finishedSliding) {
            slidingPlates -= 1;
          }
          this.finishedSliding = true;
        } else {
          if (this.finishedSliding) {
            this.origin();
          } else {
            this.reset();
          }
        }
      }
      this.in_zone = 450 <= this.y_value && this.y_value < 575;
      if (this.y_value >= 575) {
        this.opacity = 1 - ((this.y_value - 575) / 50) * 1;
        if (this.opacity < 0) {
          this.opacity = 0;
        }
        this.plateColor = 'white';
      } else if (this.y_value >= 450) {
        this.opacity = 1;
        this.plateColor = 'yellow';
      } else {
        this.opacity = 1;
        this.plateColor = 'white';
      }
      return slidingPlates;
    };

    return Plate;

  })();

  window.Plate = Plate;

}).call(this);
