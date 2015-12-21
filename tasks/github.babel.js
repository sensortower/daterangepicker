import gulp from 'gulp';
import gulpLoadPlugins from 'gulp-load-plugins';

const $ = gulpLoadPlugins();


gulp.task('github:pages', ['build:website'], () => {
  return gulp.src('./dist/website/**/*')
    .pipe($.ghPages());
});

gulp.task('consistency-check', ['build:min'], (cb) => {
  exec('git status', function callback(error, stdout, stderr) {
    const pendingChanges = stdout.match(/modified:\s*dist/)
    if (pendingChanges) {
      throw new Error('consistency check failed');
    } else {
      cb();
    }
  });
});

gulp.task('github:release', ['consistency-check'], () => {
  if (!process.env.GITHUB_TOKEN) {
    throw new Error('env.GITHUB_TOKEN is empty');
  }

  var manifest = readJson('./package.json');
  const match = manifest.repository.url.split('/').slice(-2)

  return gulp.src([
    'dist/daterangepicker.js',
    'dist/daterangepicker.css',
    'dist/daterangepicker.min.js',
    'dist/daterangepicker.min.css'
  ])
    .pipe($.githubRelease({
      manifest: manifest,
      owner: match[0],
      repo: match[1]
    }));
});
