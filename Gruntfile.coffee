#global module:false
module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig

    # Metadata.
    pkg: grunt.file.readJSON("package.json")
    banner: "/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - " + "<%= grunt.template.today(\"yyyy-mm-dd\") %>\n" + "<%= pkg.homepage ? \"* \" + pkg.homepage + \"\\n\" : \"\" %>" + "* Copyright (c) <%= grunt.template.today(\"yyyy\") %> <%= pkg.author.name %>;" + " Licensed <%= _.pluck(pkg.licenses, \"type\").join(\", \") %> */\n"

    # Task configuration.

    # Parse CSS and vendor-prefixed CSS properties using the caniuse database
    autoprefixer:
      options:
        browsers: ['ios >= 5', 'android >= 2.3']
      dist:
        src: '_/css/styles.css'

    # Start a static web server
    # Reload assets live in the browser
    connect:
      dist:
        options:
          port: 8080
          open: 'http://localhost:8080/'

    # Grunt task that runs CSSCSS, a CSS redundancy analyzer.
    csscss:
      dist:
        src: ['_/css/styles.css']

    # Sort CSS properties in specific order
    csscomb:
      dist:
        files:
          '_/css/styles.css' : ['_/css/styles.css']

    # Lint CSS files
    csslint:
      dist:
        # options:
        #   csslintrc: '.csslintrc'
        src: ['_/css/styles.css']

    # Lint HTML files
    htmllint:
      all: ['index.html']

    # Minify HTML
    htmlmin:
      dist:
        optioins:
          removeComments: true
          collapseWhitespace: true
          collapseBooleanAttributes: true
          remoceAttributeQuotes: true
          removeRedundantAttributes: true
          useShortDoctype: true

        files: 'index.min.html': 'index.html'

    #Minify CSS files with CSSO
    csso:
      dist:
        options:
          banner: """
          /*
           * styles.css
           * Copyright 2013 Ryo Ikarashi
           * Licensed under the MIT Licensed
           */

           """
        files:
          '_/css/styles.min.css' : ['_/css/styles.css']

    # Make ImageOptim, ImageAlpha and JPEGmini part of your automated build process
    imageoptim:
      options:
        imageAlpha: false
        jpegMini: false
        quitAfter: true
      dist:
        src: ['www/img/sprite']

    # Grunt task to compile Sass SCSS to CSS
    sass:
      dist:
        files:
          '_/css/styles.css' : '_/components/sass/styles.scss'

    # Grunt task for creating spritesheets and their coordinates
    sprite:
      dist:
        src: 'www/img/sprite/tabs/*.png'
        destImg: 'www/img/sprite/tabs/tabs.png'
        imgPath: 'www/img/sprite/tabs/tabs.png'
        destCSS: 'sass/libs/_sprite.scss'
        algorithm: 'binary-tree'
        padding: 2
        cssTemplate: 'www/img/sprite/spritesmith.mustache'
        # css0pts: { functions: false }

  # Run tasks whenever watched files change
    watch:
      options:
        livereload: true

      sass:
        files: ['_/components/sass/*.scss']
        tasks: ['stylesheet']


    # SVG to webfont converter for Grunt
    webfont:
      dist:
        src: 'www/font/svg/*.svg'
        destCSS: 'www/font/'
        options:
          font: 'myfont'
          types: ['woff', 'ttf']
          stylesheet: 'scss'
          htmlDemo: false
          syntax: 'bootstrap'
          relativeFontPath: 'www/font/'

    # Minify JavaScript
    uglify:
      my_target:
        files: '_/js/script.js': ['_/components/js/script.js']

    # Validate files with JSHint
    jshint:
      options:
        curly: true
        eqeqeq: true
        immed: true
        latedef: true
        newcap: true
        noarg: true
        sub: true
        undef: true
        unused: true
        boss: true
        eqnull: true
        browser: true
        globals: true
        jQuery: true

      gruntfile:
        src: "Gruntfile.js"

      lib_test:
        src: ["lib/**/*.js", "test/**/*.js"]

  # Setting Load & Register task:
  grunt.registerTask "develop", [], ->
    grunt.loadNpmTasks "grunt-html"
    grunt.loadNpmTasks "grunt-contrib-sass"
    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.task.run "connect", "watch"

  grunt.registerTask "stylesheet", [], ->
    grunt.loadNpmTasks "grunt-autoprefixer"
    grunt.loadNpmTasks "grunt-contrib-sass"
    grunt.loadNpmTasks "grunt-csscomb"
    grunt.loadNpmTasks "grunt-csscss"
    grunt.loadNpmTasks "grunt-contrib-csslint"
    grunt.loadNpmTasks "grunt-csso"
    grunt.loadNpmTasks "grunt-contrib-htmlmin"
    grunt.task.run "sass", "autoprefixer", "csscomb", "csscss", "csso", "csslint", "htmlmin"

  grunt.registerTask "minify", [], ->
    grunt.loadNpmTasks "grunt-imageoptim"
    grunt.task.run "imageoptim"

  grunt.registerTask "js", [], ->
    grunt.loadNpmTasks "grunt-contrib-jshint"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.task.run "jshint", "uglify"

  grunt.registerTask "default", [], ->
    grunt.task.run "develop"