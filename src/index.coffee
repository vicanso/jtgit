spawn = require('child_process').spawn
async = require 'async'

module.exports.cwd = __dirname

module.exports.pull = (branch, cbf) ->
  if !cbf
    cbf = branch
    branch = ''
  paramsList = []
  paramsList.push ['checkout', branch] if branch
  paramsList.push ['pull']

  runCommands paramsList, module.exports.cwd, cbf

module.exports.checkout = (branch, tag, cbf) ->
  if !cbf
    cbf = tag
    tag = branch
    branch = ''
  paramsList = []
  paramsList.push ['checkout', branch] if branch
  paramsList.push ['checkout', tag]
  runCommands paramsList, module.exports.cwd, cbf

run = (params, cwd, cbf) ->
  command = spawn 'git', params, {
    cwd : cwd
  }
  result = []
  error = []
  command.stdout.on 'data', (buf) ->
    result.push buf
  command.stderr.on 'data', (buf) ->
    error.push buf
  command.on 'close', ->
    cbf null, {
      message : Buffer.concat(result).toString()
      error : Buffer.concat(error).toString()
    }


runCommands = (paramsList, cwd, cbf) ->
  funcs = paramsList.map (params) ->
    (cbf) ->
      run params, cwd, cbf
  async.series funcs, (err, res) ->
    if err
      cbf err
    else
      result = 
        message : ''
        error : ''
      res.forEach (data)->
        result.message += data.message if data.message
        result.error += data.error if data.error
      cbf null, result