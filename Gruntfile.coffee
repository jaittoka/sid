module.exports = (grunt) ->
  grunt.initConfig 
    coffee:
      compile:
        src: 'src/sid.coffee'
        dest: 'lib/sid.js'
  

  grunt.registerTask 'default', [ 'coffee:compile' ]
  grunt.loadNpmTasks 'grunt-contrib-coffee'
