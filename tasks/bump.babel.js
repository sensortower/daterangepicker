const gulp = require('gulp');
const gulpLoadPlugins = require('gulp-load-plugins');

const $ = gulpLoadPlugins();


function bump(type) {
  const bump = () => {
    return gulp.src('./package.json')
      .pipe($.bump({type: type}))
      .pipe(gulp.dest('./'));
  }

  return gulp.series(bump, 'build:min');
};

gulp.task('bump:major', bump('major'));
gulp.task('bump:minor', bump('minor'));
gulp.task('bump:patch', bump('patch'));
