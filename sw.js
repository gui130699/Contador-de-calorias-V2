const CACHE_NAME = 'nutrix-v12';

// Detectar base path automaticamente
const BASE_PATH = self.location.pathname.replace('/sw.js', '');

const PRECACHE_URLS = [
  `${BASE_PATH}/`,
  `${BASE_PATH}/index.html`,
  `${BASE_PATH}/manifest.webmanifest`,
  `${BASE_PATH}/icons/icon-192.png`,
  `${BASE_PATH}/icons/icon-512.png`,
].map(url => new URL(url, self.location.origin).href);

self.addEventListener('install', (event) => {
  // ativa imediatamente este SW quando instalado
  self.skipWaiting();
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) =>
      // usar Promise.allSettled para não falhar o install se algum asset estiver ausente
      Promise.allSettled(PRECACHE_URLS.map((url) =>
        fetch(url, {cache: 'no-cache'}).then((resp) => {
          if (!resp || !resp.ok) throw new Error('fetch-failed');
          return cache.put(url, resp);
        }).catch((err) => {
          // recurso pode não existir (ex.: pasta icons ausente). registrar e continuar.
          console.warn('Resource not cached:', url, err);
          return null;
        })
      ))
    )
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

// Receber mensagens do cliente
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

self.addEventListener('fetch', (event) => {
  const req = event.request;
  // Strategy: network-first for navigations (SPA) with cache fallback; cache-first for other assets
  if (req.mode === 'navigate' || (req.method === 'GET' && req.headers.get('accept')?.includes('text/html'))) {
    event.respondWith(
      fetch(req).then((networkResp) => {
        // atualiza cache com a versão mais recente (clone ANTES de retornar)
        const respClone = networkResp.clone();
        caches.open(CACHE_NAME).then(c => c.put(req, respClone)).catch(() => {});
        return networkResp;
      }).catch(() => caches.match('./index.html'))
    );
    return;
  }

  event.respondWith(
    caches.match(req).then((cached) => cached || fetch(req).then((networkResp) => {
      // cachear imagens e mesmos-origem para futuras requisições (clone ANTES)
      if (req.destination === 'image' || new URL(req.url).origin === self.location.origin) {
        const respClone = networkResp.clone();
        caches.open(CACHE_NAME).then((c) => c.put(req, respClone)).catch(() => {});
      }
      return networkResp;
    }).catch(() => null))
  );
});
