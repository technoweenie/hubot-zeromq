ZMQ     = require 'zeromq'
ZeroBot = require './index'

outgoing = ZMQ.createSocket 'push'
outgoing.connect 'tcp://127.0.0.1:5556'

incoming = ZMQ.createSocket 'sub'
incoming.connect 'tcp://127.0.0.1:5555'
incoming.subscribe '{'

bot = new ZeroBot null, 'ZeroBot',
  incomingSocket: incoming
  outgoingSocket: outgoing

# rip off the PING commands for the purposes of a quick demo
bot.respond /PING$/i, (msg) ->
  msg.send "PONG"

bot.respond /ECHO (.*)$/i, (msg) ->
  msg.send msg.match[1]

bot.respond /TIME$/i, (msg) ->
  msg.send "Server time is: #{new Date()}"

bot.respond /DIE$/i, (msg) ->
  msg.send "Goodbye, cruel world."
  bot.close()

bot.run()

