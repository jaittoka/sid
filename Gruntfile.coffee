module.exports = (grunt) ->
  grunt.initConfig 
    coffee:
      compile:
        src: 'src/main/coffee/sid.coffee'
        dest: 'lib/sid.js'
    nodeunit: {
      all: [ 'src/test/*_test.coffee' ]
    }

  grunt.registerTask 'default', [ 'coffee:compile' ]

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
