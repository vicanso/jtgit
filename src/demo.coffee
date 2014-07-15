git = require './index'

# git.pull 'master', (err, res) ->
#   console.dir res

git.checkout 'e84973e8110f073cb3ae0d8fe54e8958ddbd238d', (err, res) ->
  console.dir res