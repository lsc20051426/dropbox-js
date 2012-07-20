if global? and require? and module?
  # Node.JS
  exports = global

  exports.Dropbox = require '../../lib/dropbox'
  exports.chai = require 'chai'
  exports.sinon = require 'sinon'
  exports.sinonChai = require 'sinon-chai'
  
  authDriver = new Dropbox.Drivers.NodeServer 8912
                                              
  TokenStash = require './token_stash.js'
  (new TokenStash()).get (credentials) ->
    exports.testKeys = credentials

  testIconPath = './test/binary/dropbox.png'
  fs = require 'fs'
  buffer = fs.readFileSync testIconPath
  console.log buffer
  bytes = []
  for i in [0...buffer.length]
    bytes.push String.fromCharCode(buffer.readUInt8(i))
  exports.testImageBytes = bytes.join ''
  exports.testImageUrl = 'http://localhost:8913/favicon.ico'
  imageServer = null
  exports.testImageServerOn = ->
    imageServer = new Dropbox.Drivers.NodeServer 8913, testIconPath
  exports.testImageServerOff = ->
    imageServer.closeServer()
    imageServer = null
else
  # Browser
  exports = window
  
  # TODO: figure out authentication without popups
  authDriver = new Dropbox.Drivers.Popup receiverFile: 'oauth_receiver.html'

  exports.testImageUrl = 'http://localhost:8911/test/binary/dropbox.png'
  exports.testImageServerOn = -> null
  exports.testImageServerOff = -> null

# Shared setup.
exports.assert = exports.chai.assert
exports.expect = exports.chai.expect
exports.authDriverUrl = authDriver.url()
exports.authDriver = authDriver.authDriver()
