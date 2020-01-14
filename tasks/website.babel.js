const gulp = require('gulp');
const marked = require('marked');
const highlight = require('highlight.js');
const gulpLoadPlugins = require('gulp-load-plugins');
const browserSync = require('browser-sync');
const saveLicense = require('uglify-save-license');
const uglify = require('gulp-uglify-es').default;

const uglifyOptions = { output: { comments: saveLicense } };
const $ = gulpLoadPlugins();
const reload = browserSync.reload;


marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: true,
  smartLists: true,
  smartypants: false,
  highlight: (code, lang) => {
    return highlight.highlightAuto(code, [lang]).value;
  }
});

function markdownFilter(code) {
  code = code
    .replace(/[\s\S]*(?=#+ Notable Features)/m, '')
    .replace(/#+ Copyright[\s\S]*/m, '');
  return marked(code);
}

gulp.task('images', () => {
  return gulp.src('website/images/*')
    .pipe(gulp.dest('dist/website/images'))
});

gulp.task('html', gulp.series('styles', 'scripts', () => {
  return gulp.src('website/*.html')
    .pipe($.fileInclude({
      prefix: '@@',
      basepath: '@file',
      filters: {
        markdown: markdownFilter
      }
    })).on('error', $.util.log)
    .pipe(gulp.dest('.tmp'))
    .pipe(reload({stream: true}));
}));

gulp.task('serve', gulp.series('html', 'styles', 'scripts', () => {
  browserSync({
    notify: false,
    port: 9000,
    ghostMode: {
      clicks: false,
      forms: false,
      scroll: false
    },
    server: {
      baseDir: ['.tmp', 'website'],
      routes: {
        '/bower_components': 'bower_components',
        '/docs': '.tmp/docs.html',
        '/tests': '.tmp/tests.html',
        '/examples': '.tmp/examples.html'
      }
    }
  });

  gulp.watch([
    '{src,website}/scripts/**/*.coffee',
    'test/**/*.coffee',
    'src/templates/**/*.html',
    'website/**/*.html',
    '{docs,.}/*.md'
  ]).on('change', reload);

  gulp.watch('{src,website}/styles/**/*.scss', ['styles']);
  gulp.watch('test/**/*.coffee', ['scripts']);
  gulp.watch('{src,website}/scripts/**/*.coffee', ['scripts']);
  gulp.watch('src/templates/**/*.html', ['scripts']);
  gulp.watch('website/**/*.html', ['html']);
  gulp.watch('{docs,.}/*.md', ['html']);
}));

gulp.task('build:website', gulp.series('html', 'styles', 'scripts', 'images', () => {
  return gulp.src('.tmp/*.html')
    .pipe($.useref({searchPath: ['.tmp', 'website', '.']}))
    .pipe($.if('*.js', uglify(uglifyOptions)))
    .pipe($.if('*.css', $.cleanCss({compatibility: '*'})))
    .pipe(gulp.dest('dist/website'))
    .pipe($.size({title: 'build:website', gzip: true}));
}));

gulp.task('serve:website', gulp.series('build:website', () => {
  browserSync({
    notify: false,
    port: 9000,
    server: {
      baseDir: ['dist/website']
    }
  });
}));
