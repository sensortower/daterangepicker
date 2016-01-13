// generated using generator-gulp-webapp 1.0.3
import gulp from 'gulp';
import gulpLoadPlugins from 'gulp-load-plugins';
import requireDir from 'require-dir';
import del from 'del';

const $ = gulpLoadPlugins();

requireDir('./tasks');

gulp.task('clean', del.bind(null, ['.tmp', '.publish', 'dist']));

gulp.task('travis-ci', ['build:website'], () => {
  return gulp
    .src('dist/website/tests.html')
    .pipe($.mochaPhantomjs());
});

gulp.task('default', ['clean'], () => {
  gulp.start('build');
});
