chokidar = require('chokidar')
fs = require('fs')
{spawn, exec} = require('child_process')
pug = require('pug')
sass = require('sass')

binPath = './node_modules/.bin/'

# Returns a string with the current time to print out.
timeNow = ->
  today = new Date()
  today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds()

# Spawns an application with `options` and calls `onExit`
# when it finishes.
run = (bin, options, onExit) ->
  bin = binPath + bin
  console.log timeNow() + ' - running: ' + bin + ' ' + (if options? then options.join(' ') else '')
  cmd = spawn bin, options
  cmd.stdout.on 'data', (data) -> #console.log data.toString()
  cmd.stderr.on 'data', (data) -> console.log data.toString()
  cmd.on 'exit', (code) ->
    console.log timeNow() + ' - done.'
    onExit?(code, options)

compileView = (done) ->
  options = ['--pretty', 'src/views/api_mate.pug', '--out', 'lib', '--obj', 'src/pug_options.json']
  run 'pug', options, ->
    options = ['--pretty', 'src/views/redis_events.pug', '--out', 'lib', '--obj', 'src/pug_options.json']
    run 'pug', options, ->
      done?()

compileCss = (done) ->
  options = ['src/css/api_mate.scss', 'lib/api_mate.css', '--no-source-map']
  run 'sass', options, ->
    options = ['src/css/redis_events.scss', 'lib/redis_events.css', '--no-source-map']
    run 'sass', options, ->
      done?()

runShell = (cmd, label, onExit) ->
  console.log timeNow() + ' - running: ' + label
  exec cmd, (error, stdout, stderr) ->
    console.log stderr if stderr
    console.log timeNow() + ' - done.'
    onExit?(error)

compileJs = (done) ->
  coffee = binPath + 'coffee'
  cmd = "cat src/js/application.coffee src/js/templates.coffee src/js/api_mate.coffee | #{coffee} --compile --stdio > lib/api_mate.js"
  runShell cmd, 'coffee (api_mate.js)', ->
    cmd = "cat src/js/application.coffee src/js/redis_events.coffee | #{coffee} --compile --stdio > lib/redis_events.js"
    runShell cmd, 'coffee (redis_events.js)', ->
      done?()

build = (done) ->
  compileView (err) ->
    compileCss (err) ->
      compileJs (err) ->
        done?()

watch = () ->
  watcher = chokidar.watch('src', { ignored: /[\/\\]\./, persistent: true })
  watcher.on 'all', (event, path) ->
    console.log timeNow() + ' = detected', event, 'on', path
    if path.match(/\.coffee$/)
      compileJs()
    else if path.match(/\.scss/)
      compileCss()
    else if path.match(/\.pug/)
      compileView()

task 'build', 'Build everything from src/ into lib/', ->
  build()

task 'watch', 'Watch for changes to compile the sources', ->
  watch()
