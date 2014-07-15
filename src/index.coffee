spawn = require('child_process').spawn
module.export.cwd = (cwdPath) ->
  @cwdPath = cwdPath if cwdPath
  @cwdPath



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