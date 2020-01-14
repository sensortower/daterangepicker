// generated using generator-gulp-webapp 1.0.3
const gulp = require('gulp');
const gulpLoadPlugins = require('gulp-load-plugins');
const requireDir = require('require-dir');
const del = require('del');

const $ = gulpLoadPlugins();

requireDir('./tasks');

gulp.task('clean', del.bind(null, ['.tmp', '.publish', 'dist']));

gulp.task('travis-ci', gulp.series('build:website', () => {
  return gulp
    .src('dist/website/tests.html')
    .pipe($.mochaPhantomjs());
}));

gulp.task('default', gulp.series('clean', 'build'));
