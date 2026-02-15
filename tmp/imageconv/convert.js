const sharp = require('sharp');
const [src, outPng, outJpg] = process.argv.slice(2);
async function run(){
  await sharp(src, { density: 600 })
    .resize(7680, 3840, { fit: 'fill' })
    .png({ compressionLevel: 9, adaptiveFiltering: true })
    .toFile(outPng);

  await sharp(src, { density: 600 })
    .resize(7680, 3840, { fit: 'fill' })
    .jpeg({ quality: 95, chromaSubsampling: '4:4:4', mozjpeg: true })
    .toFile(outJpg);

  console.log('ok');
}
run().catch((e)=>{ console.error(e); process.exit(1); });
