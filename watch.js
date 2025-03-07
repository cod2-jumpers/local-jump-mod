const { exec } = require('child_process');
const chokidar = require('chokidar');

const WATCH_DIR = './src';
const OUTPUT_FILE = './archive.iwd';

const zipFiles = () => {
  console.log('Regenerating IWD archive...');
  exec(`zip -r ${OUTPUT_FILE} ${WATCH_DIR} -x "*.git*"`, (err, stdout, stderr) => {
    if (err) {
      console.error('Error creating archive:', err);
      return;
    }
    console.log('IWD archive updated!');
  });
};

// Watch for changes
chokidar.watch(WATCH_DIR, { ignored: /(^|[\/\\])\../, persistent: true })
  .on('all', (event, path) => {
    console.log(`File ${path} changed, regenerating IWD...`);
    zipFiles();
  });

console.log(`Watching ${WATCH_DIR} for changes...`);
