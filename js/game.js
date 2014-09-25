// Generated by CoffeeScript 1.7.1
(function() {
  'use strict';
  var Posn, actionBox, afterAll, allPlates, allQuestions, background, canvas, contentLoad, correct, ctx, currentScore, cursor, draw, drawCenter, drawImage, font, gameEnd, hiya, isCorrect, keysDown, lastKeys, leftKey, leftSlap, leftStop, leftTable, left_answers, left_correct, line, loadAll, loadContent, loadGerman, loadJapanese, loadPlates, loadSpanish, logo, madFace, newPress, plate, question, questionsToAsk, rightKey, rightSlap, rightStop, rightTable, right_answers, right_correct, scoreboard, shuffle, slidingPlates, sushiSensei, sushiSensei2, sushiSensei3, sushiSensei4, sushiSensei5, thisKeys, tintImage, update, washing, winning;

  contentLoad = function(url) {
    var events, img, loaded;
    img = new Image();
    loaded = false;
    events = [];
    $(img).load(function() {
      var evt, _i, _len, _results;
      loaded = true;
      _results = [];
      for (_i = 0, _len = events.length; _i < _len; _i++) {
        evt = events[_i];
        _results.push(evt());
      }
      return _results;
    });
    img.src = url;
    return [
      img, function(evt) {
        if (loaded) {
          return evt();
        } else {
          return events.push(evt);
        }
      }
    ];
  };

  afterAll = function(events, callback) {
    var decrement, evt, remaining, _i, _len, _results;
    remaining = events.length;
    decrement = function() {
      remaining -= 1;
      if (remaining === 0) {
        return callback();
      }
    };
    _results = [];
    for (_i = 0, _len = events.length; _i < _len; _i++) {
      evt = events[_i];
      _results.push(evt(decrement));
    }
    return _results;
  };

  canvas = null;

  ctx = null;

  keysDown = [];

  leftKey = 37;

  rightKey = 39;

  Posn = (function() {
    function Posn(x, y) {
      this.x = x;
      this.y = y;
    }

    return Posn;

  })();


  /*
   */

  sushiSensei = null;

  sushiSensei2 = null;

  sushiSensei3 = null;

  sushiSensei4 = null;

  sushiSensei5 = null;

  leftSlap = null;

  rightSlap = null;

  leftTable = null;

  rightTable = null;

  actionBox = null;

  background = null;

  cursor = null;

  plate = null;

  scoreboard = null;

  logo = null;

  line = null;

  font = null;

  leftStop = false;

  rightStop = false;

  currentScore = 0;

  winning = false;

  gameEnd = false;

  question = null;

  left_correct = null;

  right_correct = null;

  left_answers = [];

  right_answers = [];

  allPlates = [new Plate(220, 30, -0.75, 2.25, 30, 220, null), new Plate(265, -120, -0.75, 2.25, 30, 220, null), new Plate(315, -270, -0.75, 2.25, 30, 220, null), new Plate(370, -420, -0.75, 2.25, 30, 220, null), new Plate(540, 30, 0.4, 2.25, 30, 540, null), new Plate(520, -120, 0.4, 2.25, 30, 540, null), new Plate(500, -270, 0.4, 2.25, 30, 540, null), new Plate(480, -420, 0.4, 2.25, 30, 540, null)];

  allQuestions = [];

  questionsToAsk = [];

  slidingPlates = 0;

  madFace = 0;

  lastKeys = [];

  thisKeys = [];

  loadContent = function(callback) {
    var events, _ref, _ref1, _ref10, _ref11, _ref12, _ref13, _ref14, _ref15, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
    events = [];
    _ref = contentLoad('img/chinaman.png'), sushiSensei = _ref[0], events[events.length] = _ref[1];
    _ref1 = contentLoad('img/chinaman2.png'), sushiSensei2 = _ref1[0], events[events.length] = _ref1[1];
    _ref2 = contentLoad('img/chinaman3.png'), sushiSensei3 = _ref2[0], events[events.length] = _ref2[1];
    _ref3 = contentLoad('img/chinaman4.png'), sushiSensei4 = _ref3[0], events[events.length] = _ref3[1];
    _ref4 = contentLoad('img/chinaman5.png'), sushiSensei5 = _ref4[0], events[events.length] = _ref4[1];
    _ref5 = contentLoad('img/left_slap.png'), leftSlap = _ref5[0], events[events.length] = _ref5[1];
    _ref6 = contentLoad('img/right_slap.png'), rightSlap = _ref6[0], events[events.length] = _ref6[1];
    _ref7 = contentLoad('img/leftTable.bmp'), leftTable = _ref7[0], events[events.length] = _ref7[1];
    _ref8 = contentLoad('img/rightTable.bmp'), rightTable = _ref8[0], events[events.length] = _ref8[1];
    _ref9 = contentLoad('img/actionBox.bmp'), actionBox = _ref9[0], events[events.length] = _ref9[1];
    _ref10 = contentLoad('img/background.jpg'), background = _ref10[0], events[events.length] = _ref10[1];
    _ref11 = contentLoad('img/cursor.png'), cursor = _ref11[0], events[events.length] = _ref11[1];
    _ref12 = contentLoad('img/plate.png'), plate = _ref12[0], events[events.length] = _ref12[1];
    _ref13 = contentLoad('img/line.png'), line = _ref13[0], events[events.length] = _ref13[1];
    _ref14 = contentLoad('img/scoreboard.jpg'), scoreboard = _ref14[0], events[events.length] = _ref14[1];
    _ref15 = contentLoad('img/logo.png'), logo = _ref15[0], events[events.length] = _ref15[1];
    new Howl({
      urls: ['sound/japanmusic.ogg', 'sound/japanmusic.mp3'],
      loop: true,
      autoplay: true
    });
    return afterAll(events, function() {
      var loadLang;
      loadLang = document.location.search.match(/spanish$/) ? loadSpanish : document.location.search.match(/german$/) ? loadGerman : loadJapanese;
      return loadLang(function() {
        loadPlates();
        return callback();
      });
    });
  };

  loadSpanish = function(callback) {
    var i, q, _i;
    allQuestions = [];
    questionsToAsk = [];
    for (i = _i = 1; _i <= 5; i = ++_i) {
      q = new Question("content/spanish/q" + i);
      allQuestions.push(q);
      questionsToAsk.push(q);
    }
    shuffle(questionsToAsk);
    return loadAll(allQuestions, callback);
  };

  loadJapanese = function(callback) {
    var i, q, _i;
    allQuestions = [];
    questionsToAsk = [];
    for (i = _i = 1; _i <= 11; i = ++_i) {
      q = new Question("content/japanese/q" + i);
      allQuestions.push(q);
      questionsToAsk.push(q);
    }
    shuffle(questionsToAsk);
    return loadAll(allQuestions, callback);
  };

  loadGerman = function(callback) {
    var i, q, _i;
    allQuestions = [];
    questionsToAsk = [];
    for (i = _i = 1; _i <= 5; i = ++_i) {
      q = new Question("content/german/q" + i);
      allQuestions.push(q);
      questionsToAsk.push(q);
    }
    shuffle(questionsToAsk);
    return loadAll(allQuestions, callback);
  };

  loadAll = function(questions, callback) {
    var keepLoading, toLoad;
    toLoad = questions.slice(0);
    keepLoading = function() {
      if (toLoad.length === 0) {
        return callback();
      } else {
        return toLoad.pop().load(keepLoading);
      }
    };
    return keepLoading();
  };

  newPress = function(key) {
    return thisKeys[key] && !lastKeys[key];
  };

  loadPlates = function() {
    var asking, b, i, indexes, rngNext4, tex, _i, _j, _k, _l, _len, _ref;
    if (questionsToAsk.length === 0) {
      leftStop = true;
      rightStop = true;
      gameEnd = true;
      return;
    }
    asking = questionsToAsk.pop();
    question = asking.question;
    left_correct = asking.left_answer;
    right_correct = asking.right_answer;
    left_answers = [];
    left_answers.push(asking.left_answer);
    _ref = asking.left_duds;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tex = _ref[_i];
      left_answers.push(tex);
    }
    shuffle(left_answers);
    for (i = _j = 0; _j <= 3; i = ++_j) {
      allPlates[i].plateContents = left_answers[i];
    }
    right_answers = [];
    indexes = (function() {
      var _k, _ref1, _results;
      _results = [];
      for (i = _k = 0, _ref1 = allQuestions.length - 1; 0 <= _ref1 ? _k <= _ref1 : _k >= _ref1; i = 0 <= _ref1 ? ++_k : --_k) {
        _results.push(i);
      }
      return _results;
    })();
    shuffle(indexes);
    for (i = _k = 0; _k <= 3; i = ++_k) {
      allPlates[i + 4].plateContents = allQuestions[indexes[i]].right_answer;
    }
    b = false;
    for (i = _l = 0; _l <= 3; i = ++_l) {
      b || (b = allQuestions[indexes[i]].right_answer === asking.right_answer);
    }
    if (!b) {
      rngNext4 = Math.floor(Math.random() * 4);
      return allPlates[rngNext4 + 4].plateContents = asking.right_answer;
    }
  };

  shuffle = function(list) {
    var k, n, _ref, _results;
    n = list.length;
    _results = [];
    while (n > 1) {
      n--;
      k = Math.floor(Math.random() * (n + 1));
      _results.push((_ref = [list[n], list[k]], list[k] = _ref[0], list[n] = _ref[1], _ref));
    }
    return _results;
  };

  update = function() {
    var i, slidingAfter, slidingBefore, _i, _ref;
    lastKeys = thisKeys;
    thisKeys = keysDown.slice(0);
    if (newPress(rightKey)) {
      rightStop = !rightStop;
    }
    if (newPress(leftKey)) {
      leftStop = !leftStop;
    }
    for (i = _i = 0, _ref = allPlates.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
      if ((!leftStop && i < 4) || (!rightStop && i >= 4)) {
        slidingBefore = slidingPlates > 0;
        slidingPlates = allPlates[i].updatePlates(slidingPlates);
        slidingAfter = slidingPlates > 0;
        if (slidingBefore && !slidingAfter) {
          loadPlates();
        }
      }
    }
    if (leftStop && rightStop && !gameEnd) {
      winning = isCorrect();
      if (winning) {
        currentScore += 200;
        slidingPlates = 8;
        madFace = 0;
      } else {
        currentScore -= 100;
        madFace++;
      }
      leftStop = false;
      rightStop = false;
    }
    winning = isCorrect() && leftStop && rightStop;
    if (winning) {
      return currentScore += 200;
    }
  };

  isCorrect = function() {
    var gotLeft, gotRight, p, _i, _j, _len, _len1, _ref, _ref1;
    gotLeft = false;
    gotRight = false;
    _ref = allPlates.slice(0, 4);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      p = _ref[_i];
      if (p.in_zone && p.plateContents === left_correct) {
        gotLeft = true;
      }
    }
    _ref1 = allPlates.slice(4, 8);
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      p = _ref1[_j];
      if (p.in_zone && p.plateContents === right_correct) {
        gotRight = true;
      }
    }
    return gotLeft && gotRight;
  };

  drawImage = function(img, posn) {
    return ctx.drawImage(img, posn.x, posn.y);
  };

  drawCenter = function(img, posn) {
    var newX, newY;
    newX = posn.x - img.width / 2;
    newY = posn.y - img.height / 2;
    return drawImage(img, new Posn(newX, newY));
  };

  hiya = new Howl({
    urls: ['sound/hiya.wav']
  });

  correct = new Howl({
    urls: ['sound/correct.wav']
  });

  washing = new Howl({
    urls: ['sound/washing.wav']
  });

  draw = function() {
    var dh, dw, dx, dy, plt, scale_factor, wheat, _i, _len;
    wheat = 'rgb(245, 222, 179)';
    drawImage(tintImage(background, wheat), new Posn(0, 0));
    if (slidingPlates > 0) {
      drawCenter(sushiSensei4, new Posn(430, 250));
      if (newPress(leftKey) || newPress(rightKey)) {
        correct.play();
      }
    } else if (madFace === 0) {
      drawCenter(sushiSensei, new Posn(430, 250));
    } else if (madFace === 1) {
      drawCenter(sushiSensei2, new Posn(430, 250));
    } else if (madFace === 2) {
      drawCenter(sushiSensei3, new Posn(430, 250));
    } else {
      drawCenter(sushiSensei5, new Posn(430, 250));
    }
    if (leftStop) {
      drawCenter(leftSlap, new Posn(430, 250));
      if (newPress(leftKey)) {
        hiya.play();
      }
    }
    if (rightStop) {
      drawCenter(rightSlap, new Posn(430, 250));
      if (newPress(rightKey)) {
        washing.play();
      }
    }
    if (!gameEnd) {
      drawCenter(logo, new Posn(400, 80));
    } else {
      drawCenter(logo, new Posn(400, 300));
    }
    for (_i = 0, _len = allPlates.length; _i < _len; _i++) {
      plt = allPlates[_i];
      scale_factor = (plt.y_value + 170) / 670;
      ctx.globalAlpha = plt.opacity;
      dx = Math.ceil(plt.x_value);
      dy = Math.ceil(plt.y_value - 100);
      dw = scale_factor * plate.width;
      dh = scale_factor * plate.height;
      ctx.drawImage(tintImage(plate, plt.plateColor), dx, dy, dw, dh);
      dx = Math.ceil(plt.x_value + (150 * scale_factor - (1.25 * plt.plateContents.width * scale_factor)));
      dy = Math.ceil(plt.y_value - 100);
      dw = scale_factor * plt.plateContents.width;
      dh = scale_factor * plt.plateContents.height;
      ctx.drawImage(tintImage(plt.plateContents, plt.plateColor), dx, dy, dw, dh);
    }
    ctx.globalAlpha = 1;
    drawImage(question, new Posn(270, 125));
    drawImage(scoreboard, new Posn(310, 15));
    ctx.font = '13pt Courier';
    ctx.fillStyle = 'rgb(245, 255, 250)';
    return ctx.fillText("Score: " + currentScore, 313, 33);
  };


  /*
   */

  tintImage = function(img, color) {
    var temp, temp2, temp2x, tempx;
    temp = document.createElement('canvas');
    temp.width = img.width;
    temp.height = img.height;
    tempx = temp.getContext('2d');
    tempx.fillStyle = color;
    tempx.fillRect(0, 0, temp.width, temp.height);
    tempx.globalCompositeOperation = 'darker';
    tempx.drawImage(img, 0, 0);
    temp2 = document.createElement('canvas');
    temp2.width = img.width;
    temp2.height = img.height;
    temp2x = temp2.getContext('2d');
    temp2x.drawImage(img, 0, 0);
    temp2x.globalCompositeOperation = 'source-atop';
    temp2x.drawImage(temp, 0, 0);
    temp2x.globalCompositeOperation = 'source-over';
    return temp2;
  };

  window.requestAnimFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback) {
    return window.setTimeout(callback, 1000 / 60);
  };

  $(document).ready(function() {
    canvas = $('#canvas')[0];
    ctx = canvas.getContext('2d');
    $(document).keydown(function(evt) {
      return keysDown[evt.which] = true;
    });
    $(document).keyup(function(evt) {
      return delete keysDown[evt.which];
    });
    return loadContent(function() {
      var animloop;
      return (animloop = function() {
        requestAnimFrame(animloop);
        update();
        draw();
        return null;
      })();
    });
  });

}).call(this);
