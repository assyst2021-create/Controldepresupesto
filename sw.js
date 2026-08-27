var CACHE='misfinanzas-v1';
var ASSETS=['/','index.html','/manifest.json'];
self.addEventListener('install',function(e){
  e.waitUntil(caches.open(CACHE).then(function(c){return c.addAll(ASSETS);}));
  self.skipWaiting();
});
self.addEventListener('activate',function(e){
  e.waitUntil(clients.claim());
});
self.addEventListener('fetch',function(e){
  if(e.request.method!=='GET')return;
  e.respondWith(fetch(e.request).catch(function(){return caches.match(e.request);}));
});
