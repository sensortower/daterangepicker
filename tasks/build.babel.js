const gulp = require('gulp');
const fs = require('fs');
const gulpLoadPlugins = require('gulp-load-plugins');
const browserSync = require('browser-sync');
const saveLicense = require('uglify-save-license');
const uglify = require('gulp-uglify-es').default;

const uglifyOptions = { output: { comments: saveLicense } };
const $ = gulpLoadPlugins();
const reload = browserSync.reload;

function readJson(path) {
  return JSON.parse(fs.readFileSync(path, 'utf8'));
}

function banner() {
  var pkg = readJson('./package.json');
  var bower = readJson('./bower.json');
  return `
    /*!
     * ${bower.name}
     * version: ${pkg.version}
     * authors: ${bower.authors}
     * license: ${bower.license}
     * ${bower.homepage}
     */
  `.replace(/\n\s{0,4}/g, '\n').replace('\n', '');
}

gulp.task('styles', () => {
  return gulp.src([
      'src/styles/*.scss',
      'website/styles/*.scss'
    ])
    .pipe($.plumber())
    .pipe($.sass.sync({
      outputStyle: 'expanded',
      precision: 10,
      includePaths: ['.']
    }).on('error', $.util.log))
    .pipe($.autoprefixer())
    .pipe(gulp.dest('.tmp/styles'))
    .pipe(reload({stream: true}));
});

gulp.task('scripts', () => {
  return gulp.src([
      'src/scripts/*.coffee',
      'website/scripts/*.coffee'
    ])
    .pipe($.include()).on('error', $.util.log)
    .pipe($.plumber())
    .pipe($.coffee().on('error', $.util.log))
    .pipe(gulp.dest('.tmp/scripts'))
    .pipe(reload({stream: true}));
});

gulp.task('build', gulp.series('scripts', 'styles', () => {
  return gulp.src(['.tmp/scripts/daterangepicker.js', '.tmp/styles/daterangepicker.css'])
    .pipe($.header(banner()))
    .pipe(gulp.dest('dist/'))
    .pipe($.size({title: 'build', gzip: true}));
}));

gulp.task('build:min', gulp.series('build', () => {
  return gulp.src(['dist/daterangepicker.js', 'dist/daterangepicker.css'])
    .pipe($.if('*.js', uglify(uglifyOptions)))
    .pipe($.if('*.css', $.cleanCss({compatibility: '*'})))
    .pipe($.if('*.js', $.extReplace('.min.js')))
    .pipe($.if('*.css', $.extReplace('.min.css')))
    .pipe(gulp.dest('dist/'))
    .pipe($.size({title: 'build:min', gzip: true}));
}));
