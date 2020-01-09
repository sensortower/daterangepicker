const gulp = require('gulp');
const gulpLoadPlugins = require('gulp-load-plugins');

const $ = gulpLoadPlugins();


function bump(type) {
  return gulp.src('./package.json')
    .pipe($.bump({type: type}))
    .pipe(gulp.dest('./'))
    .pipe($.callback(() => { gulp.start('build:min'); }));
};

gulp.task('bump:major', () => {
  return bump('major');
});

gulp.task('bump:minor', () => {
  return bump('minor');
});

gulp.task('bump:patch', () => {
  return bump('patch');
});
