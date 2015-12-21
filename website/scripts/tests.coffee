assert = chai.assert

window.initMochaPhantomJS() if window.initMochaPhantomJS
mocha.setup('bdd')

#=require ../../test/**/*.coffee

mocha.run();
