let cacheVersion = 'v1';
let cacheList = [
  '/',
  '/subject',
  '/subject/index'
];

self.addEventListener('install', e => {
  console.log('install');
  let cacheOpenPromise = caches.open(cacheVersion).then(cache => cache.addAll(cacheList));
  e.waitUntil(cacheOpenPromise);
});

self.addEventListener('fetch', e => {
  console.log('fetch');
  e.responseWith(
    caches.match(e.request).then(cache => {
      return cache || fetch(e.requset);
    }).catch(err => {
      console.log(err);
      return fetch(e.request);
    })
  )
})
