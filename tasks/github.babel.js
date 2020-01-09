const gulp = require('gulp');
const fs = require('fs');
const gulpLoadPlugins = require('gulp-load-plugins');
const childProcess = require('child_process');

const $ = gulpLoadPlugins();
const exec = childProcess.exec;


function readJson(path) {
  return JSON.parse(fs.readFileSync(path, 'utf8'));
}

gulp.task('github:pages', () => {
  gulp.start('build:website');

  return gulp.src('./dist/website/**/*')
    .pipe($.ghPages());
});

gulp.task('consistency-check', (cb) => {
  gulp.start('build:min');

  exec('git status', function callback(error, stdout, stderr) {
    const pendingChanges = stdout.match(/modified:\s*dist/)
    if (pendingChanges) {
      throw new Error('consistency check failed');
    } else {
      cb();
    }
  });
});

gulp.task('github:release', () => {
  gulp.start('consistency-check');

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
