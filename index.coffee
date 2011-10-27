Hubot = require 'hubot'
Robot = Hubot.robot()

class ZeroBot extends Robot
  constructor: (path, name = "ZeroBot", options = {}) ->
    @incomingSocket = options.incomingSocket or options.socket
    @outgoingSocket = options.outgoingSocket or @incomingSocket
    super path, name

  send: (user, strings...) ->
    for str in strings
      @outgoingSocket.send @encodeMessage(user: user, message: str)

  reply: (user, strings...) ->
    @send user, strings.map( (s) -> "#{user.name}: #{s}" )...

  run: ->
    console.log "ZeroBot!"

    @bot = @userForId 1, name: @name

    @incomingSocket.on 'message', (msg) =>
      data = @decodeMessage msg
      id   = data.user.id.toString()
      delete data.user.id
      user = @userForId id, data.user
      data.message.split("\n").forEach (line) =>
        return if line.length is 0
        @receive new Robot.TextMessage user, line

  close: ->
    super()
    @incomingSocket.close()
    @outgoingSocket.close() if @outgoingSocket != @incomingSocket

  decodeMessage: (msg) ->
    JSON.parse msg.toString()

  encodeMessage: (data) ->
    JSON.stringify data

module.exports = ZeroBot
