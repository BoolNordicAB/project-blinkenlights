var gulp = require('gulp');
var jshint = require('gulp-jshint');
var watch = require('gulp-watch');
var stylish = require('jshint-stylish');

gulp.task('lint-watch', function() {
  return gulp.src('./src/**/*.js')
    .pipe(watch('./src/**/*.js'))
    .pipe(jshint())
    .pipe(jshint.reporter(stylish))
    .pipe(gulp.dest('dist'));
});

gulp.task('lint6-watch', function() {
  return gulp.src('./src6/**/*.js')
    .pipe(watch('./src6/**/*.js'))
    .pipe(jshint('.jshintrc6'))
    .pipe(jshint.reporter(stylish))
    .pipe(gulp.dest('dist'));
});

gulp.task('default', ['lint-watch','lint6-watch']);
